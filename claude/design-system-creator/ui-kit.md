# ui-kit.md — component inventory + spec format

How `design/UI-KIT.md` gets filled: what to inventory, how to spec one component tightly, and the optional live-preview kit. A spec is done when a stranger session can build the component from it without asking anything.

## Inventory

Two tiers. Core is where every product starts (interview P3.1 picks the first eight to spec fully); extended enters when the Brief demands it. Every row appears in `design/UI-KIT.md` with status `live` (specced + built), `specced`, or `planned` — never silently absent.

| Tier | Components |
|------|------------|
| **Core** | icons (set + grid + stroke), buttons, inputs (text/select/textarea), checkboxes, radios, toggles, badges, avatars, tooltips, progress (bar/spinner/skeleton), text styles, color styles, effects (shadow/blur/focus rings) |
| **Extended** | cards, tables, modals/sheets, navigation (bar/tabs/breadcrumb), toasts/alerts, widgets, imagery & graphics rules, templates & layouts, code components |

Text styles, color styles, effects are pointers into FOUNDATIONS (tokens), restated in the kit only as usage rules — never re-declared values.

## Spec format

One block per component in `design/UI-KIT.md`:

```markdown
### Button — live
anatomy: container + label (+ leading icon). paddings 12×20px (md), radius --radius, gap 8px
variants: primary (--color-accent) · secondary (outline --color-line) · ghost · destructive (--color-danger)
sizes: sm 32px · md 40px · lg 48px height; touch min 44px hit area regardless of visual size
states: default / hover / active / focus (--color-focus ring 2px) / disabled (no hover, cursor default) / loading (spinner replaces label, width locked)
a11y: role button; label = verb phrase; icon-only needs aria-label; contrast per §Floors
content: verb-first, ≤3 words, no terminal punctuation (VOICE owns tone)
code: <path to the component in this repo, or "planned">
```

Rules:

- **States are the spec.** Every interactive component declares all seven (default/hover/active/focus/disabled/loading/error) or names which don't apply and why. Unstated states are where inconsistency breeds.
- **Tokens only.** A spec references `--color-*`/`--radius`/spacing steps — a raw hex or px value not in FOUNDATIONS is a validator-caught leak.
- **A11y line is mandatory** per component: role, labeling rule, contrast note, target size. Inherits §Floors; may tighten, never loosen.
- **Content line** hooks VOICE: casing, length cap, tone pointer — so writers and builders read the same contract.
- ≤10 lines per component. The cap forces the kit to stay a reference, not documentation sprawl.

## Live kit (optional)

When the target repo should carry runnable previews: `design/ui-kit/<component>/index.html` — one self-contained HTML per component showing all variants × states on FOUNDATIONS tokens (inline CSS custom properties). First line carries a card marker for tooling:

```html
<!-- @dsCard group="Buttons" -->
```

Worth building when the repo has UI review needs or non-dev stakeholders; skip for API/CLI products.

## Claude Design sync (optional)

With a claude.ai login, the live kit can mirror into a Claude Design project so the system is browsable outside the repo:

1. `/design-login` if the session lacks design authorization.
2. `DesignSync list_projects` → pick or `create_project` (type must be design-system).
3. Sync incrementally via the `/design-sync` skill — one component at a time, `finalize_plan` → `write_files`, never wholesale replace.

The repo stays the source of truth; the Claude Design project is a viewport. No login / tool absent → skip, note it once, nothing else depends on it.
