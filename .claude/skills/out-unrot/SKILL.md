---
name: unrot
description: Rewrite a lazy, ambiguous prompt into a precise one, returning the "unrotted" prompt back to the user.
argument-hint: "[userprompt]"
disable-model-invocation: false
user-invocable: true
---

# Unrot

The user writes lazy prompts, adding ambiguous direction for AI, which degrades operational performance. This skill removes that ambiguity and then does the work.

`$ARGUMENTS` is the raw prompt.

## Order of operations

Run these three steps in order. The rewrite is a means, not the deliverable.

### 1. Rewrite

Apply to `$ARGUMENTS`:

1. Fix grammar, spelling and punctuation. Complete any unfinished sentences. Restructure into a literate prompt.
2. Resolve ambiguity. Remove ambiguous words, and or sentences.
3. Strengthen unambiguity, making sentences more dense.
4. Prefer minimal, yet dense over high-level abstracted buzz words, phrases, and sentences.

**Do not add**: new ideas, details, and or high-level vocabulary.
**Do not modify**: the meaning, and or the scope of the prompt.

5. Strip these from the rewritten prompt:

- preambles
- labels
- quotes
- code fences, or snippets
- anything that leaves no clear direction to act on

### 2. Return

Return the "unrotted" prompt back to the user. Nothing more, nothing less.
