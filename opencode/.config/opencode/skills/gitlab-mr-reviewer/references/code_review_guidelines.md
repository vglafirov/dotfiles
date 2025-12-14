# GitLab Code Review Guidelines

Standards and checklists from GitLab's official code review documentation.

## Table of Contents
- [Quick Reference](#quick-reference)
- [Role Responsibilities](#role-responsibilities)
- [Acceptance Checklist](#acceptance-checklist)
- [Review Focus by Domain](#review-focus-by-domain)
- [Approval Guidelines](#approval-guidelines)
- [Best Practices](#best-practices)
- [GitLab-Specific Concerns](#gitlab-specific-concerns)

## Quick Reference

Summary of key checkpoints for each review type:

| Review Type | Key Focus Areas | Primary Responsibilities |
|-------------|-----------------|--------------------------|
| **Self-Review** (Author) | • Tests pass and pipeline is green<br>• Description complete (what/why/how)<br>• Labels applied correctly<br>• Related issues linked | • Perform self-review per guidelines<br>• Verify solution solves intended problem<br>• Check for bugs and edge cases<br>• Add explanatory comments |
| **Reviewer** | • Correctness and logic<br>• Code quality and maintainability<br>• Test coverage adequacy<br>• Security considerations<br>• Performance implications | • Review within SLO timeframe<br>• Verify acceptance criteria met<br>• Guide author on improvements<br>• Approve when confident |
| **Maintainer** | • Architecture fit<br>• Cross-domain consistency<br>• Overall code organization<br>• Separation of concerns<br>• Technical debt avoidance | • Focus on high-level design<br>• Ensure consistency across domains<br>• Verify acceptance criteria<br>• Check required approvals before merge |

## Role Responsibilities

### MR Author Responsibilities

Before requesting review:
- Perform self-review following code review guidelines
- Ensure solution solves the intended problem appropriately
- Verify all requirements satisfied
- Check for bugs, logic problems, uncovered edge cases
- Add comments explaining decisions and trade-offs
- Ensure tests pass before requesting maintainer review

When assigning reviewers:
- Add comment indicating which review type needed (e.g., `~backend`, `~database`)
- Provide access to any required assets (snippets, projects)
- Request maintainer reviews only when tests pass

### Reviewer Responsibilities

- Review within [Review-response SLO](https://handbook.gitlab.com/handbook/engineering/workflow/code-review/#review-response-slo)
- If unavailable, reassign using reviewer roulette
- Verify MR meets contribution acceptance criteria
- Guide author to split large MRs (>200 lines recommended)
- If local verification steps provided, indicate if performed
- When confident, approve and request maintainer review

### Maintainer Responsibilities

- Focus on overall architecture, code organization, separation of concerns
- Ensure consistency across domains and product areas
- Verify acceptance criteria reasonably met
- Avoid creating technical debt in follow-up issues
- Can request additional domain expert review if needed
- Check required approvals before merging

## Acceptance Checklist

### Quality

- [ ] Self-reviewed per code review guidelines
- [ ] Code follows software design guidelines
- [ ] Automated tests exist following testing pyramid
- [ ] Considered technical impacts on GitLab.com, Dedicated, self-managed
- [ ] Applied appropriate labels (`~ux`, `~frontend`, `~backend`, `~database`)
- [ ] Tested in all supported browsers (if applicable)
- [ ] Change is backwards compatible across updates
- [ ] EE content properly separated from FOSS (if applicable)
- [ ] Existing data variations considered
- [ ] Related flaky tests fixed or explained

### Performance, Reliability, Availability

- [ ] MR does not harm performance (or assessed by reviewer)
- [ ] Database reviewer information included (if DB changes)
- [ ] Availability and reliability risks considered
- [ ] Scalability risk assessed for future growth
- [ ] Impact on large customers considered
- [ ] Impact on minimum system requirements considered

### Observability

- [ ] Sufficient instrumentation for debugging and monitoring
- [ ] Feature flags, logging, metrics added where appropriate

### Documentation

- [ ] Changelog trailers included (if needed)
- [ ] Documentation added/updated (if needed)

### Security

- [ ] If credentials/auth changes, added `~security` label and mentioned `@gitlab-com/gl-security/appsec`
- [ ] Security review requested if warranted
- [ ] Security scan findings addressed (true positives fixed, false positives discussed)

### Deployment

- [ ] Feature flag considered for high-risk changes
- [ ] Staging testing planned before production
- [ ] Infrastructure team informed of setting changes (if applicable)

### Compliance

- [ ] Correct MR type label applied

## Review Focus by Domain

### Backend Review

Check for:
- Logic correctness and edge cases
- Error handling completeness
- Security vulnerabilities (injection, auth bypass)
- Performance (N+1 queries, inefficient algorithms)
- Test coverage for new code
- API backwards compatibility
- Proper use of background jobs for long operations

### Frontend Review

Check for:
- UX consistency with design system
- Accessibility (WCAG compliance)
- Browser compatibility
- Performance (bundle size, render efficiency)
- Responsive design
- Proper error states and loading indicators
- Test coverage (unit, feature specs)

### Database Review

Required for:
- Database migrations
- Changes to expensive queries

Check for:
- Migration reversibility
- Performance at GitLab.com scale
- Proper categorization (regular vs post-deployment vs background)
- Query efficiency (include EXPLAIN ANALYZE)
- Index usage
- Multi-version compatibility for rolling deployments

Database migration types:
- **Regular migrations** - run before new code deployed
- **Post-deployment migrations** - run after new code deployed
- **Batched background migrations** - run in Sidekiq for large tables

### Security Review

Required when changes involve:
- Credentials or token processing/storage
- Authorization and authentication methods
- Items in security review guidelines

Check for:
- Input validation
- Output encoding
- Authorization checks
- Secure coding guideline compliance
- No sensitive information in logs

### Documentation Review

Check for:
- Technical accuracy
- Following documentation guidelines
- Working links
- Grammar and spelling
- Proper formatting

## Approval Guidelines

| Change Type | Required Approver |
|-------------|-------------------|
| `~backend` changes | Backend maintainer |
| `~database` migrations/queries | Database maintainer |
| `~workhorse` changes | Workhorse maintainer |
| `~frontend` changes | Frontend maintainer |
| `~UX` user-facing changes | Product Designer |
| New JavaScript library | Frontend Design System + Legal (if new license) |
| New dependency/file system change | Distribution team |
| `~documentation` or `~UI text` | Technical writer |
| Development guidelines changes | EM/Staff Engineer approval |
| End-to-end + non-E2E changes | Software Engineer in Test |
| End-to-end only changes | Quality maintainer |
| Application limits | Product manager |
| Analytics instrumentation | Analytics Instrumentation engineer |
| Feature specs | Quality maintainer/reviewer |
| New service component | Product manager |
| Authentication changes | Manage:Authentication team |
| Custom roles/policies | Manage:Authorization Engineer |

### Notes on Approvals

- Specs (except JS specs) are considered `~backend`
- Haml markup is `~frontend`, Ruby code in Haml is `~backend`
- For database concerns, seek guidance from database maintainer even if unsure
- User-facing changes require UX review even behind feature flags
- MR author cannot approve their own MR

## Best Practices

### For Everyone

- Be kind
- Accept that many decisions are opinions - discuss tradeoffs, reach resolution quickly
- Ask questions, don't make demands
- Ask for clarification when unclear
- Avoid selective ownership ("mine", "not mine")
- Avoid personal trait references
- Be explicit about intentions
- Be humble
- Don't use hyperbole
- Be careful with sarcasm
- Consider synchronous discussion if too many back-and-forth comments

### For Authors

- First reviewer is yourself - read entire diff before pushing
- Write detailed description per MR guidelines
- Note dependencies on other MRs
- Be grateful for suggestions
- Don't take feedback personally
- Explain why code exists
- Extract unrelated changes to separate MRs
- Respond to every comment
- Only resolve threads you've fully addressed
- Push feedback-based changes as isolated commits until ready to merge

### For Reviewers

- Be thorough to reduce iterations
- Communicate which ideas you feel strongly about
- Identify ways to simplify while solving the problem
- Offer alternatives, assume author considered them
- Seek to understand author's perspective
- Test changes locally when feasible
- If you don't understand something, say so
- Use Conventional Comments format
- Mark non-blocking suggestions clearly
- Provide clear guidance on what's required

### Finding Right Balance

- Building good abstractions enables future changes
- Enforce style primarily through automation
- Ask another maintainer before requesting major rewrites
- Distinguish "doing things right" vs "doing things right now"
- Prioritize shipping over perfection, but avoid shipping kludges

## GitLab-Specific Concerns

### Query Performance

- Test at GitLab.com scale
- Generate large quantities of data locally
- Request query plans from GitLab.com for validation

### Database Migrations

Must be:
- Reversible
- Performant at GitLab.com scale
- Correctly categorized

### Sidekiq Workers

- Cannot change in backwards-incompatible way
- Queues not drained before deploy
- To change signature: accept old and new arguments across two releases
- To remove worker: stop scheduling in one release, remove in next

### Cached Values

- May persist across releases
- If changing return type, change cache key simultaneously

### Settings

- Add as last resort
- Follow process for adding new settings

### File System Access

- Not possible in cloud-native architecture
- Support object storage for any file storage needs

### Multi-version Compatibility

Changes must work during rolling deployments where:
- Some nodes run old code
- Some nodes run new code
- Old Sidekiq jobs may execute on new code
