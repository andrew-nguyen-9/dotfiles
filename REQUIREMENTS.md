# MacBook Setup Requirements

Reproduce this machine on fresh macOS. Generated 2026-06-24 from live system audit.
Work top to bottom. Most config lives in the `dotfiles` repo — clone it first, symlink, done.

---

## 0. Pre-wipe: back these up (NOT in dotfiles repo)

These do NOT exist in git. Lose them = lose them. Copy off before wiping.

- [ ] `~/.ssh/` — `known_hosts` + the `agent/` socket dir. No keypair on disk (you use an SSH agent). Confirm your keys live in the agent provider (1Password / Secretive) and you can re-add them.
- [ ] `~/.claude/settings.local.json` (133B, machine-local, not symlinked) and `~/.claude/CLAUDE.md.bak` if wanted.
- [ ] Any uncommitted work in `~/Documents/GitHub/*` — `git status` every repo, push or stash.
- [ ] App data not in cloud: Hammerspoon spoons (if any beyond repo), Alfred 5 prefs/workflows (Alfred syncs via its own folder — check Alfred > Advanced > Sync), Rectangle prefs.
- [ ] OneDrive / OneNote — confirm fully synced before wipe.
- [ ] iCloud Keychain / Apple ID logged in (covers Safari, passwords).
- [ ] Browser profiles: Chrome + Zen — sign into sync so bookmarks/extensions restore.
- [ ] Steam, Spotify, BlueStacks — cloud accounts, just re-login. No backup needed.

---

## 1. macOS base

- [ ] Sign into Apple ID → iCloud, App Store.
- [ ] Install Command Line Tools: `xcode-select --install`

## 2. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then formulae (exact `brew leaves` from old machine):

```sh
brew install bat coreutils curl eza ffmpeg fzf gh git htop imagemagick \
  jq make node ollama pipx python@3.12 ripgrep tesseract tldr tmux tree wget zoxide zsh \
  uv git-lfs
```

(`uv` provides `uvx` — required by the serena Claude Code MCP plugin. `git-lfs` for the gitconfig lfs filters.)

No casks were installed via brew — apps below were installed manually. Optional: switch to casks (`brew install --cask ...`) for easier future updates.

## 3. Shell (zsh)

Already default (`/bin/zsh`). Config comes from dotfiles (step 5). For reference, `~/.zprofile` + `~/.zshrc` set:
- `eval "$(/opt/homebrew/bin/brew shellenv zsh)"`
- PATH prepends: `/opt/homebrew/bin`, `$HOME/.local/bin`, `$HOME/.bun/bin`
- bun completions

## 4. Languages / runtimes

| Tool | Version on old machine | Install |
|------|------|---------|
| node | v26 | via brew (above) |
| npm  | 11.x | bundled with node |
| bun  | 1.3.x | `curl -fsSL https://bun.sh/install \| bash` |
| python | 3.14 (system) + 3.12 (brew) | brew python@3.12; 3.14 was default — install via brew if needed |
| pipx | — | brew (above), then `pipx ensurepath` |
| rust | 1.96 | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` (gives cargo, clippy, rustfmt, rust-analyzer) |
| gh   | 2.93 | brew (above), then `gh auth login` (scopes: repo, read:org, gist) |
| uv   | 0.11 | brew (above) — provides `uvx`, needed by serena MCP plugin |

Not installed (skip unless needed): pnpm, yarn, go, docker, java.

## 5. dotfiles repo (the important part)

Holds zsh config, git config, Claude config, Hammerspoon, Karabiner.

```sh
mkdir -p ~/Documents/GitHub && cd ~/Documents/GitHub
git clone https://github.com/andrew-nguyen-9/dotfiles.git
```

Then symlink (matches current layout):

```sh
ln -sf ~/Documents/GitHub/dotfiles/claude/CLAUDE.md   ~/.claude/CLAUDE.md
ln -sf ~/Documents/GitHub/dotfiles/claude/RTK.md      ~/.claude/RTK.md
ln -sf ~/Documents/GitHub/dotfiles/claude/settings.json ~/.claude/settings.json
# zshrc, zprofile, gitconfig, hammerspoon, karabiner — symlink from repo to ~ as stored there
```

**Critical:** `claude/settings.json` is symlinked into `~/.claude/`, and the Claude Code runtime rewrites it on launch (key reorder). That makes the tracked file perpetually dirty and blocks every `git pull --rebase` with "you have unstaged changes." After cloning, tell git to ignore that churn:

```sh
git -C ~/Documents/GitHub/dotfiles update-index --skip-worktree claude/settings.json
```

(`--skip-worktree` is per-clone, not stored in the repo — must re-run on every fresh machine. To intentionally commit a real settings change later: `--no-skip-worktree`, commit, then re-set it.)

Check the repo for a bootstrap/install script; if none, symlink `.zshrc`, `.zprofile`, `.gitconfig` manually from the repo.

`.gitconfig` essentials (already in repo): user `Andrew`, email `rzzp5q7pxm@privaterelay.appleid.com`, git-lfs filters. Install lfs: `brew install git-lfs && git lfs install`.

## 6. RTK (Rust Token Killer)

Custom binary at `~/.local/bin/rtk` (v0.42.4) — NOT from brew or crates.io. Source unknown to this audit.

- [ ] Locate the rtk source repo / release. Build or copy binary to `~/.local/bin/rtk`.
- [ ] Verify: `rtk --version` → `rtk 0.42.4`, and `rtk gain` works (not "command not found").
- [ ] ⚠️ Name collision: do NOT install reachingforthejack/rtk (Rust Type Kit) — different tool.
- [ ] Claude Code hook auto-rewrites commands to `rtk ...`; hook config lives in dotfiles `claude/settings.json`.

## 7. Claude Code — MCP plugins & auth

Plugins are configured in `claude/settings.json` (in the dotfiles repo). After clone, each needs setup:

- [ ] **serena** — launches via `uvx --from git+https://github.com/oraios/serena serena start-mcp-server`. Needs `uv` (step 2/4). Pre-warm so first connect isn't a multi-minute build: `uvx --from git+https://github.com/oraios/serena serena --help`. Then `/plugin` → reconnect, or restart Claude Code.
- [ ] **github** — auths via a **PAT in an env var**, not OAuth. The plugin sends `Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}`; if unset → HTTP 400. Wire it from gh's own token (machine-local, NOT in the dotfiles repo):
  ```sh
  cd ~/.claude && TOK=$(gh auth token) && \
    jq --arg t "$TOK" '.env.GITHUB_PERSONAL_ACCESS_TOKEN=$t' settings.local.json > .sl.tmp && mv .sl.tmp settings.local.json
  ```
  Env vars load at Claude Code startup → **restart the app** (a `/mcp` reconnect alone won't pick it up). If the token is later revoked/rotated, re-run the snippet.
- [ ] **vercel** — OAuth. Run `/mcp` → vercel → Authenticate. **The default browser is Zen, whose tracking/cookie blocking makes Vercel's consent page throw "configuration error with this app."** Do the OAuth in Chrome: copy the auth URL into Chrome, or temporarily set Chrome as default web browser, authenticate, switch back.
- [ ] **xcodebuild** (XcodeBuildMCP) — Mac/iOS app dev. NOT a marketplace plugin; a user-scope MCP server in `~/.claude.json` (so not reproduced by cloning dotfiles — re-add manually):
  ```sh
  claude mcp add -s user xcodebuild -- npx -y xcodebuildmcp@latest mcp
  ```
  Note the trailing `mcp` subcommand — without it the server just prints usage and "Failed to connect." Requires **full Xcode.app** (App Store), not just Command Line Tools: `sudo xcode-select -s /Applications/Xcode.app`. Connects on Claude Code restart. Build/simulator/device tools need Xcode; project discovery/scaffolding don't.

Verify all: `claude mcp list` → serena / github / vercel / xcodebuild all ✔ Connected.

**Per-project MCP (not global — add inside the repo that uses it):**
- **dbt** — for repos with dbt pipelines (trivia-generator, music-festival-analyzer). Adding globally = a server that fails every session with no project dir, so scope it to the repo:
  ```sh
  cd <dbt-repo> && claude mcp add -s project dbt \
    -e DBT_PROJECT_DIR="$PWD" -e DBT_PATH="$(which dbt)" \
    -- uvx dbt-mcp
  ```
  Needs `dbt` installed in that repo. Writes to the repo's `.mcp.json` (committed with the project, not dotfiles).

## 8. Git commit signing (Verified badge)

SSH signing (git ≥ 2.34). No auth/signing key exists on a fresh machine — generate one:

```sh
ssh-keygen -t ed25519 -C "git signing key (andrew)" -f ~/.ssh/id_ed25519_signing -N ""

git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_signing.pub
git config --global commit.gpgsign true
git config --global tag.gpgsign true
# GitHub noreply email — always verified-eligible, hides real address, still maps to the account
git config --global user.email "284437207+andrew-nguyen-9@users.noreply.github.com"
# local verification
printf '%s namespaces="git" %s\n' "284437207+andrew-nguyen-9@users.noreply.github.com" "$(cat ~/.ssh/id_ed25519_signing.pub)" > ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Then register the **public** key on GitHub: https://github.com/settings/ssh/new → Key type = **Signing Key** → paste `~/.ssh/id_ed25519_signing.pub`.

- Add via the web UI, **not** `gh ssh-key add` — that needs the `admin:ssh_signing_key` scope and `gh auth refresh` can rotate the token the github MCP plugin (§7) depends on.
- Verify: `git log --show-signature -1` shows "Good signature"; pushed commits show **Verified** on GitHub.
- Note: the email above differs from the gitconfig's privaterelay address. To keep privaterelay instead, add+verify it on GitHub first, else commits show Unverified. Old commits stay unverified (don't rewrite history).

## 9. Applications (installed manually — re-download)

**Dev:**
- [ ] Visual Studio Code — restore extensions (step 8)
- [ ] GitHub Desktop
- [ ] Claude.app (Claude Code lives here too)

**Window / input / automation:**
- [ ] Rectangle (window snapping)
- [ ] Hammerspoon (config in dotfiles)
- [ ] Karabiner-Elements + Karabiner VirtualHIDDevice Manager (config in dotfiles) — needs Input Monitoring permission
- [ ] Alfred 5 (launcher; sync workflows/prefs)

**Browsers:** Chrome, Zen

**Microsoft 365:** Outlook, Word, Excel, PowerPoint, OneNote, OneDrive, Defender — sign into work/school account

**Media / games / misc:** Spotify, Steam, BlueStacks + BlueStacks Air, BlueAI, Ollama.app (CLI ollama also via brew)

> After install, grant macOS permissions: System Settings > Privacy & Security > Accessibility (Rectangle, Hammerspoon, Karabiner), Input Monitoring (Karabiner), Full Disk (Defender if required).

## 10. VS Code extensions

```sh
for ext in andrepimenta.claude-code-chat anthropic.claude-code beardedbear.beardedtheme \
  christian-kohler.npm-intellisense davidanson.vscode-markdownlint docker.docker \
  donjayamanne.githistory eamodio.gitlens ecmel.vscode-html-css \
  firefox-devtools.vscode-firefox-debug formulahendry.docker-explorer \
  github.vscode-github-actions kickbacksai.kickbacks-ai mechatroner.rainbow-csv \
  ms-azuretools.vscode-containers ms-azuretools.vscode-docker ms-dotnettools.vscode-dotnet-runtime \
  ms-mssql.data-workspace-vscode ms-mssql.mssql ms-mssql.sql-bindings-vscode \
  ms-mssql.sql-database-projects-vscode ms-python.debugpy ms-python.python \
  ms-python.vscode-pylance ms-python.vscode-python-envs ms-toolsai.jupyter \
  ms-toolsai.jupyter-keymap ms-toolsai.jupyter-renderers ms-toolsai.vscode-jupyter-cell-tags \
  ms-toolsai.vscode-jupyter-slideshow ms-vscode-remote.remote-containers \
  ms-vscode.cmake-tools ms-vscode.cpp-devtools ms-vscode.cpptools \
  ms-vscode.cpptools-extension-pack ms-vscode.cpptools-themes ms-vscode.cmake-tools \
  mtxr.sqltools yoavbls.pretty-ts-errors; do code --install-extension "$ext"; done
```

(Note: Docker extensions assume Docker installed — not on old machine. Install Docker Desktop or skip those.)

## 11. Verify

- [ ] `brew leaves` matches step 2 list; `uv --version` + `uvx --version` work
- [ ] `git config user.email` → noreply address; `git lfs version` works
- [ ] `node -v`, `bun -v`, `rustc --version`, `gh auth status`
- [ ] `rtk --version` + `rtk gain`
- [ ] `ls -la ~/.claude/*.md ~/.claude/settings.json` all show symlinks into dotfiles
- [ ] `git -C ~/Documents/GitHub/dotfiles ls-files -v claude/settings.json` shows `S` (skip-worktree set); `git pull --rebase` doesn't error
- [ ] `claude mcp list` → serena / github / vercel / xcodebuild all ✔ Connected (xcodebuild needs Xcode.app)
- [ ] `git log --show-signature -1` → "Good signature"; new pushed commit shows Verified on GitHub
- [ ] Karabiner remaps active; Rectangle shortcuts work; Hammerspoon loaded
- [ ] VS Code: `code --list-extensions | wc -l` ≈ 40

---

### Gaps to resolve before relying on this
- **RTK source location** — find where the binary is built from. Single biggest unknown.
- **SSH auth key** — only a *signing* key is covered (§8). No auth key on disk (push is HTTPS + gh token). Generate/restore one if you need SSH git/remote auth.
- **dotfiles bootstrap** — no install script in repo yet. A `bootstrap.sh` should: symlink `.zshrc`/`.zprofile`/`.gitconfig`/claude/hammerspoon/karabiner, run the §5 `--skip-worktree`, wire the §7 github token, and run §8 signing setup.
