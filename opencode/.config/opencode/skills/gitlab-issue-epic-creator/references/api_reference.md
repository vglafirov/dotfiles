# GitLab API Tools Reference

Tools available for issue and epic creation workflows.

## Table of Contents
- [Issue Tools](#issue-tools)
  - [Issue Management](#issue-management)
  - [Issue Comments & Discussions](#issue-comments--discussions)
- [Epic Tools](#epic-tools)
  - [Epic Management](#epic-management)
  - [Epic-Issue Relationships](#epic-issue-relationships)
  - [Epic Comments & Discussions](#epic-comments--discussions)
- [Search Tools](#search-tools)
- [Project Tools](#project-tools)
- [Common Patterns](#common-patterns)

## Issue Tools

### Issue Management

#### gitlab_create_issue

Create a new project issue.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or URL-encoded path |
| `title` | string | Yes | Issue title |
| `description` | string | No | Issue description (markdown) |
| `labels` | string | No | Comma-separated label names |
| `confidential` | boolean | No | Mark as confidential |
| `assignee_ids` | array | No | User IDs to assign |
| `milestone_id` | integer | No | Milestone ID |
| `epic_id` | integer | No | Epic ID to associate |

**Example:**
```
gitlab_create_issue(
  id: "gitlab-org/gitlab",
  title: "Pipeline fails when runner disconnects",
  description: "### Summary\n\nPipeline jobs fail...",
  labels: "type::bug,severity::2,devops::verify",
  confidential: false
)
```

#### gitlab_list_issues

List issues for a project.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | No | Project ID or path |
| `state` | string | No | `opened`, `closed`, `all` |
| `labels` | string | No | Comma-separated labels |
| `search` | string | No | Search in title/description |
| `scope` | string | No | `assigned_to_me`, `created_by_me`, `all` |
| `limit` | number | No | Max results |

#### gitlab_get_issue

Get a single issue.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or path |
| `issue_iid` | integer | Yes | Issue internal ID |

### Issue Comments & Discussions

#### gitlab_create_issue_note

Add a comment to an issue. Supports threaded replies when `discussion_id` is provided.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `issue_iid` | number | Yes | Issue internal ID |
| `body` | string | Yes | Comment content |
| `discussion_id` | string | No | Discussion ID to reply to (for threaded comments) |

**Example:**
```
# Add a new comment
gitlab_create_issue_note(
  project_id: "gitlab-org/gitlab",
  issue_iid: 123,
  body: "Additional reproduction steps..."
)

# Reply to a discussion thread
gitlab_create_issue_note(
  project_id: "gitlab-org/gitlab",
  issue_iid: 123,
  body: "Thanks for the clarification!",
  discussion_id: "abc123def456"
)
```

#### gitlab_list_issue_notes

List all notes/comments on an issue in chronological order.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `issue_iid` | number | Yes | Issue internal ID |

**Returns:** Flat list of all comments including system notes.

#### gitlab_list_issue_discussions

List discussion threads on an issue. Each discussion contains nested notes.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `issue_iid` | number | Yes | Issue internal ID |

**Returns:** Array of discussions, each with a `notes` array containing thread comments.

#### gitlab_get_issue_discussion

Get a specific discussion thread with all its replies.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `issue_iid` | number | Yes | Issue internal ID |
| `discussion_id` | string | Yes | Discussion thread ID |

**Returns:** Discussion object with full `notes` array for the thread.

## Epic Tools

### Epic Management

#### gitlab_create_epic

Create a new epic in a group.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `title` | string | Yes | Epic title |
| `description` | string | No | Epic description |
| `labels` | string | No | Comma-separated labels |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `confidential` | boolean | No | Mark as confidential |

**Example:**
```
gitlab_create_epic(
  group_id: "gitlab-org",
  title: "Improve CI/CD pipeline performance",
  description: "## Summary\n\nThis epic tracks...",
  labels: "devops::verify"
)
```

#### gitlab_list_epics

List epics for a group.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `state` | string | No | `opened`, `closed`, `all` |
| `labels` | string | No | Comma-separated labels |
| `search` | string | No | Search query |
| `limit` | number | No | Max results |

#### gitlab_get_epic

Get a single epic.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |

#### gitlab_update_epic

Update an existing epic.

### Epic-Issue Relationships

#### gitlab_add_issue_to_epic

Link an issue to an epic.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |
| `issue_id` | number | Yes | Issue global ID |

Update an existing epic.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |
| `title` | string | No | New title |
| `description` | string | No | New description |
| `labels` | string | No | New labels |
| `state_event` | string | No | `close` or `reopen` |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `confidential` | boolean | No | Update confidentiality |

**Example:**
```
gitlab_update_epic(
  group_id: "gitlab-org",
  epic_iid: 42,
  title: "Improve CI/CD Performance (Updated)",
  labels: "devops::verify,priority::1"
)
```

#### gitlab_list_epic_issues

Get all issues associated with an epic.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |

**Returns:** List of issues linked to the epic with their details.

#### gitlab_remove_issue_from_epic

Unlink an issue from an epic.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |
| `epic_issue_id` | number | Yes | Epic-issue link ID (from `list_epic_issues`) |

**Example:**
```
# First, list issues to get epic_issue_id
issues = gitlab_list_epic_issues(group_id: "gitlab-org", epic_iid: 42)

# Then remove specific issue
gitlab_remove_issue_from_epic(
  group_id: "gitlab-org",
  epic_iid: 42,
  epic_issue_id: 789
)
```

### Epic Comments & Discussions

#### gitlab_create_epic_note

Add a comment to an epic. Supports threaded replies when `discussion_id` is provided.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |
| `body` | string | Yes | Comment content |
| `discussion_id` | string | No | Discussion ID to reply to (for threaded comments) |

**Example:**
```
# Add a new comment
gitlab_create_epic_note(
  group_id: "gitlab-org",
  epic_iid: 42,
  body: "Updated timeline based on team feedback"
)

# Reply to a discussion
gitlab_create_epic_note(
  group_id: "gitlab-org",
  epic_iid: 42,
  body: "Agreed, let's prioritize this",
  discussion_id: "xyz789abc"
)
```

#### gitlab_list_epic_notes

List all comments/notes on an epic in chronological order.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |

**Returns:** Flat list of all comments in chronological order.

#### gitlab_list_epic_discussions

List discussion threads on an epic. Each discussion contains nested notes.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |

**Returns:** Array of discussions, each with a `notes` array containing thread comments.

#### gitlab_get_epic_discussion

Get a specific discussion thread from an epic with all its replies.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `group_id` | string | Yes | Group ID or path |
| `epic_iid` | number | Yes | Epic internal ID |
| `discussion_id` | string | Yes | Discussion thread ID |

**Returns:** Discussion object with full `notes` array for the thread.

## Search Tools

### gitlab_issue_search

Search issues by keyword.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |
| `state` | string | No | `opened`, `closed`, `all` |
| `labels` | string | No | Filter by labels |
| `limit` | number | No | Max results |

**Example:**
```
gitlab_issue_search(
  search: "pipeline runner disconnect",
  project_id: "gitlab-org/gitlab",
  state: "opened",
  limit: 10
)
```

### gitlab_search

Search across GitLab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scope` | string | Yes | `issues`, `merge_requests`, etc. |
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |
| `limit` | number | No | Max results |

## Project Tools

### gitlab_get_project

Get project details.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |

**Returns:** Project info including ID, path, group, default branch.

### gitlab_list_project_members

List project members.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |

## Common Patterns

### Get Project from Current Directory

```bash
# Extract project path from git remote
git remote get-url origin | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

### Search Before Create

Always search for duplicates before creating:
```
1. gitlab_issue_search(search: "<key terms>", project_id: "<project>", state: "opened")
2. Review results for potential duplicates
3. If no duplicates, proceed with gitlab_create_issue
```

### Create Epic with Issues

```
1. gitlab_create_epic(group_id: "<group>", title: "<title>", ...)
2. For each child issue:
   - gitlab_create_issue(id: "<project>", title: "<title>", ...)
   - gitlab_add_issue_to_epic(group_id: "<group>", epic_iid: <epic_iid>, issue_id: <issue_id>)
```

### Add Follow-up Comment to Issue

```
1. gitlab_get_issue(id: "<project>", issue_iid: <iid>)
2. gitlab_create_issue_note(project_id: "<project>", issue_iid: <iid>, body: "<comment>")
```

### Participate in Discussion Thread

```
1. gitlab_list_issue_discussions(project_id: "<project>", issue_iid: <iid>)
2. Identify discussion_id from results
3. gitlab_create_issue_note(
     project_id: "<project>",
     issue_iid: <iid>,
     body: "<reply>",
     discussion_id: "<discussion_id>"
   )
```

### Manage Epic Issues

```
# View all issues in epic
1. gitlab_list_epic_issues(group_id: "<group>", epic_iid: <epic_iid>)

# Remove issue from epic
2. gitlab_remove_issue_from_epic(
     group_id: "<group>",
     epic_iid: <epic_iid>,
     epic_issue_id: <epic_issue_id>
   )
```

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| 404 Not Found | Invalid project/group ID | Verify ID/path exists |
| 403 Forbidden | Insufficient permissions | Check user access level |
| 400 Bad Request | Invalid parameters | Check required fields |
| 409 Conflict | Duplicate resource | Search for existing item |
