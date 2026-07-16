---
name: mcq
description: Ask multiple-choice questions only when the user explicitly requests an MCQ.
---

# MCQ

Trigger only when the user explicitly asks for an MCQ.

When `request_user_input` is callable:

- Ask 1–3 short questions.
- Give each question 2–3 mutually exclusive options.
- Put the recommended option first and suffix its label with `(Recommended)`.
- Put each option's consequence or note in its description.
- Do not add an Other option; rely on the client's native free-text path.

When `request_user_input` is unavailable, ask one concise plain-text question. List 2–3 choices with the recommended option first, include each choice's consequence inline, and say that free-text answers are accepted.

Every choice presented by this skill must put the recommended option first.
