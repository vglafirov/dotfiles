---
name: gitlab-issue-epic-creator
description: Create well-structured GitLab issues and epics with proper labels, templates, and GitLab conventions. Use when creating bug reports, feature proposals, maintenance tasks, spikes, or epics. Automatically searches for duplicates, applies appropriate labels based on content, follows GitLab development workflows, and supports post-creation collaboration through comments and discussion threads.
---

# GitLab Issue and Epic Creator

Create issues and epics following GitLab's development processes and labeling conventions.

## Quick Start

```
User: "Create a bug report for pipeline failures when runners disconnect"
→ Search for duplicates → Generate bug template → Apply labels → Create issue

User: "Create an epic for improving CI performance with child issues"
→ Create epic → Prompt for child issues → Link issues to epic

User: "I found a security vulnerability in the authentication flow"
→ Create confidential issue → Apply security labels → Use bug template

User: "Add a comment to issue #123 with reproduction steps"
→ Get issue details → Add comment with steps → Confirm posted
```

## Workflow

### 1. Determine Project Context

Get project from current directory unless user specifies another:
```bash
git remote get-url origin | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

For epics, extract group from project path (e.g., `gitlab-org/gitlab` → `gitlab-org`).

### 2. Search for Duplicates

Before creating, search for potential duplicates:
```
gitlab_issue_search(search: "<key terms from title>", project_id: "<project>", state: "opened", limit: 10)
```

If duplicates found:
- Show user the potential matches with URLs
- Ask for confirmation to proceed or link to existing issue
- If confirmed, proceed with creation

### 3. Determine Issue Type

Based on user request, identify type:

| User Intent | Type Label | Template |
|-------------|------------|----------|
| Something broken, error, defect | `type::bug` | Bug Report |
| New functionality, capability | `type::feature` | Feature Proposal |
| Refactoring, tech debt, cleanup | `type::maintenance` | Maintenance |
| Investigation, research needed | `type::spike` | Spike/Research |

### 4. Apply Labels

**Required labels:**
- Type label (`type::bug`, `type::feature`, `type::maintenance`, `type::spike`)
- Workflow label: `workflow::start` (default for new issues)

**Recommended labels** (infer from content):
- DevOps stage (`devops::*`) - based on feature area
- Group (`group::*`) - based on team ownership
- Category (`Category:*`) - product category

**For bugs, additionally determine:**
- Severity (`severity::1-4`) - ask user if unclear
- Priority (`priority::1-4`) - ask user if unclear

See [references/labels.md](references/labels.md) for complete label reference.

### 5. Generate Description

Use appropriate template from [references/templates.md](references/templates.md).

Fill in template sections based on user-provided information. Leave sections as placeholders if information not provided.

### 6. Create Issue/Epic

```
gitlab_create_issue(
  id: "<project_path>",
  title: "<title>",
  description: "<generated description>",
  labels: "<comma-separated labels>",
  confidential: <true if security-related>
)
```

## Issue Type Workflows

### Bug Report

1. Gather: summary, steps to reproduce, expected vs actual behavior
2. Assess severity and priority:
   - **Severity 1**: Blocker, data loss, security breach
   - **Severity 2**: Critical, no workaround
   - **Severity 3**: Major, workaround exists
   - **Severity 4**: Minor, cosmetic
3. Apply labels: `type::bug`, `severity::*`, `priority::*`, stage, group
4. Security bugs: set `confidential: true`, add `security` label

### Feature Proposal

1. Gather: problem statement, intended users, proposed solution
2. Apply labels: `type::feature`, stage, group, category
3. Include success criteria

### Maintenance/Tech Debt

1. Gather: current state, proposed changes, benefits
2. Apply labels: `type::maintenance`, stage, group
3. Include definition of done

### Spike/Research

1. Gather: objective, research questions, scope
2. Apply labels: `type::spike`, stage, group
3. Include time box (recommend 1-2 days)

## Epic Workflow

### Create Epic

```
gitlab_create_epic(
  group_id: "<group_path>",
  title: "<epic title>",
  description: "<epic description>",
  labels: "<labels>"
)
```

### Add Child Issues

After creating epic, ask user if they want to create child issues:

1. For each child issue:
   - Follow issue creation workflow
   - Link to epic using `gitlab_add_issue_to_epic`

2. Update epic description with issue list if needed

### Manage Epic Issues

View and manage issues linked to an epic:

```
# List all issues in an epic
gitlab_list_epic_issues(group_id: "<group>", epic_iid: <epic_iid>)

# Remove an issue from an epic
gitlab_remove_issue_from_epic(group_id: "<group>", epic_iid: <epic_iid>, epic_issue_id: <epic_issue_id>)
```

### Update Epic

Modify epic details after creation:

```
gitlab_update_epic(
  group_id: "<group>",
  epic_iid: <epic_iid>,
  title: "<new title>",
  description: "<new description>",
  labels: "<updated labels>",
  state_event: "close" or "reopen"
)
```

## Post-Creation Collaboration

### Add Comments to Issues

After creating an issue, add follow-up comments or additional context:

```
gitlab_create_issue_note(
  project_id: "<project>",
  issue_iid: <issue_iid>,
  body: "<comment text>"
)
```

### Add Comments to Epics

Provide updates or context to epics:

```
gitlab_create_epic_note(
  group_id: "<group>",
  epic_iid: <epic_iid>,
  body: "<comment text>"
)
```

### Participate in Discussions

View and reply to discussion threads:

```
# List all discussions on an issue
gitlab_list_issue_discussions(project_id: "<project>", issue_iid: <issue_iid>)

# Get specific discussion thread
gitlab_get_issue_discussion(project_id: "<project>", issue_iid: <issue_iid>, discussion_id: "<discussion_id>")

# Reply to a discussion thread
gitlab_create_issue_note(
  project_id: "<project>",
  issue_iid: <issue_iid>,
  body: "<reply text>",
  discussion_id: "<discussion_id>"
)
```

Same pattern applies for epic discussions using `gitlab_list_epic_discussions`, `gitlab_get_epic_discussion`, and `gitlab_create_epic_note` with `discussion_id`.

### View All Comments

List all comments chronologically:

```
# For issues
gitlab_list_issue_notes(project_id: "<project>", issue_iid: <issue_iid>)

# For epics
gitlab_list_epic_notes(group_id: "<group>", epic_iid: <epic_iid>)
```

## Confidentiality Rules

Set `confidential: true` for:
- Security vulnerabilities (`bug::vulnerability`)
- Issues containing sensitive data
- User-requested confidential issues

## Label Auto-Selection Guide

Based on content keywords, suggest labels:

| Keywords | Suggested Labels |
|----------|------------------|
| pipeline, CI, job, runner | `devops::verify`, `group::pipeline execution` |
| merge request, code review | `devops::create`, `group::code review` |
| security, vulnerability, CVE | `security`, `bug::vulnerability`, confidential |
| performance, slow, timeout | `bug::performance` |
| database, migration, schema | `database`, `devops::data stores` |
| frontend, UI, CSS, JavaScript | `frontend` |
| API, endpoint, REST, GraphQL | `backend` |
| authentication, login, SSO | `devops::govern`, `group::authentication` |
| search, elasticsearch | `devops::data stores`, `group::global search` |

## Available Tools

### Issue Tools
| Tool | Purpose |
|------|---------|
| `gitlab_create_issue` | Create new issue |
| `gitlab_get_issue` | Get single issue details |
| `gitlab_list_issues` | List project issues |
| `gitlab_issue_search` | Search for duplicates |
| `gitlab_create_issue_note` | Add comment to issue (supports threaded replies via `discussion_id`) |
| `gitlab_list_issue_notes` | List all comments on an issue chronologically |
| `gitlab_list_issue_discussions` | List discussion threads on an issue |
| `gitlab_get_issue_discussion` | Get specific discussion thread with all replies |

### Epic Tools
| Tool | Purpose |
|------|---------|
| `gitlab_create_epic` | Create new epic |
| `gitlab_get_epic` | Get single epic details |
| `gitlab_list_epics` | List group epics |
| `gitlab_update_epic` | Update existing epic (title, description, labels, state) |
| `gitlab_add_issue_to_epic` | Link issue to epic |
| `gitlab_remove_issue_from_epic` | Unlink issue from epic |
| `gitlab_list_epic_issues` | Get all issues linked to an epic |
| `gitlab_create_epic_note` | Add comment to epic (supports threaded replies via `discussion_id`) |
| `gitlab_list_epic_notes` | List all comments on an epic chronologically |
| `gitlab_list_epic_discussions` | List discussion threads on an epic |
| `gitlab_get_epic_discussion` | Get specific epic discussion thread with all replies |

### Project Tools
| Tool | Purpose |
|------|---------|
| `gitlab_get_project` | Get project details |
| `gitlab_list_project_members` | List project members |

See [references/api_reference.md](references/api_reference.md) for full API details.

## References

- [references/labels.md](references/labels.md) - Complete label reference by category
- [references/templates.md](references/templates.md) - Issue and epic templates
- [references/api_reference.md](references/api_reference.md) - GitLab API tools
