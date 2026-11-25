# Personal instructions for Claude Code

These rules apply in every repository. A repository's own CLAUDE.md can add to them or override them.

## Comments

- Write a comment only for a bug workaround, hard-to-read code, or something odd. Do not restate the code, narrate a
  test, or explain why an ordinary line exists.
- Describe the code as it is now. Do not tell the history of the change.
- Never refer to plan files, plan names or plan ids (`.claude/plans/...`, `D7`, `WP-3`, `Phase 2`, `Q1`) in code,
  tests or commit messages. Say the decision in words. An issue number (`#1234`) is fine inside a comment that is
  necessary for other reasons. It is not a reason to write a comment.
- Wrap comments at 120 columns, not 80.
- Before you finish, read every comment line you added and remove the ones a reader could get from the code.

## Writing

- Write code comments and prompts (agent briefs, CLAUDE.md files, skill and plan text) in ASD-STE100 Simplified
  Technical English, about 80% strict:
  - Short sentences: about 20 words for an instruction, 25 for a description. One idea in each sentence.
  - Active voice, present tense, imperative for instructions. Use articles. No contractions or idioms.
  - Simple common words with one meaning ("use", not "leverage"). Use one term for one concept.
  - Relax the rules for code names, product names, UI labels and common technical words.
- Do not use em dashes in prose or site copy. Use separate sentences, commas or colons.

## Git

- Run `git branch --show-current` before each commit or merge. Do not assume which branch the work belongs on.
- "Merge to main" means `git merge --squash <branch>` and one commit.
- Never `git add -f` anything under `.claude/`. Draft PR bodies in the scratchpad, not in the repository.

## Decisions

- Never assume a decision. When two options are in play, keep both until I name the winner. A tweak to one option
  does not choose it.
- Build UI wording literally: which element gets which text. If it looks wrong, say so and ask. Do not build your
  own reading.
- When I interrupt a task and then ask for something else, the interrupted task is cancelled. Ask in one line if you
  are not sure.
- Ask before you rename or remove something I did not name. Adding is fine.

## Verification

- Run the targeted tests for your own changes before you hand work back. Do not run the full suite unless asked.
- When tests fail, fix them. Do not spend steps proving that they failed before your change.
- Verify through tests and fixtures. Do not write `bin/rails runner` smoke scripts or run commands against the
  development database unless I ask. Tell me what to run instead.
- Do not run build or watch commands (`bin/dev`, `bin/css`, asset builds). I run them.
- Tests must earn their keep: cover edge cases and critical paths. A test that asserts nothing meaningful is a
  review finding, the same as a bug.

## Secrets

- Never read, copy or print `master.key`, `.env*` files or credentials, also not for test setup in a worktree. If a
  command needs them, ask me to run it with `! <command>`.

## Multi-agent work

After I approve a plan, you are the implementation manager:

1. Use one git worktree per agent and one feature branch that collects their work.
2. Put the comment, plan-reference and secrets rules above in every agent brief.
3. When the agents finish, start two non-Opus reviewers: one for the code, one for test value (remove brittle or
   empty tests).
4. I test the UI myself on the feature branch.
