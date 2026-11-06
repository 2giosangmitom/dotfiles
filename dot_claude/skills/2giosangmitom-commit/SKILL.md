---
name: 2giosangmitom-commit
description: Commit staged or pending changes using the repository's commit style. Use only when the user explicitly asks to commit.
argument-hint: [guidance for the commit message]
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh issue view *), Bash(gh pr view *)
---

# Commit Changes

Commit changes in the current repository. Never push.

Follow the user's guidance: $ARGUMENTS

## Workflow

### 1. Verify repository

Run `git rev-parse --is-inside-work-tree`. Stop if this is not a Git repository.

### 2. Check commit conventions

Inspect recent history:

```bash
git log -n 30 --format='%s%n%b'
```

Match the repository's subject prefixes, casing, tense, and body style.

### 3. Inspect and stage changes

Run:

```bash
git status --short
git diff --cached
git diff
```

- If changes are staged, commit only those changes.
- If nothing is staged, run `git add -A`.
- Never stage secret-looking files: `.env*`, `*.pem`, `*.key`, `credentials*`, `*token*`. Report excluded files.
- If there are no changes, stop.
- Review `git diff --cached` before committing.

### 4. Write the commit message

**Subject:**

- Under 80 characters.
- Follow repository conventions.
- Describe the change, not the act of committing.
- No trailing period.

**Body:**

Add a body only when explaining motivation, breaking changes, migration steps, or user-requested references is necessary.

If included:

- Separate it from the subject with a blank line.
- Wrap lines at 72 characters.
- Explain why or what needs migration; don't repeat the diff.
- Put references last, after a blank line.

**References:**

- Only add issue/PR references when requested.
- Verify each using `gh issue view <n>` or `gh pr view <n>`.
- Use `Closes #<n>` for resolved issues and `Refs #<n>` for related ones.
- Never guess reference numbers.

**Wording:**

- Avoid `I`, `we`, `now`, `currently`, and phrases like `This commit does...`.
- Never add AI attribution or `Co-Authored-By` footers.

### 5. Commit

Stay on the current branch. Do not switch branches or amend commits unless requested.

Write the message to a temporary scratchpad file and run:

```bash
git commit -F <temp-file>
```

Never use `--no-verify`. If a hook fails, show its output and stop. Never push.

### 6. Report

After success, show:

- Commit hash.
- Full commit message.
- Excluded files, if any.
- Confirmation that nothing was pushed.

If the commit fails, report the error without claiming success.

## Examples

**Simple commit:**

```text
feat(auth): support Google OAuth login
```

**With motivation:**

```text
fix(api): prevent duplicate payment requests

Reject requests with reused idempotency keys to avoid
charging customers more than once.
```

**With issue reference (only when requested):**

```text
fix(auth): handle expired refresh tokens

Require users to authenticate again when their refresh
tokens expire.

Closes #123
```
