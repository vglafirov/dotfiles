# GitLab Merge Request Workflow Guidelines

Best practices and requirements for GitLab merge requests based on official documentation.

## Table of Contents
- [Contribution Acceptance Criteria](#contribution-acceptance-criteria)
- [Definition of Done](#definition-of-done)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Code Review Process](#code-review-process)
- [Database Review Guidelines](#database-review-guidelines)

## Contribution Acceptance Criteria

MRs must meet these criteria for approval:

1. **Keep changes small** - as minimal as possible
2. **Explain large MRs** - if >500 changes, explain why and mention maintainer
3. **Document breaking changes** - mention any backwards-incompatible changes
4. **Include tests** - every new class needs unit tests
5. **Organize commits** - few logical commits or enable squash
6. **No merge conflicts** - rebase if you're the only contributor
7. **Single purpose** - one issue/feature per MR
8. **Migrations do one thing** - easier to retry on failure
9. **No unnecessary config** - avoid adding configuration options
10. **No performance degradation** - check for N+1 queries, avoid repeated polling

## Definition of Done

MR creates no regressions and meets:

### Functionality
- [ ] Working, clean, commented code
- [ ] Performance guidelines followed
- [ ] Secure coding guidelines followed
- [ ] Rate limit guidelines followed
- [ ] Documented in `/doc` directory
- [ ] Shell command guidelines followed (if applicable)
- [ ] Observability instrumentation included
- [ ] File storage guidelines followed (if applicable)
- [ ] Migrations tested on fresh database

### Testing
- [ ] Unit, integration, system tests pass
- [ ] Regressions covered with tests
- [ ] Feature flag states tested
- [ ] Review app testing (if applicable)

### UI Changes
- [ ] Uses Pajamas design system components
- [ ] Before/After screenshots included
- [ ] List of affected pages (if CSS changes)

### Description
- [ ] Clear title and description
- [ ] Setup/validation steps included
- [ ] Changelog entry (if user-facing)
- [ ] Installation guide updated (if needed)
- [ ] Upgrade guide updated (if needed)

### Approval
- [ ] Acceptance checklist reviewed
- [ ] Infrastructure team notified (if changing defaults)
- [ ] Rollout plan agreed
- [ ] Required approvals obtained
- [ ] Documentation review (should not block merge)

## Commit Message Guidelines

Follow these rules (enforced by Danger checks):

### Format
```
Subject line (max 72 chars, capitalized, no period)

Body explaining what and why (wrap at 72 chars)
Use full URLs for issues/MRs, not short references.
```

### Rules
| Rule | Example |
|------|---------|
| Subject/body separated by blank line | ✓ |
| Subject starts with capital | `Fix pipeline failure` |
| Subject ≤72 characters | Keep it short |
| Subject has no period | `Fix bug` not `Fix bug.` |
| Body lines ≤72 characters | Wrap long explanations |
| No emojis | ✗ No emojis anywhere |
| ≤10 commits per MR | Squash if more |
| Subject has ≥3 words | `Fix runner disconnect` |

### Prefixes Allowed
- `[prefix]` format: `[API] Add labels endpoint`
- `prefix:` format: `danger: Improve behavior`

### Example
```
Fix pipeline failure when runner disconnects unexpectedly

The runner service was not handling disconnect events properly,
causing jobs to remain in pending state indefinitely.

This change adds a timeout check and proper cleanup.

See https://gitlab.com/gitlab-org/gitlab/-/issues/12345
```

## Code Review Process

### Before Requesting Review
1. Self-review your changes
2. Ensure all CI jobs pass
3. Verify acceptance criteria met
4. Add appropriate labels
5. Write clear description

### Review Types Required

| Change Type | Required Reviews |
|-------------|------------------|
| General code | 1 maintainer approval |
| Database changes | Database reviewer |
| Security-related | Security reviewer |
| Frontend changes | Frontend reviewer |
| API changes | Backend reviewer |
| Documentation | Technical writer (non-blocking) |

### Reviewer Selection
- Use CODEOWNERS for automatic assignment
- Tag relevant team members
- For community contributions, merge request coaches help

## Database Review Guidelines

### When Required
- New tables or columns
- Data migrations
- Complex queries
- Index changes
- Schema modifications

### Checklist
- [ ] Migration is reversible
- [ ] Background migration for large tables
- [ ] Query performance analyzed (EXPLAIN ANALYZE)
- [ ] Multi-version compatibility considered
- [ ] Rollback plan documented

### Labels to Add
```
database,database::review pending
```

After review:
```
database::reviewed → database::approved
```

## Feature Flag Guidelines

### When to Use
- Changes that might affect production availability
- Large features rolled out incrementally
- A/B testing scenarios

### Naming Convention
```
<type>_<feature_name>
```

Types: `development`, `ops`, `experiment`

### Documentation
Include in MR description:
```markdown
## Feature flag

Name: `feature_flag_name`
Default: disabled
```

## Security Considerations

### For Security-Related MRs
1. Do NOT include vulnerability details in public MRs
2. Link to confidential issue instead
3. Request security review
4. Follow secure coding guidelines
5. Add `security` label

### Secure Coding Checklist
- [ ] Input validation
- [ ] Authorization checks
- [ ] No sensitive data in logs
- [ ] SQL injection prevention
- [ ] XSS prevention

## Breaking Changes

### Process
1. Add `breaking change` label
2. Document in MR description
3. Update deprecation notices
4. Follow deprecation guidelines
5. Target next major release

### Documentation Required
```markdown
## Breaking changes

This MR introduces a breaking change:
- **What changes**: [description]
- **Migration path**: [how users should adapt]
- **Target release**: [version]
```

## Cross-Project MRs (Forks)

### Workflow
1. Fork the upstream project
2. Create feature branch in fork
3. Push changes to fork
4. Create MR targeting upstream
5. Use `target_project_id` parameter

### Best Practices
- Keep fork synced with upstream
- Reference upstream issues with full URLs
- Follow upstream's contribution guidelines
