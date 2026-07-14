# Session D — judge and land

1. Re-read acceptance criteria, `progress.md`, all `.done.md` files, and the final diff.
2. Run the full DoD from a clean, combined tree.
3. For material changes, dispatch `blind-judge` read-only or run the appropriate review skill. Deterministic failing checks outrank a favorable narrative verdict.
4. Fix any blocking issue and repeat the gate.
5. Present the outcome and request the missing authority if landing requires a push, PR, release, or merge not already authorized.
6. Land with the user's git identity and no AI attribution.
7. Write `state.md` as `state: landed` only after the requested landing action succeeds. If the user declines, write `state: parked` and preserve a resume handoff.
8. Run or offer `~/.codex/cleaning/README.md` after the cycle is safely landed or abandoned.
