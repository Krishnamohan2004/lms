# Git Workflow

## Branch Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/<short_description>` | `feature/junit_test_cases` |
| Bugfix | `bug/<ticket_or_issue>` | `bug/gtgsre_xxx12` |
| Release | `release/YYYY.MM.DD` | `release/2026.05.20` |
| Hotfix | `hotfix/<ticket_or_issue>` | `hotfix/jwt_secret_leak` |

## Branch Creation and Sync

### Create a Feature Branch

```bash
git checkout dev
git pull origin dev
git checkout -b feature/add_media_route
```

### Keep Branch Updated

```bash
git checkout feature/add_media_route
git fetch origin
git rebase origin/dev
```

### Push Branch

```bash
git push origin feature/add_media_route
```

## Commit Message Conventions

### Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types

| Type | Usage |
|------|-------|
| `feat` | New feature or route |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code restructuring, no behavior change |
| `test` | Adding or updating tests |
| `chore` | Build, config, dependency changes |
| `security` | Security-related change |

### Examples

```
feat(routes): add media-service route configuration

fix(auth): correct public endpoint path matching for courses

chore(deps): upgrade spring-cloud-bom to 2023.0.2

docs(readme): update tech stack table with resilience4j
```

## Pull Request Rules

1. Target branch: `dev` for features and bugs
2. Minimum 1 approval required
3. All CI checks must pass (build + tests)
4. No force-push after review begins
5. Squash merge preferred for clean history
6. PR title follows commit message format
7. Description must include: what, why, and how to test

## Merge Strategy

| Merge To | Strategy | Rationale |
|----------|----------|-----------|
| `dev` | Squash merge | Clean linear history |
| `release/*` | Merge commit | Preserve full context |
| `main`/`prod` | Merge commit | Audit trail preservation |

## Revert Commits

### Revert a Merged Commit

```bash
# Find the commit hash to revert
git log --oneline -10

# Revert (creates a new commit that undoes the change)
git revert <commit-hash>

# Push the revert
git push origin dev
```

### Revert a Merge Commit

```bash
# -m 1 specifies the mainline parent (usually the branch you merged into)
git revert -m 1 <merge-commit-hash>
git push origin dev
```

## Cherry-Pick Flows

### Dev to QA

```bash
# Identify the commit to promote
git log --oneline dev

# Switch to QA branch
git checkout qa
git pull origin qa

# Cherry-pick the specific commit
git cherry-pick <commit-hash>

# Resolve conflicts if any, then
git push origin qa
```

### QA to Production

```bash
git checkout main
git pull origin main

# Cherry-pick the validated commit
git cherry-pick <commit-hash>

# Push to production branch
git push origin main
```

### Cherry-Pick Multiple Commits

```bash
git cherry-pick <hash1> <hash2> <hash3>
```

## Conflict Resolution

### During Rebase

```bash
# When conflict occurs during rebase
git status                    # See conflicted files
# Edit files to resolve conflicts
git add <resolved-files>
git rebase --continue

# To abort if needed
git rebase --abort
```

### During Cherry-Pick

```bash
# When conflict occurs during cherry-pick
git status
# Edit files to resolve conflicts
git add <resolved-files>
git cherry-pick --continue

# To abort
git cherry-pick --abort
```

### Verification Checklist

- [ ] All conflicts resolved (no `<<<<<<<` markers remain)
- [ ] Application builds successfully: `./mvnw clean package`
- [ ] Tests pass: `./mvnw test`
- [ ] Gateway starts and health check passes
- [ ] Route configuration is valid (no YAML syntax errors)

## Safety Notes

### When to Use Revert vs Reset

| Scenario | Use | Reason |
|----------|-----|--------|
| Undo a pushed commit on shared branch | `git revert` | Preserves history, safe for collaboration |
| Undo local unpushed commits | `git reset` | No shared history impact |
| Undo a merge on shared branch | `git revert -m 1` | Never force-push shared branches |
| Clean up local experiment | `git reset --hard` | Only on local branches |

### Rules

- **Never** `git push --force` on `dev`, `qa`, `main`, or `release/*` branches
- **Never** `git reset` on shared branches
- **Always** verify build after conflict resolution
- **Always** communicate cherry-picks to the team to avoid duplicate merges

