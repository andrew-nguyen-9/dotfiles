# Efficient dispatch contract

Every subagent prompt should carry only:

- objective and owned files;
- relevant path/symbol references;
- exclusions and shared-workspace warning;
- runnable verification;
- return format of at most two concise lines.

Use low reasoning for mechanical searches, medium for normal implementation, and high for architecture, security, integration, or ambiguous debugging. Prefer one well-bounded agent over several overlapping agents. Keep raw logs on disk and return conclusions plus evidence.
