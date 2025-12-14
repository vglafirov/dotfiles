# Merge Request Description Templates

Templates for GitLab MR descriptions following GitLab conventions.

## Table of Contents
- [Bug Fix Template](#bug-fix-template)
- [Feature Template](#feature-template)
- [Documentation Template](#documentation-template)
- [Database Migration Template](#database-migration-template)
- [Refactoring Template](#refactoring-template)
- [Security Fix Template](#security-fix-template)
- [Quick Templates](#quick-templates)

## Bug Fix Template

```markdown
## What does this MR do and why?

Fixes [issue link] - [brief description of the bug being fixed]

### Root Cause

[Explain what was causing the bug]

### Solution

[Explain how this MR fixes the issue]

## Screenshots or screen recordings

[Before/After screenshots if UI changes - required for UI MRs]

**Before:**
[screenshot]

**After:**
[screenshot]

## How to set up and validate locally

1. [Step to reproduce the bug]
2. [Apply the fix]
3. [Verify the fix works]

## MR acceptance checklist

Please evaluate this MR against the [MR acceptance checklist](https://docs.gitlab.com/ee/development/code_review.html#acceptance-checklist).

- [ ] Tests added for the fix
- [ ] Documentation updated (if applicable)
- [ ] Changelog entry added (if user-facing)

/label ~"type::bug"
```

## Feature Template

```markdown
## What does this MR do and why?

Implements [issue link] - [brief description of the feature]

### Problem

[What problem does this solve?]

### Solution

[How does this MR solve the problem?]

## Screenshots or screen recordings

[Required for UI changes]

## How to set up and validate locally

1. [Setup steps]
2. [Validation steps]
3. [Expected outcome]

## Feature flag

<!-- If applicable -->
Name: `feature_flag_name`
Default: disabled/enabled

## MR acceptance checklist

Please evaluate this MR against the [MR acceptance checklist](https://docs.gitlab.com/ee/development/code_review.html#acceptance-checklist).

- [ ] Tests added
- [ ] Documentation added/updated
- [ ] Feature flag configured (if applicable)
- [ ] Changelog entry added

/label ~"type::feature"
```

## Documentation Template

```markdown
## What does this MR do and why?

Updates documentation for [feature/topic] - [brief description]

Related to [issue link] (if applicable)

## Author checklist

- [ ] Follow the [Documentation Guidelines](https://docs.gitlab.com/ee/development/documentation/)
- [ ] Link to related issues/MRs
- [ ] Technical accuracy verified
- [ ] Grammar and spelling checked

## Review checklist

- [ ] Content is technically accurate
- [ ] Writing follows style guide
- [ ] Links work correctly

/label ~"type::maintenance" ~"documentation" ~"technical writing"
```

## Database Migration Template

```markdown
## What does this MR do and why?

[Brief description of database changes]

Related issue: [issue link]

## Database changes

### Migration details

- Migration type: [add column/create table/remove column/data migration]
- Table(s) affected: `table_name`
- Estimated rows: [number]

### Rollback plan

[Describe how to rollback if needed]

## Query analysis

<!-- Include EXPLAIN ANALYZE output for new queries -->
```sql
EXPLAIN ANALYZE [query]
```

## Multi-version compatibility

[Explain how this handles rolling deployments]

## MR acceptance checklist

- [ ] [Database review guidelines](https://docs.gitlab.com/ee/development/database_review.html) followed
- [ ] Migration is reversible
- [ ] Query performance analyzed
- [ ] Background migration used for large tables (if applicable)

/label ~"type::maintenance" ~"database" ~"database::review pending"
```

## Refactoring Template

```markdown
## What does this MR do and why?

Refactors [component/module] - [brief description]

Related issue: [issue link] (if applicable)

### Current state

[Describe current implementation and its issues]

### Changes

[Describe the refactoring changes]

### Benefits

- [Benefit 1]
- [Benefit 2]

## Risk assessment

- Breaking changes: [Yes/No]
- Performance impact: [Positive/Neutral/Negative]

## How to validate

1. [Validation steps]
2. [Expected behavior should remain unchanged]

## MR acceptance checklist

- [ ] No functional changes (unless intentional)
- [ ] Tests pass and cover refactored code
- [ ] Performance not degraded

/label ~"type::maintenance"
```

## Security Fix Template

```markdown
## What does this MR do and why?

<!-- DO NOT include detailed vulnerability info in public MRs -->
Addresses a security concern. See [confidential issue link] for details.

## Security considerations

- [ ] Follows [secure coding guidelines](https://docs.gitlab.com/ee/development/secure_coding_guidelines.html)
- [ ] No sensitive information in logs
- [ ] Input validation added
- [ ] Authorization checks in place

## How to validate

[Steps to verify the fix without revealing the vulnerability]

## MR acceptance checklist

- [ ] Security review completed
- [ ] Tests added
- [ ] No regression in functionality

/label ~"type::bug" ~"security"
```

## Quick Templates

### Quick Bug Fix
```markdown
## What does this MR do?

Fixes [#issue] - [one-line description]

## How to validate

1. [Quick validation steps]

/label ~"type::bug"
```

### Quick Feature
```markdown
## What does this MR do?

Implements [#issue] - [one-line description]

## How to validate

1. [Quick validation steps]

/label ~"type::feature"
```

### Quick Maintenance
```markdown
## What does this MR do?

[One-line description of maintenance work]

Related: [#issue] (if applicable)

/label ~"type::maintenance"
```

## Template Selection Guide

| Scenario | Template | Type Label |
|----------|----------|------------|
| Fixing a bug | Bug Fix | `type::bug` |
| New functionality | Feature | `type::feature` |
| Updating docs only | Documentation | `type::maintenance` |
| Database changes | Database Migration | `type::maintenance` |
| Code cleanup | Refactoring | `type::maintenance` |
| Security vulnerability | Security Fix | `type::bug` + `security` |
| Small quick changes | Quick Templates | Varies |

## Description Guidelines

1. **Keep it concise** - be clear but not verbose
2. **Link related issues** - use full URLs for cross-project visibility
3. **Include screenshots** - required for any UI changes
4. **Explain the "why"** - not just what changed
5. **Add validation steps** - help reviewers test
6. **Use quick actions** - `/label`, `/assign`, `/milestone`

## Changelog Guidelines

Add changelog entry for user-facing changes:

```markdown
## Changelog

<!-- One of: added, fixed, changed, deprecated, removed, security, performance, other -->
- fixed: Pipeline no longer fails when runner disconnects unexpectedly
```

For non-user-facing changes, add:
```markdown
## Changelog

No changelog needed - [reason]
```
