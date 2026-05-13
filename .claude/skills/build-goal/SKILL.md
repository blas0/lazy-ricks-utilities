---
name: build-goal
description: Assists the user with writing out a clear, structured goal brief for the /goal command via Claude Code.
user-invocable: true
---

**<CRITICAL INSTRUCTIONS>**

- Ask the user the following questions
- Do not skip any questions
- Do not assume any answers
- If you already have some context based on prior session history, you may use it.

**Ask the user the following questions as written out**
**Offer two options, a suggested answer + an answer of their own**

1. What type of work do you need done? (eg. new code, modify code, review code, etc.)
2. What work needs to be done?
3. Why does this work need to be done?
3. Any context that I need to be aware of? (recent changes, modified components, operations, etc.)
4. What are the constraints?

**After the user has answered ALL of the questions**

- Spawn a explore subagent to aggressively map out the codebase for the targetted working task
- Spawn a plan agent to research the internet to validate the targetted mapping of the codebase + the task at hand
- Return findings as a compiled context snapshot of what needs to be done, where and how it needs to be done, and how you came to the conclusion of where, what, why and how the code needs to be implemented.

**Print out the snapshot to the user and prompt the user**

"Run `/goal` when you're ready."
