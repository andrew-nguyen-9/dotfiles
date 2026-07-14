# SENSORY_DESIGN

## Purpose

Decides when and how to use sound, haptics, and environmental adaptation, and how to combine channels so they reinforce rather than compete. Load when designing feedback beyond the screen: audio cues, vibration patterns, alerts, or context-aware behavior.

## Principles

- Multisensory redundancy beats single-channel intensity: the same event coded on two channels (e.g., flash + tick) is detected faster and more reliably than one loud channel — crossmodal integration sums weak signals (superadditivity, Stein & Meredith's multisensory neurons). Add a channel before adding volume. [E]
- Sensory channels carry meaning pre-attentively: pitch, sharpness, and vibration texture are read before words. High pitch maps to small/bright/fast, low pitch to large/heavy/slow (crossmodal correspondence; kiki/bouba replicates across cultures). Fighting these mappings costs learnability. [E]
- Sound and haptics are interruptions by default: vision waits to be looked at; audio and vibration seize attention whether wanted or not. Every non-visual cue must justify the seizure — reserve them for events the user would regret missing. [E]
- Perceived simultaneity is a window, not a point: audio–visual events feel simultaneous within roughly ±80 ms, haptic–audio within roughly ±25 ms. Outside the window the pairing reads as two events and the reinforcement collapses (temporal binding window research). [E]
- Habituation destroys signal: identical repeated cues stop reaching awareness within days (orienting-response habituation). A sound heard 50 times a day is functionally silence — budget cue frequency like screen space. [E]
- The environment is a design input, not noise: ambient loudness, motion, grip, light, and social setting decide which channels work at all. A cue that ignores context (full-volume chime in a meeting) damages trust in the whole system. [E]
- Silence and stillness are the baseline that gives cues meaning: a sparse sensory palette makes each event legible; a dense one is texture, not information — same mechanism as visual signal-to-noise. [H]
- Sensory identity is brandable: a consistent sound/haptic palette (shared timbre, motif, envelope family) is recognized like a logo (sonic branding recall studies; e.g., interval motifs outperform spoken names in recall). Pick a palette; never one-off cues. [E]

## Rules

### Sound

- Feedback earcons: 50–200 ms. Notifications: ≤2 s. Anything longer is content, not a cue. [H]
- Keep primary energy between 1–4 kHz — the loudness-sensitivity peak (ISO 226 equal-loudness contours) and the band tiny speakers reproduce; expect nothing below 200 Hz from phone speakers. [E]
- Alerts demanding action: 2–3 kHz fundamental with fast attack (<10 ms). Ambient/confirm cues: slower attack (≥30 ms), lower band; abrupt onsets trigger startle, so save them for urgency. [E]
- Mix UI sounds 10–20 dB below concurrent media/content level; never full-scale. A cue should sit above ambient, below speech. [H]
- Distinct earcon vocabulary: ≤6 sounds per product. Beyond that, recognition drops to guessing (working-memory span; earcon-set studies show accuracy falling past 6–7 items). Build them as one family: same timbre, different motif. [E]
- Map pitch direction to semantics: rising contour = success/opening/arrival, falling = failure/closing/departure. This correspondence is near-universal and free to exploit. [E]
- Success/neutral events: consonant intervals. Errors: dissonance or a flat-falling contour — never a loud buzzer; punishment sounds train users to dread, then mute, the product. [H]
- Never require sound: every audio cue has a visual or haptic sibling. Assume 100% of users are situationally deaf some of the time (muted, headphones off, noisy room). [E]
- Respect the platform mute state absolutely; the only exceptions are user-armed alarms and emergency alerts the user explicitly opted into. [E]

### Haptics

- Transient taps: 10–30 ms. Texture/pattern elements: separate pulses by ≥50 ms or they fuse into one buzz (vibrotactile temporal acuity). [E]
- Design around 150–300 Hz actuator resonance — Pacinian corpuscles peak near 250 Hz; this is where a weak motor feels strongest. [E]
- Distinguishable vocabulary: ≤4 patterns without training (identification accuracy collapses faster for touch than audition). Vary rhythm, not just intensity — rhythm is the most discriminable haptic dimension. [E]
- Match haptic sharpness to event semantics: crisp single transient = discrete state change (toggle, detent, snap); soft/long = continuous or ambient (drag limits, warnings building). [H]
- Fire the haptic at the moment of the modeled physical event — the detent click when the value locks, not when the finger lifts. Haptics simulate mechanics; mistimed mechanics feel broken, not decorative. [H]
- Continuous vibration >2 s numbs the skin (rapid mechanoreceptor adaptation) and drains attention; pulse instead. [E]
- Honor system-level haptic-off settings; offer per-feature intensity where the platform allows. [E]

### Environmental context

- Critical alerts escalate across channels, quietest first: visual → haptic → audio, with 3–10 s between steps, stopping at acknowledgment. Non-critical events never escalate. [H]
- Above ~70 dB ambient noise, audio cues are masked — shift weight to haptics (on-body) or high-contrast visuals. If the mic/sensors expose ambient level, adapt; if not, let users set a context profile (pocket, desk, car). [E]
- In-motion contexts (walking, driving): minimum target sizes and haptic confirmation matter more; suppress low-priority cues entirely — divided attention, not screen size, is the constraint. [E]
- Dark environments: cut cue loudness and screen luminance together; a full-volume chime at night is the auditory equivalent of a white flash (dark-adapted senses are more sensitive). [H]
- Detect social context conservatively: when uncertain whether the user is in company, default to the least intrusive channel that still works. Cost asymmetry: a missed nicety is cheap, a public interruption is expensive. [H]

### Multi-sensory reinforcement

- Pair channels inside the binding window: audio within ±80 ms of the visual event, haptic within ±25 ms of audio. On the web/desktop where haptics are absent, sync audio to the animation's contact frame, not its start. [E]
- One event, one meaning, all channels agreeing: the error flash, error sound, and error buzz must share semantics (sharp, falling, dissonant). Conflicting channels are worse than one channel (McGurk-type interference). [E]
- Redundant-code every critical alert on ≥2 channels — this is the accessibility floor (deaf users get the visual+haptic pair, blind users the audio+haptic pair) and the noisy-environment floor for everyone else. [E]
- Reserve full three-channel moments (visual + audio + haptic) for peak events — completion of a rare, high-stakes flow; ≤1 such moment per session, or it habituates into wallpaper. [H]
- Never add a channel to compensate for a weak primary signal — fix the visual first; extra channels multiply a clear message and amplify a confusing one. [H]

## Decision guide

| Situation | Do |
|---|---|
| User-initiated action, result on-screen | Visual feedback only; optional haptic detent if it models a physical mechanism |
| Result off-screen or delayed | Haptic first; add sound only if the device is likely out of hand |
| Critical, must-not-miss alert | Redundant ≥2 channels + escalation ladder (visual → haptic → audio) |
| Ambient/FYI event | Visual only, no interruption channels; batch if frequent |
| Designing a new cue | Derive from the existing palette family; check vocabulary budget (≤6 sounds, ≤4 haptics) |
| Cue fires >10×/session | Mute it or demote to visual — it is already habituated |
| Ambient noise high or unknown | Weight haptics and visuals; treat audio as unreliable |
| Sound and animation feel disconnected | Re-time audio to the contact frame within ±80 ms |

## Cross-refs

- [[HUMAN_PERCEPTION]] — mechanisms behind attention, masking, and crossmodal binding used here.
- [[MICROINTERACTIONS]] — the visual half of every feedback pairing; design the moment there first.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — animation curves and contact frames that audio/haptics must sync to.
- [[EMOTIONAL_DESIGN]] — choosing the affective tone of a sound/haptic palette.
- [[ACCESSIBILITY_AND_INCLUSION]] — redundancy requirements and sensory-disability floors in depth.
- [[PERFORMANCE_PERCEPTION]] — using sound/haptics to mask or reframe waiting.
- [[MULTI_DEVICE_ECOSYSTEMS]] — carrying context profiles and cue state across devices.
