# MULTI_DEVICE_ECOSYSTEMS

## Purpose

Decides how one product behaves across screen sizes, input methods, sessions, and platforms: responsive layout systems, device continuity, input adaptation, state persistence, and the platform-convention-vs-brand tradeoff. Load when a design must survive more than one device class.

## Principles

- Design the ecosystem, not the device. Google's multi-screen study (2012) found ~90% of users move tasks between screens sequentially (start on phone, finish on laptop) far more often than they use screens simultaneously. The unit of design is the task journey; a device is one viewport onto it. [E]
- Content defines breakpoints, hardware does not. Device-model breakpoints (e.g. "iPad width") rot with every product cycle; layouts break where the content breaks — a text measure drifting past readable width, a grid cell starving below its minimum. Resize until it looks wrong; that pixel is the breakpoint. [E]
- Capability, not category. Laptops have touchscreens, tablets pair keyboards, TVs gain pointers. Branching on device class produces wrong affordances at the margins; branch on detected capabilities — pointer precision, hover availability, viewport, orientation — which cannot lie. [E]
- Re-entry cost decides continuity. Users resume a cross-device task only while resumption effort is lower than the task's remaining perceived value; every step to re-find state (log in, navigate, scroll) burns that margin. Continuity design is the minimization of re-entry steps, not a sync feature list. [H]
- Consistency is a hierarchy, not a mirror. Cross-device sameness matters in this order: data/state > voice and brand > information architecture > layout > interaction idiom. Users forgive a different layout instantly; they never forgive missing data. Pixel-identical UIs across platforms usually mean at least one platform got a foreign body. [H]
- Ergonomics shift with posture and distance. Phone at ~30 cm one-handed, desktop at 50–70 cm with a precision pointer, TV at ~3 m with a five-button remote: angular size, reach zones, and error costs all change, so type scale, target size, and control placement must change with them — same content, different physics. [E]
- Interruption is the default state. Mobile sessions are frequently abandoned mid-task (calls, notifications, pocket); a multi-device product that loses a draft on suspend punishes normal behavior. Persist as if the process dies any second — because on mobile OSes it does. [E]

## Rules

### Responsive layout

- Set breakpoints where the content degrades, typically where body-text measure exits 45–75 characters per line or a grid cell falls below its content minimum — never at named device widths. [E]
- Between breakpoints, scale fluidly (interpolate type and spacing between a floor and a ceiling, e.g. body 16px on small viewports up to 18–20px on large); breakpoints reflow structure, fluid scaling handles everything in between. [H]
- Size components against their container, not the viewport: a card in a sidebar and the same card full-width are different widths on one screen. Viewport-only logic breaks the moment layouts nest. [E]
- Touch targets ≥44×44 pt (iOS) / 48×48 dp (Android) — ~9 mm physical, the reliable fingertip contact patch; precision-pointer targets ≥24×24 px (WCAG 2.2). Adjacent targets get ≥8 px gap so misses land on nothing rather than the wrong action. [E]
- On handheld one-handed use, place primary actions in the bottom third of the screen (thumb's natural arc) and keep destructive actions out of the thumb-rest zone to prevent accidental triggers. [E]
- TV / 10-foot UI: body text ≥24 px at 1080p (≈2× desktop, compensating ~4× viewing distance), keep content inside a ~5% safe margin from screen edges, and render a visible focus state at all times — the focus ring is the cursor. [E]

### Input adaptation

- Budget target sizes by Fitts's law — acquisition time grows with log2(2D/W): distant or small targets are slow and error-prone on every input, worst on coarse pointers. Enlarge and edge-anchor frequent targets (screen edges have effectively infinite width for pointers). [E]
- Hover is an enhancement, never a gate: any affordance revealed on hover (menus, tooltips, action buttons) needs an equivalent tap or focus path, or touch and keyboard users lose the feature entirely. [E]
- Keyboard parity: every flow completable with keyboard alone; focus order matches visual order; a visible focus indicator on every interactive element. This serves power users, remotes, and switch access with one investment. [E]
- Remote/gamepad (focus-driven) navigation: arrange focusables in a spatial grid where arrow keys move in the expected direction; any element reachable within ~12 presses from screen entry, else add shortcut jumps (section skips, letter indexes). [H]
- Custom gestures (swipe actions, long-press, pinch) always duplicate a visible control: gestures are invisible, undiscoverable by inspection, and inconsistent across platforms — treat them as accelerators for experts, not primary paths. [E]
- Voice/no-screen entry points expose task verbs, not menu trees: a user who says "resume my draft" must land in state without visually navigating. [H]

### Continuity and handoff

- Deep-link to state, not to screens: resuming on a second device lands in the same document, scroll region, and mode within ≤2 interactions and ≤10 s, including auth (biometric or already-signed-in — a password wall kills handoff). [H]
- Label the resume affordance with its origin ("Continue reading from iPhone"): naming the source device confirms the state is really theirs and really current, which is the trust barrier to tapping it. [H]
- Optimize sequential handoff (leave device A, pick up device B later) before simultaneous multi-screen use — it is the dominant real-world pattern; simulcast features serve a minority. [E]
- Continuity surfaces are offers, never seizures: prompt to resume, don't auto-jump the UI. Uninvited state changes violate user control and misfire whenever the prediction is wrong. [E]

### State persistence

- Local-first with optimistic writes: apply the user's change to the local UI immediately, sync in background, reconcile on return. Waiting on a round-trip per keystroke makes latency the interface. [E]
- Autosave continuously — debounce 1–2 s after last input; never require a manual save for user-generated content. Manual save is a prosthetic for the machine's memory, and its cost is paid in lost work. [E]
- Persist micro-state, not just documents: scroll position, draft text, form fields, selected tab, playback position — restored on next open on any device. Micro-state is what makes resumption feel like continuation rather than restart. [E]
- Conflict policy by data ownership: single-owner data (settings, one person's draft) may use last-write-wins; shared or mergeable data needs field-level merge or a user-facing choice. Silently discarding either version is data loss wearing a sync badge. [H]
- Show sync status only when actionable (offline, conflict, failure — with a retry path); a permanently visible "synced ✓" trains users to ignore the indicator that matters when it flips. [H]

### Cross-platform conventions

- Follow each platform's system idioms — back behavior, share mechanisms, navigation placement, settings location — while keeping brand color, type, and voice constant. Users spend >99% of their time in other apps (Jakob's law generalized to platforms); fighting the OS taxes every interaction. [E]
- Parity of capability, not of layout: every task completable on every supported device, but entry points, density, and flow may differ. Cutting a capability from a device class forces device-switching at the moment of need. [H]
- Assign each device class a primary role from real usage (phone = capture/triage, desktop = production, TV = consumption) and tune each UI's information density and defaults to its role instead of shipping one median UI everywhere. [H]

## Decision guide

| Situation | Do |
|---|---|
| Layout looks broken between breakpoints | Add fluid scaling / container-based sizing, not another device breakpoint |
| Feature hides behind hover or gesture | Add a visible tap/focus-reachable equivalent |
| Users restart tasks after switching devices | Audit re-entry: deep-link + auth ≤2 interactions, restore micro-state |
| Sync conflict possible | Single-owner → last-write-wins; shared → field merge or user choice; never silent discard |
| Porting to TV or console | Focus-grid navigation, ≥24 px body text, 5% safe margins, visible focus always |
| Brand vs native-idiom tension | Keep brand color/type/voice; adopt platform navigation and system behaviors |
| Deciding what each device version shows | Same capabilities everywhere; density and defaults per device role |
| Data loss reports on mobile | Autosave (1–2 s debounce) + persist drafts/scroll/form state across suspend |

## Cross-refs

- [[LAYOUT_MATHEMATICS]] — grid, spacing, and measure math underlying fluid layout rules.
- [[ACCESSIBILITY_AND_INCLUSION]] — target size, focus, and keyboard parity as mandates, not options.
- [[PERFORMANCE_PERCEPTION]] — perceived latency of sync, optimistic UI, and waiting states.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — transition continuity when layouts reflow across form factors.
- [[INFORMATION_ARCHITECTURE]] — keeping structure and findability parity when navigation shifts per device.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — runtime adaptation beyond static breakpoints and capability checks.
