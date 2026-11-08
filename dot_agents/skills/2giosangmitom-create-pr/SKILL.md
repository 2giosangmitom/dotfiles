---
name: 2giosangmitom-create-pr
description: Draft a pull request from the branch's commits and the repo's PR template, then publish it only after the user approves. Use only when the user explicitly asks to create a PR.
argument-hint: [base branch or guidance]
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh auth status *), Bash(gh repo view *), Bash(gh pr list *), Bash(gh pr view *), Bash(gh issue view *), Bash(gh pr create *), Read, Glob, Grep
---

# Create Pull Request

Draft a pull request from the current branch. Never push, create, or publish anything until the user approves.

Follow the user's guidance: $ARGUMENTS

## Workflow

### 1. Verify repository

Run:

```bash
git rev-parse --is-inside-work-tree
git status --short --branch
git remote -v
```

Stop if this is not a Git repository or there is no `origin` remote. Ask the user to switch to a feature branch if the current branch is the default branch.

Warn about uncommitted changes. They are not part of the PR until committed, and must not be committed unless the user asks.

### 2. Determine the base branch

Use the branch named in `$ARGUMENTS`. Otherwise run:

```bash
gh repo view --json defaultBranchRef --jq .defaultBranchRef.name
```

If `gh` is unavailable, fall back to `main`, then `master`, checking each with `git rev-parse --verify`. Ask the user if neither exists.

### 3. Read the commit history

```bash
git log --no-merges --reverse --format='%h%n%s%n%b%n---' <base>..HEAD
```

Use these messages as the source for the title and description. If a message is vague, check the touched files with `git log --no-merges --name-only --format='%h %s' <base>..HEAD`. Do not run `git diff`.

If there are no commits ahead of `<base>`, stop and report that there is nothing to open a PR for.

### 4. Check push status

```bash
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git log --oneline @{u}..HEAD
```

If there is no upstream or the branch is ahead, say that a push is required. Ask before pushing.

### 5. Find the PR template

Glob for these paths, in order:

- `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/pull_request_template/*.md`, `.github/PULL_REQUEST_TEMPLATE/*.md`
- `docs/pull_request_template.md`, `docs/PULL_REQUEST_TEMPLATE.md`
- `pull_request_template.md`, `PULL_REQUEST_TEMPLATE.md`

If one exists, read it fully and keep its headings, order, and checkboxes. Fill in each applicable section, replace instructional comments with real content, and remove comments that do not apply. If several templates match, choose by change type when the names make it clear, otherwise ask.

### 6. Write the title and description

**Title:**

- Aim for 50 characters or fewer. Maximum 72.
- Imperative mood. Describe the change, not the act of opening a PR.
- Use a `feat:` or `fix:` prefix only if the repository's PRs already use one.
- No trailing period.

**Description:** base it on the commit bodies. Keep it short and explain what changed and why.

Without a template, use:

```markdown
## Summary

What changed, and why? Add `Closes #<n>` if an issue applies.

## Breaking changes

What must users change when upgrading? Write "None" if nothing changes.
```

Rules:

- Verify every issue reference with `gh issue view <n>`.
- Never guess issue numbers, links, test results, or breaking changes.
- Never include secrets, tokens, credentials, or private URLs.
- Never add AI attribution.

### 7. Show the draft and ask for approval

Show the title and description in code blocks, then ask:

> Publish this PR to `<owner/repo>` with base `<base>`? Reply to approve, or send edits.

Do not run `gh pr create` before approval. If the user asks for changes, revise the draft and show it again.

### 8. Publish after approval

1. If the branch is not pushed, ask separately for permission. Only after approval, run `git push -u origin HEAD`.
2. Create the PR with the approved title and body:

   ```bash
   gh pr create --base <base> --title "<title>" --body-file - <<'EOF'
   <description>
   EOF
   ```

3. Add `--draft` only if the user asks.

Never force-push, amend commits, or create more than one PR per request.

If `gh` is missing or not authenticated, give the user this compare URL to open:

```text
https://github.com/<owner>/<repo>/compare/<base>...<head>?expand=1
```

### 9. Report

After publishing, show:

- PR URL.
- Title.
- Base and head branches.
- Draft or ready-for-review status.
- Number of commits in the PR.
- Confirmation that nothing was force-pushed.

If publishing fails, report the error without claiming success.

## Examples

**Without a template:**

```text
fix(auth): handle expired refresh tokens

## Summary

Refresh tokens now expire cleanly. Users are sent back to login with their return path preserved. Closes #123.

## Breaking changes

None.
```

**With a template:** use the template's headings and order, fill each section from the commit history, and keep its checkboxes. Do not replace it with the structure above.
