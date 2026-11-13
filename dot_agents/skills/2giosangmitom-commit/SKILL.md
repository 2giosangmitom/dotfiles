---
name: 2giosangmitom-commit
description: Commit staged or unstaged changes using the repository's commit style. Use only when the user explicitly asks to commit.
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

- If changes are already staged, commit only those changes. Do not stage unstaged changes.
- If no changes are staged, run `git add -A`.
- Never stage files that may contain secrets: `.env*` (except `.env.example`), `*.pem`, `*.key`, `credentials*`, `*token*`. If any are already staged, unstage them and report the excluded files.
- If there are no changes, stop.
- Review `git diff --cached` after staging. Ensure no unintended or sensitive files are included before committing.

### 4. Write the commit message

**Subject:**

- Aim for 50 characters or fewer. Maximum 72.
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

- Only add issue/PR references when explicitly requested by the user.
- Verify each using `gh issue view <n>` or `gh pr view <n>`.
- Use `Closes #<n>` for resolved issues and `Refs #<n>` for related ones.
- Never guess reference numbers.

**Wording:**

- Avoid `I`, `we`, `now`, `currently`, and phrases like `This commit does...`.
- Never add phrases such as `Generated with Claude Code` to the commit message. Only `Co-authored-by` trailers are allowed.

### 5. Commit

Stay on the current branch. Do not switch branches or amend commits unless requested.

```bash
git commit -m "Subject" -m "Body paragraph."
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
