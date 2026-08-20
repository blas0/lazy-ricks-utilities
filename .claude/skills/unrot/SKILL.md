---
name: unrot
desc: Cut out the ambiguous, lazy prompts that humans give AI.
disable-model-invocation: false
user-invocable: true
argument-hint: [userprompt]
---

# Unrot

The user writes lazy prompts, adding ambiguous direction for AI: affecting it's operational performance.

## Order of Operations

Take the $ARGUMENTS and apply the following operations to the prompt:

1. Fix grammar, spelling and punctuation. Complete any unfinished sentences. Restructure into a literate prompt.
2. Resolve ambiguity. Remove ambiguous words, and or sentences. 
3. Strengthen unambiguity, making sentences more dense.
4. Prefer minimal, yet dense over high-level abstracted buzz words, phrases, and sentences.

**Do not add**: new ideas, details, and or high-level vocabulary.
**Do not modify**: the meaning, and or the scope of the prompt.

## Arguments

Before pipein/stdin'ing the "enhanced" prompt, avoid the `$MATCHERS`

`$MATCHERS`:
- preambles
- labels
- quotes
- code fences, or snippets
- no clear direction for the user to take, and or respond to
