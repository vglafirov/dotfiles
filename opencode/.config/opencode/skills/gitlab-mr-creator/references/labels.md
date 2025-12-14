# GitLab MR Labels Reference

Labels for merge requests organized by category. Use as comma-separated strings (e.g., `type::bug,devops::verify,backend`).

## Table of Contents
- [Type Labels](#type-labels)
- [Workflow Labels](#workflow-labels)
- [DevOps Stage Labels](#devops-stage-labels)
- [Group Labels](#group-labels)
- [Specialization Labels](#specialization-labels)
- [Review Labels](#review-labels)
- [Priority Labels](#priority-labels)
- [Breaking Change Labels](#breaking-change-labels)

## Type Labels

| Label | Description |
|-------|-------------|
| `type::bug` | Bug fix |
| `type::feature` | New feature implementation |
| `type::maintenance` | Refactoring, tech debt, cleanup |
| `type::tooling` | Internal tooling improvements |

## Workflow Labels

| Label | Description |
|-------|-------------|
| `workflow::in dev` | Development in progress |
| `workflow::in review` | Code review in progress |
| `workflow::blocked` | Blocked by external dependency |
| `workflow::verification` | Verifying the implementation |
| `workflow::production` | Deployed to production |

## DevOps Stage Labels

| Label | Description |
|-------|-------------|
| `devops::plan` | Project Management, Agile, Requirements |
| `devops::create` | Source Code, Code Review, Web IDE |
| `devops::verify` | CI, Code Quality, Testing |
| `devops::package` | Package Registry, Container Registry |
| `devops::deploy` | CD, Environments, Feature Flags |
| `devops::govern` | Compliance, Security Policies, Audit |
| `devops::ai-powered` | AI features, GitLab Duo |
| `devops::data stores` | Database, Global Search |
| `devops::systems` | Distribution, Geo, Gitaly |
| `devops::fulfillment` | Subscriptions, Licensing |
| `devops::foundations` | Import, Integrations |
| `devops::application security testing` | SAST, DAST, Secret Detection |

## Group Labels

Common group labels (prefix `group::`):

### Create Stage
- `group::source code` - Repository, branches
- `group::code review` - Merge requests
- `group::code creation` - Code Suggestions
- `group::editor extensions` - IDE plugins

### Verify Stage
- `group::pipeline execution` - CI/CD pipelines
- `group::pipeline authoring` - Pipeline configuration
- `group::runner core` - GitLab Runner

### Secure/Govern
- `group::static analysis` - SAST
- `group::dynamic analysis` - DAST
- `group::composition analysis` - Dependency scanning
- `group::secret detection` - Secret detection
- `group::authentication` - Auth features
- `group::authorization` - Permissions

### AI-Powered
- `group::ai framework` - AI infrastructure
- `group::duo chat` - GitLab Duo Chat

## Specialization Labels

| Label | Description |
|-------|-------------|
| `frontend` | Frontend/UI work |
| `backend` | Backend work |
| `documentation` | Documentation updates |
| `database` | Database changes |
| `UX` | UX design work |
| `security` | Security-related work |
| `infradev` | Infrastructure development |
| `technical writing` | Technical writing review needed |

## Review Labels

| Label | Description |
|-------|-------------|
| `database::review pending` | Needs DB review |
| `database::reviewed` | DB reviewed |
| `database::approved` | DB changes approved |
| `security::reviewed` | Security reviewed |
| `UX::reviewed` | UX reviewed |

## Priority Labels

| Label | Description |
|-------|-------------|
| `priority::1` | Urgent - needs immediate attention |
| `priority::2` | High - current milestone |
| `priority::3` | Medium - schedule in upcoming milestones |
| `priority::4` | Low - fix when possible |

## Breaking Change Labels

| Label | Description |
|-------|-------------|
| `breaking change` | Backwards-incompatible change for next major release |
| `Deprecation` | Feature being deprecated |

## MR-Specific Labels

| Label | Description |
|-------|-------------|
| `community contribution` | MR from community contributor |
| `coach will finish` | Merge request coach will complete |
| `Seeking community contributions` | Open for community work |
| `quick win` | Small, easy to review MR |
| `backstage` | Internal tooling/infrastructure |

## Label Selection Guidelines

1. **Always add type label** - `type::bug`, `type::feature`, or `type::maintenance`
2. **Add stage and group labels** - helps routing and ownership
3. **Add specialization labels** - `frontend`, `backend`, `database`, `documentation`
4. **For database changes** - add `database::review pending`
5. **For UI changes** - add `frontend` and consider `UX`
6. **For breaking changes** - add `breaking change`

## Examples

### Bug Fix MR
```
type::bug,devops::verify,group::pipeline execution,backend
```

### Feature MR
```
type::feature,devops::create,group::code review,frontend,backend
```

### Database Migration MR
```
type::maintenance,devops::data stores,database,database::review pending
```

### Documentation MR
```
type::maintenance,documentation,technical writing
```
