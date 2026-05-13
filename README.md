# lazy-ricks set of utilities

![Screenshot](pics/ricking.png)

<p align="center">
  <strong>A set of utilities for lazy ricks</strong><br>
  You should really be doing most of this manually, but ¯\_(ツ)_/¯
  Simply pick & pull from this repo – if you care to contribute, do so.
</p>

---

**[lazy-gh](.claude/agents/gh-wrapup.md) (agent)**
> [!NOTE]
> You should be performing your own Git operations, not your agent.<br>
> Use this if you're multi-tasking, tabbing, harnessing, or ricking.

This agent cleans up local git status. Commit, push, pr, & merge -> cleans stale branches.

① Copy the `gh-wrapup.md` to either `~/.claude/agents` or `$CLAUDE_PROJECT_DIR/.claude/agents`

② Copy the `gh-wrapup.sh` to either `~/.claude/scripts` or `$CLAUDE_PROJECT_DIR/.claude/scripts`

③ Simply invoke in chat, `@gh-wrapup` – validate the agents work.

---

**[chat-migrate](.claude/skills/chat-migrate.md) (skill)**
> [!NOTE]
> Use this to migrate your agent/conversation session from one context window to another.

① Copy the `chat-migrate/SKILL.md` to either `~/.claude/skills` or `$CLAUDE_PROJECT_DIR/.claude/skills`

② Simply invoke in chat after a long-running session, `/chat-migrate` – copy the response.

---

**[build-goal](.claude/skills/build-goal.md) (skill)**
> [!NOTE]
> Use this to parlay your brain into a goal for the "new" `/goal` command.<br>
> I made this because sometimes you just need a semi-more-than-average prompt.<br>
> The other goal building prompts/skills are TOO sweaty.<br>
> Better to use this skill during a session of writing/modifying code.

① Copy the `build-goal/SKILL.md` to either `~/.claude/skills` or `$CLAUDE_PROJECT_DIR/.claude/skills`

② Simply invoke in chat after a long-running session, `/build-goal` – answer the questions. 

---

