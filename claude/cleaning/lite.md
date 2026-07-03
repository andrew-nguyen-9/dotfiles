# lite.md — post-cycle reset

For right after an orchestrating cycle lands, or any repo with only obvious junk. **One pass, one manifest, <~15 paths.** Routed here from `README.md`.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena. Output styles off. Obey `README.md` §Invariants.

## Flow

1. **Preflight.** `rtk git status` — uncommitted real work → commit or stash it first (cleaning commits stay pure). Post-cycle: confirm the cycle actually landed (main contains the integration merge; no in-flight unit branches) before touching its state.
2. **Gitignore.** Patch `.gitignore` from `structure.md` §gitignore baseline; untrack newly-ignored paths: `git rm -r --cached -q <path>`.
3. **Manifest → approve → execute.** Spent state only, per `structure.md` §junk table: `.orchestrator/` (landed cycle), scratch/tmp/debug files, `.DS_Store`, committed build artifacts, dead handoff/plan files (content shipped — verify via `git log --oneline -5 -- <path>`). Table `action | path | reason` → ONE AskUserQuestion → execute.
4. **Branch prune.** `git branch --merged main | grep -v ' main'` → `git branch -d` each (safe-delete only, never `-D`). Stale *unmerged* branches → list in summary, don't touch.
5. **Land.** `git commit -q` (`chore: post-cycle cleanup`) + caveman summary: deleted / untracked / pruned counts.

**Escalate:** doc sprawl, renames, or a docs refresh needed → `medium.md`. Save the manifest state first.
