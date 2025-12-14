# Labels for MR Reviews

Labels relevant to the code review process and workflow management.

## Table of Contents
- [Workflow Labels](#workflow-labels)
- [Type Labels](#type-labels)
- [Specialization Labels](#specialization-labels)
- [Review State Labels](#review-state-labels)
- [Priority and Severity](#priority-and-severity)
- [DevOps Stage Labels](#devops-stage-labels)
- [Common Label Combinations](#common-label-combinations)

## Workflow Labels

Scoped labels tracking MR progress through review stages.

| Label | Description | When to Apply |
|-------|-------------|---------------|
| `workflow::start` | Work not yet begun | Initial state |
| `workflow::design` | In design/planning phase | Before implementation |
| `workflow::in dev` | Under development | Active coding |
| `workflow::in review` | Ready for/under review | After code complete |
| `workflow::verification` | Being verified | Post-review testing |
| `workflow::blocked` | Blocked on something | Waiting on dependency |
| `workflow::production` | Deployed to production | After merge |

### Workflow Transitions During Review

```
Author completes work    → workflow::in review
Reviewer requests changes → (keep) workflow::in review
Reviewer approves        → workflow::verification (or ready for maintainer)
Maintainer merges        → workflow::production
```

## Type Labels

Required on all MRs. Only one type label per MR.

| Label | Use For |
|-------|---------|
| `type::bug` | Bug fixes, defect resolution |
| `type::feature` | New functionality |
| `type::maintenance` | Refactoring, tech debt, docs, dependencies |

## Specialization Labels

Indicate which domains the MR touches. Apply all that are relevant.

| Label | Description |
|-------|-------------|
| `frontend` | Frontend/UI changes |
| `backend` | Backend code changes |
| `database` | Database schema/query changes |
| `documentation` | Documentation updates |
| `security` | Security-related changes |
| `performance` | Performance improvements |
| `UX` | User experience changes |
| `technical writing` | Technical writing review needed |

## Review State Labels

Track review progress and requirements.

| Label | Description |
|-------|-------------|
| `needs-discussion` | Requires discussion before proceeding |
| `awaiting-security-release` | Waiting for security release |
| `database::review pending` | Needs database review |
| `database::reviewed` | Database review complete |
| `ready for merge` | All approvals received, ready to merge |
| `pipeline::expedited` | Expedite pipeline processing |

### Feature Flag Labels

For changes involving feature flags:

| Label | Description |
|-------|-------------|
| `feature flag` | Change involves a feature flag |
| `feature::addition` | Adding a new feature flag |
| `feature::removal` | Removing an existing feature flag |
| `feature::maintained` | Feature flag will be maintained long-term |

### Review Discussion Labels

| Label | Description |
|-------|-------------|
| `needs-verification` | Needs verification by author/reviewer |
| `unblocks others` | Other work depends on this MR |
| `customer` | Customer-reported or customer-impacting |

## Priority and Severity

### Priority Labels

For bugs and urgent work:

| Label | Description |
|-------|-------------|
| `priority::1` | Urgent - address immediately |
| `priority::2` | High - address this milestone |
| `priority::3` | Medium - planned work |
| `priority::4` | Low - when time permits |

### Severity Labels

For bugs only:

| Label | Description |
|-------|-------------|
| `severity::1` | Blocker - data loss, security breach, complete failure |
| `severity::2` | Critical - major functionality broken, no workaround |
| `severity::3` | Major - significant impact, workaround exists |
| `severity::4` | Minor - low impact, cosmetic issues |

### Bug Type Labels

| Label | Description |
|-------|-------------|
| `bug::availability` | Affects system availability |
| `bug::performance` | Performance degradation |
| `bug::vulnerability` | Security vulnerability (use with confidential) |
| `bug::ux` | User experience issue |
| `bug::functional` | Functional defect |
| `bug::transient` | Intermittent/flaky issue |
| `bug::mobile` | Mobile-specific issue |

## DevOps Stage Labels

Indicate which DevOps stage the MR relates to.

| Label | Areas |
|-------|-------|
| `devops::plan` | Issues, epics, boards, roadmaps |
| `devops::create` | Source code, merge requests, code review |
| `devops::verify` | CI/CD, pipelines, testing |
| `devops::package` | Package registry, container registry |
| `devops::secure` | Security scanning, vulnerabilities |
| `devops::release` | Release management, deployments |
| `devops::configure` | Infrastructure, Kubernetes |
| `devops::monitor` | Logging, metrics, error tracking |
| `devops::govern` | Compliance, audit, policies |
| `devops::manage` | Admin, authentication, users |
| `devops::data stores` | Database, search, storage |
| `devops::fulfillment` | Licensing, subscriptions |
| `devops::platforms` | Platform infrastructure |

## Common Label Combinations

### Bug Fix MR
```
type::bug, severity::*, priority::*, devops::*, group::*, backend/frontend
```

### Feature MR
```
type::feature, devops::*, group::*, backend/frontend
```

### Database Change
```
type::maintenance, database, database::review pending, backend
```

### Security Fix
```
type::bug, security, severity::*, priority::1
```
(Usually confidential)

### Documentation Only
```
type::maintenance, documentation, technical writing
```

### Performance Fix
```
type::bug, bug::performance, backend/frontend
```

### Refactoring
```
type::maintenance, devops::*, group::*, backend/frontend
```

## Label Management During Review

### When Starting Review

Check for:
- Type label present
- Appropriate specialization labels
- DevOps stage/group labels
- `workflow::in review` set

### After Review Complete

If approved:
- Consider removing `database::review pending` if DB review done
- Add `ready for merge` if all approvals present

If changes requested:
- Keep `workflow::in review`
- Add `needs-discussion` if significant discussion needed

### Quick Label Commands

In MR comments, use quick actions:

```
/label ~"workflow::in review"
/label ~backend ~database
/unlabel ~"database::review pending"
/label ~"database::reviewed"
```

## Label Selection Guide

Based on MR content, suggest appropriate labels:

| MR Contains | Suggested Labels |
|-------------|------------------|
| Ruby/Go backend code | `backend` |
| JavaScript/Vue/CSS | `frontend` |
| .rb migration files | `database`, `database::review pending` |
| .md documentation | `documentation` |
| spec/test files only | `type::maintenance` |
| Security-related | `security` |
| CI/pipeline changes | `devops::verify` |
| API endpoint changes | `backend` |
| Performance optimization | `bug::performance` or `performance` |
