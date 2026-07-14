# DATA_VISUALIZATION

## Purpose

Decides how to encode data visually: which chart for which question, how dense a display can get before comprehension collapses, and which perceptual channels carry which variables. Load when building charts, dashboards, tables, or any data-dense surface.

## Principles

- Encoding accuracy is a fixed perceptual hierarchy, not taste: position on a common scale > position on nonaligned scales > length > angle/slope > area > volume/color saturation. Cleveland & McGill measured error roughly doubling at each step down. Spend the most accurate channel on the most important variable. [E]
- Preattentive features — hue, orientation, size, motion — are detected in <250 ms regardless of item count; anything else forces a serial scan at ~40–60ms per item. One variable per preattentive channel; two channels conjoined (e.g., "red AND large") lose the pop-out and revert to serial search. [E]
- Working memory holds ~4 chunks. A reader comparing values across views must hold them in memory; every saccade between a legend and the data, or between two separated charts, taxes that budget. Co-locate what must be compared. [E]
- Perceived magnitude follows Stevens' power law: length is judged near-linearly (exponent ~1.0), area is underestimated (~0.7), color saturation worse (~0.5). Area encodings systematically compress large values — readers see a 4x area as ~2.7x. [E]
- Humans are pattern-completion machines: they will see trends in noise (apophenia) and connect what is merely adjacent (Gestalt proximity/continuity). The chart's job is to make real structure preattentive and deny accidental structure — alignment, shared baselines, and consistent intervals are truth mechanisms, not decoration. [E]
- Graphical excellence is the greatest number of ideas in the shortest time with the least ink in the smallest space (Tufte). Density is a feature when every mark is data; it is noise when marks are container chrome, 3D bevels, or redundant labels. [E]
- The question determines the form. Comparison, trend, distribution, part-to-whole, correlation, and flow are different perceptual tasks with different optimal encodings; picking the chart before the question produces decoration. [E]
- A visualization is a claim. Truncated axes, dual axes, and cherry-picked windows are rhetorical devices the reader cannot audit; a chart that cannot be misread beats a chart that can be defended. [H]

## Rules

### Chart selection

- Comparison across categories → horizontal bars, sorted by value (not alphabet) unless order is intrinsic (time, ordinal scale). Sorting converts a lookup task into a preattentive scan. [E]
- Trend over time → line chart; ≤4 lines per panel. Beyond 4, split into small multiples with shared axes — Cowan's working-memory limit applies to line identities. [E]
- Part-to-whole → stacked bar or waffle; pie only when ≤3 slices and one message ("A is roughly half"). Angle judgment error is ~2x length error (Cleveland & McGill); donut holes remove the angle cue entirely. [E]
- Distribution → histogram or density plot for one variable; boxplots or violin for comparing ≥3 groups. Means without spread hide bimodality — always show shape before summarizing it. [E]
- Correlation → scatterplot; add a fitted line only with the fit statistic visible. ≥1,000 points: switch to density (hexbin/contour) — overplotting reads as a false uniform blob. [E]
- Flow/transfer between states → Sankey or chord only when flow magnitude is the actual message; otherwise a matrix or table. Ribbon area is a ~0.7-exponent encoding read as decoration. [H]
- Single number that matters (KPI) → large numeral + sparkline + delta vs. reference period. A number without a comparison is not information; the sparkline supplies trend context in ~1 cm². [E]
- Never 3D for 2D data: perspective projection distorts every position and length judgment the chart exists to enable. Never dual y-axes: the implied correlation is an artifact of axis scaling, tunable to show anything. [E]

### Visual encoding

- Bar charts start at zero, always — bars encode value as length, and a truncated baseline lies by the ratio of visible lengths. Line charts may zoom the y-range to resolve variation, because lines encode slope, not length; label the range when you do. [E]
- Map quantitative data to position or length first; use color lightness for the third variable, hue only for categories. Max 5–7 categorical hues per view — beyond that, hue discrimination fails and the legend becomes a memory test. [E]
- Sequential data → single-hue lightness ramp; diverging data → two hues through a neutral midpoint anchored at the meaningful zero. Never rainbow: its lightness is non-monotonic, creating false boundaries at hue transitions. [E]
- ~8% of men have red-green color deficiency: never encode a distinction in hue alone — pair with position, shape, or direct labels; verify under CVD simulation before ship. [E]
- Encode each variable in exactly one channel; add a second channel only as redundancy for the same variable (color + position for the highlighted series). Two variables in conjoined channels destroy pop-out. [E]
- Direct-label lines and bar ends where space allows; a legend is an index lookup costing one saccade round-trip (~200–500 ms) per read, multiplied by every value the reader checks. [E]
- Aspect ratio: bank line-chart slopes toward ~45° average orientation (Cleveland's banking) — slope discrimination peaks at mid-angles; near-vertical and near-flat lines both hide rate changes. [E]

### Information density and layout

- Data-ink first: remove chart borders, backgrounds, and redundant tick labels before removing data. Gridlines at ≤20% gray or dropped where direct labels serve; heavy grids compete with data in the same position channel. [E]
- Increase density by shrinking marks and multiplying panels (small multiples), not by overlaying more series in one panel. Small multiples with identical scales let position comparison — the strongest channel — work across panels. [E]
- A dashboard answers its primary question in ≤5 seconds and holds ≤7 views on one screen without scrolling for monitoring use; the reader's task is state-detection, not exploration. [H]
- Layer detail on demand (Shneiderman): overview first, zoom and filter, details on hover/click. Never front-load every annotation — resting-state ink should be the pattern, not the footnotes. [E]
- Tables beat charts when readers need exact values or will look up individual rows; charts beat tables for shape, trend, and outliers. Right-align numerals, use tabular (monospaced) figures, and round to the decimals that change decisions — typically ≤3 significant digits. [E]
- Numbers in running text or tables: give a comparison or per-unit rate; a lone large integer ("4,382,190 events") is unreadable — the reader must divide to understand it. [H]

### Integrity

- Lie factor = (size of effect in graphic) / (size of effect in data); keep within 0.95–1.05. Area scaled by radius (r doubles → area 4x) is the classic violation. [E]
- Show uncertainty when it changes the decision: error bars, bands, or gradient fades — a point estimate drawn crisply claims precision the data may not have. State n. [E]
- Annotate events that explain anomalies directly on the chart (policy change, outage, redefinition); an unexplained discontinuity invites false causal stories. [H]

## Decision guide

| Situation | Do |
|---|---|
| "Which is bigger?" across categories | Sorted horizontal bars, zero baseline, direct-labeled ends |
| "How has it changed?" | Line chart, ≤4 series, banked near 45°; more series → small multiples |
| "What share of the whole?" | Stacked bar; pie only if ≤3 slices and precision irrelevant |
| "How is it distributed?" | Histogram/density; groups ≥3 → boxplots side by side |
| "Are these related?" | Scatter; ≥1,000 points → hexbin/density |
| Reader needs exact values | Table: right-aligned tabular figures, ≤3 significant digits |
| >7 categorical colors needed | Redesign: group into ≤5 + "other", or facet by category |
| Chart feels crowded | Cut non-data ink first, then small-multiply — never shrink data to fit chrome |
| Tempted by dual y-axes | Two stacked panels sharing the x-axis |
| Value seems shocking on the chart | Check lie factor, baseline, and axis window before shipping |

## Cross-refs

- [[HUMAN_PERCEPTION]] — preattentive processing, Gestalt, and memory limits that ground every rule here.
- [[COLOR_SYSTEMS]] — building the categorical/sequential/diverging palettes these rules assume.
- [[LAYOUT_MATHEMATICS]] — grids and spacing for composing multi-chart dashboards.
- [[TYPOGRAPHY_SYSTEMS]] — tabular figures, numeral alignment, axis-label hierarchy.
- [[ACCESSIBILITY_AND_INCLUSION]] — CVD-safe encoding, contrast minimums for marks and labels.
- [[PERFORMANCE_PERCEPTION]] — progressive loading and skeletons for slow data-dense views.
