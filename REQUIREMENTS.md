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
  jq make node ollama pipx python@3.12 ripgrep tesseract tldr tmux tree wget zoxide zsh
```

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
| gh   | 2.93 | brew (above), then `gh auth login` |

Not installed (skip unless needed): pnpm, yarn, go, docker, uv, java.

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

Check the repo for a bootstrap/install script; if none, symlink `.zshrc`, `.zprofile`, `.gitconfig` manually from the repo.

`.gitconfig` essentials (already in repo): user `Andrew`, email `rzzp5q7pxm@privaterelay.appleid.com`, git-lfs filters. Install lfs: `brew install git-lfs && git lfs install`.

## 6. RTK (Rust Token Killer)

Custom binary at `~/.local/bin/rtk` (v0.42.4) — NOT from brew or crates.io. Source unknown to this audit.

- [ ] Locate the rtk source repo / release. Build or copy binary to `~/.local/bin/rtk`.
- [ ] Verify: `rtk --version` → `rtk 0.42.4`, and `rtk gain` works (not "command not found").
- [ ] ⚠️ Name collision: do NOT install reachingforthejack/rtk (Rust Type Kit) — different tool.
- [ ] Claude Code hook auto-rewrites commands to `rtk ...`; hook config lives in dotfiles `claude/settings.json`.

## 7. Applications (installed manually — re-download)

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

## 8. VS Code extensions

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

## 9. Verify

- [ ] `brew leaves` matches step 2 list
- [ ] `git config user.email` → privaterelay address; `git lfs version` works
- [ ] `node -v`, `bun -v`, `rustc --version`, `gh auth status`
- [ ] `rtk --version` + `rtk gain`
- [ ] `ls -la ~/.claude/*.md ~/.claude/settings.json` all show symlinks into dotfiles
- [ ] Karabiner remaps active; Rectangle shortcuts work; Hammerspoon loaded
- [ ] VS Code: `code --list-extensions | wc -l` ≈ 40

---

### Gaps to resolve before relying on this
- **RTK source location** — find where the binary is built from. Single biggest unknown.
- **SSH keys** — confirm agent provider holds them; this machine has no on-disk keypair.
- **dotfiles bootstrap** — check if repo has an install script; if not, document exact symlink targets for `.zshrc`/`.zprofile`/`.gitconfig`/hammerspoon/karabiner.
