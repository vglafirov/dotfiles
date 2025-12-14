# GitLab Labels Reference

Reference for GitLab labels organized by category. Use labels as comma-separated strings (e.g., `type::bug,severity::2,devops::verify`).

## Table of Contents
- [Required Labels](#required-labels)
- [Type Labels](#type-labels)
- [Workflow Labels](#workflow-labels)
- [Severity Labels](#severity-labels)
- [Priority Labels](#priority-labels)
- [DevOps Stage Labels](#devops-stage-labels)
- [Group Labels](#group-labels)
- [Specialization Labels](#specialization-labels)
- [Bug Subtype Labels](#bug-subtype-labels)
- [Feature Labels](#feature-labels)
- [Database Labels](#database-labels)
- [Security Labels](#security-labels)

## Required Labels

Every issue MUST have:
- **Type label** (`type::*`) - What kind of work this is

Recommended for all issues:
- **Stage label** (`devops::*`) - Which DevOps stage
- **Group label** (`group::*`) - Which team owns this
- **Category label** (`Category:*`) - Product category

For bugs additionally:
- **Severity label** (`severity::*`) - Impact level
- **Priority label** (`priority::*`) - Scheduling priority

## Type Labels

| Label | Description |
|-------|-------------|
| `type::bug` | Defects in shipped code and bugs in the product |
| `type::feature` | New feature functionality |
| `type::maintenance` | Refactoring, tech debt, developer tooling |
| `type::tooling` | Internal tooling improvements |
| `type::ignore` | Issues to exclude from metrics |

## Workflow Labels

Default for new issues: `workflow::start`

| Label | Description |
|-------|-------------|
| `workflow::start` | Initial state for new issues |
| `workflow::problem validation` | Validating the problem |
| `workflow::design` | Design work in progress |
| `workflow::solution validation` | Validating proposed solution |
| `workflow::planning breakdown` | Breaking down into tasks |
| `workflow::ready for development` | Ready to be picked up |
| `workflow::in dev` | Development in progress |
| `workflow::in review` | Code review in progress |
| `workflow::verification` | Verifying the implementation |
| `workflow::blocked` | Blocked by external dependency |
| `workflow::production` | Deployed to production |
| `workflow::complete` | Work completed |

## Severity Labels

For bugs - measures user impact:

| Label | Description | Response Time |
|-------|-------------|---------------|
| `severity::1` | Blocker - GitLab.com unusable, security breach, data loss | Immediate |
| `severity::2` | Critical - Feature broken, no workaround, significant impact | Days |
| `severity::3` | Major - Feature impaired but workaround exists | Weeks |
| `severity::4` | Low - Minor inconvenience, cosmetic issues | Backlog |

## Priority Labels

For bugs - scheduling priority based on business impact:

| Label | Description |
|-------|-------------|
| `priority::1` | Urgent - Fix immediately, may require hotfix |
| `priority::2` | High - Fix in current milestone |
| `priority::3` | Medium - Fix soon, schedule in upcoming milestones |
| `priority::4` | Low - Fix when possible |

### Severity/Priority Matrix

| Severity | Priority 1 | Priority 2 | Priority 3 | Priority 4 |
|----------|------------|------------|------------|------------|
| severity::1 | Immediate hotfix | Current milestone | - | - |
| severity::2 | Current milestone | Current milestone | Next milestone | - |
| severity::3 | Current milestone | Next 1-2 milestones | Next 2-3 milestones | Backlog |
| severity::4 | Next milestone | Next 2-3 milestones | Backlog | Backlog |

## DevOps Stage Labels

| Label | Description |
|-------|-------------|
| `devops::plan` | Project Management, Agile, Requirements |
| `devops::create` | Source Code, Code Review, Web IDE, Design Management |
| `devops::verify` | CI, Code Quality, Testing |
| `devops::package` | Package Registry, Container Registry |
| `devops::deploy` | CD, Environments, Feature Flags |
| `devops::govern` | Compliance, Security Policies, Audit |
| `devops::ai-powered` | AI features, GitLab Duo |
| `devops::data stores` | Database, Global Search, Tenant Scale |
| `devops::systems` | Distribution, Geo, Gitaly |
| `devops::fulfillment` | Subscriptions, Licensing |
| `devops::growth` | Activation, Adoption, Conversion |
| `devops::foundations` | Import, Integrations, Personal Productivity |
| `devops::analytics` | Analytics stage |
| `devops::anti-abuse` | Anti-abuse features |
| `devops::application security testing` | SAST, DAST, Secret Detection |
| `devops::security risk management` | Security risk features |

## Group Labels

Common group labels (use `group::*` prefix):

### Plan Stage
- `group::project management` - Issue tracking, boards
- `group::product planning` - Epics, roadmaps
- `group::knowledge` - Wiki, documentation
- `group::optimize` - Analytics, insights

### Create Stage
- `group::source code` - Repository, branches
- `group::code review` - Merge requests
- `group::code creation` - Code Suggestions
- `group::editor extensions` - IDE plugins
- `group::remote development` - Workspaces

### Verify Stage
- `group::pipeline execution` - CI/CD pipelines
- `group::pipeline authoring` - Pipeline configuration
- `group::runner core` - GitLab Runner

### Secure/Govern
- `group::static analysis` - SAST
- `group::dynamic analysis` - DAST
- `group::composition analysis` - Dependency scanning
- `group::secret detection` - Secret detection
- `group::security policies` - Security policies
- `group::compliance` - Compliance features
- `group::authentication` - Auth features
- `group::authorization` - Permissions

### AI-Powered
- `group::ai framework` - AI infrastructure
- `group::duo chat` - GitLab Duo Chat
- `group::code creation` - Code Suggestions

## Specialization Labels

| Label | Description |
|-------|-------------|
| `frontend` | Frontend/UI work required |
| `backend` | Backend work required |
| `documentation` | Documentation updates needed |
| `database` | Database changes required |
| `UX` | UX design work needed |
| `security` | Security-related work |

## Bug Subtype Labels

| Label | Description |
|-------|-------------|
| `bug::availability` | Impacting GitLab.com availability |
| `bug::functional` | Functional defects |
| `bug::performance` | Performance issues |
| `bug::ux` | UX defects |
| `bug::mobile` | Mobile browser issues |
| `bug::vulnerability` | Security vulnerabilities |
| `bug::transient` | Intermittent/flaky issues |

## Feature Labels

| Label | Description |
|-------|-------------|
| `feature::addition` | New MVC capability |
| `feature::enhancement` | Improvement to existing feature |
| `feature::consolidation` | Merging features for simplification |

## Database Labels

| Label | Description |
|-------|-------------|
| `database` | Database-related issues |
| `database::review pending` | Needs DB review |
| `database::reviewed` | DB reviewed |
| `database::approved` | DB changes approved |

## Security Labels

For security issues, set `confidential: true` and use:

| Label | Description |
|-------|-------------|
| `security` | Security-related work |
| `bug::vulnerability` | Security vulnerability |

## Common Category Labels

Categories are product areas (use `Category:*` prefix):

| Label | Description |
|-------|-------------|
| `Category:Issue Tracking` | Issues, boards |
| `Category:Portfolio Management` | Epics, roadmaps |
| `Category:Code Review Workflow` | Merge requests |
| `Category:Continuous Integration` | CI pipelines |
| `Category:Container Registry` | Container images |
| `Category:Package Registry` | Package management |
| `Category:SAST` | Static analysis |
| `Category:DAST` | Dynamic analysis |
| `Category:Secret Detection` | Secret scanning |
| `Category:Vulnerability Management` | Vuln tracking |
| `Category:GitLab Duo Chat` | AI chat |
| `Category:Code Suggestions` | AI code completion |
| `Category:Global Search` | Search features |
| `Category:Audit Events` | Audit logging |

## Label Selection Guidelines

1. **Always add type label first** - determines issue classification
2. **Add stage and group labels** - helps with routing and ownership
3. **For bugs, assess severity and priority** - guides scheduling
4. **Add specialization labels** - helps identify required expertise
5. **Security issues** - make confidential and add security labels
6. **Use scoped labels** - only one label per scope (e.g., one `type::*`)

## Examples

### Bug Issue
```
type::bug,severity::2,priority::2,devops::verify,group::pipeline execution,bug::functional
```

### Feature Issue
```
type::feature,devops::create,group::code review,Category:Code Review Workflow
```

### Maintenance Issue
```
type::maintenance,devops::data stores,group::database frameworks,database
```

### Security Issue (Confidential)
```
type::bug,severity::1,priority::1,security,bug::vulnerability
confidential: true
```
