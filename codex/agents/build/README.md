# Build agents

| Agent | Use when | Returns |
|---|---|---|
| `unit-builder` | A brief has explicit disjoint files and runnable DoD | shipped scope + verification |
| `worker` | General implementation without a custom role need | concise result |

Never run parallel writers with overlapping files. The parent/root agent performs git operations and integration.
