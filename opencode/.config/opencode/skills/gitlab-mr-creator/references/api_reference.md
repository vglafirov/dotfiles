# GitLab MR API Tools Reference

Tools available for merge request creation and management workflows.

## Table of Contents
- [Merge Request Tools](#merge-request-tools)
- [Branch and Commit Tools](#branch-and-commit-tools)
- [Pipeline Tools](#pipeline-tools)
- [Search Tools](#search-tools)
- [Project Tools](#project-tools)

## Merge Request Tools

### gitlab_create_merge_request

Create a new merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or URL-encoded path |
| `title` | string | Yes | MR title |
| `source_branch` | string | Yes | Source branch name |
| `target_branch` | string | Yes | Target branch name |
| `target_project_id` | integer | No | Target project ID (for cross-project MRs) |

**Example:**
```
gitlab_create_merge_request(
  id: "gitlab-org/gitlab",
  title: "Fix pipeline failure on runner disconnect",
  source_branch: "fix-runner-disconnect",
  target_branch: "main"
)
```

### gitlab_update_merge_request

Update an existing merge request (add description, labels, assignees, etc.).

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `title` | string | No | New title |
| `description` | string | No | MR description (markdown) |
| `labels` | string | No | Comma-separated labels |
| `assignee_ids` | array | No | User IDs to assign |
| `reviewer_ids` | array | No | User IDs for reviewers |
| `milestone_id` | number | No | Milestone ID |
| `target_branch` | string | No | Change target branch |
| `squash` | boolean | No | Enable squash on merge |
| `remove_source_branch` | boolean | No | Delete source branch on merge |
| `state_event` | string | No | `close` or `reopen` |

**Example:**
```
gitlab_update_merge_request(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  description: "## What does this MR do?\n\nFixes pipeline failures...",
  labels: "type::bug,devops::verify,backend",
  squash: true,
  remove_source_branch: true
)
```

### gitlab_get_merge_request

Get a single merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or path |
| `merge_request_iid` | integer | Yes | MR internal ID |

### gitlab_list_merge_requests

List merge requests for a project.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | No | Project ID or path |
| `state` | string | No | `opened`, `closed`, `merged`, `all` |
| `scope` | string | No | `assigned_to_me`, `created_by_me`, `all` |
| `labels` | string | No | Comma-separated labels |
| `search` | string | No | Search in title/description |
| `limit` | number | No | Max results |

### gitlab_get_mr_changes

Get the file changes (diff) for a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

### gitlab_get_mr_commits

Get commits in a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

### gitlab_create_mr_note

Add a comment to a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `body` | string | Yes | Comment content |

### gitlab_list_mr_notes

List all comments on a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

## Branch and Commit Tools

### gitlab_list_branches

List branches in a repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `search` | string | No | Filter branches by name |

### gitlab_create_commit

Create a commit with file changes (can create new branch).

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `branch` | string | Yes | Branch to commit to |
| `commit_message` | string | Yes | Commit message |
| `actions` | array | Yes | File actions (see below) |
| `start_branch` | string | No | Create branch from this ref |
| `author_email` | string | No | Author email |
| `author_name` | string | No | Author name |

**Action Types:**
| Action | Description |
|--------|-------------|
| `create` | Create a new file |
| `delete` | Delete a file |
| `move` | Move a file |
| `update` | Update file content |
| `chmod` | Change file permissions |

**Example - Create branch and commit:**
```
gitlab_create_commit(
  project_id: "gitlab-org/gitlab",
  branch: "fix-runner-disconnect",
  start_branch: "main",
  commit_message: "Fix pipeline failure on runner disconnect\n\nResolves #12345",
  actions: [
    {
      "action": "update",
      "file_path": "app/services/ci/runner_service.rb",
      "content": "# updated content..."
    }
  ]
)
```

### gitlab_get_commit

Get a single commit with details.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `sha` | string | Yes | Commit SHA |

### gitlab_list_commits

List commits in a repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `ref` | string | No | Branch/tag name |
| `path` | string | No | File path filter |
| `limit` | number | No | Max results |

### gitlab_get_file

Get contents of a file from repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `file_path` | string | Yes | Path to file |
| `ref` | string | No | Branch/tag/commit (default: main) |

## Pipeline Tools

### gitlab_get_mr_pipelines

Get pipelines for a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** List of pipelines with status, ID, SHA, ref.

### gitlab_get_pipeline

Get details of a specific pipeline.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `pipeline_id` | number | Yes | Pipeline ID |

### gitlab_list_pipeline_jobs

List jobs in a pipeline.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `pipeline_id` | number | Yes | Pipeline ID |
| `scope` | string | No | Filter: `failed`, `success`, etc. |

### gitlab_get_pipeline_failing_jobs

Get only failed jobs in a pipeline.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `pipeline_id` | number | Yes | Pipeline ID |

### gitlab_get_job_log

Get log output from a CI job.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `job_id` | number | Yes | Job ID |

### gitlab_retry_job

Retry a failed CI job.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `job_id` | number | Yes | Job ID |

## Search Tools

### gitlab_merge_request_search

Search merge requests by keyword.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |
| `state` | string | No | `opened`, `closed`, `merged`, `all` |
| `labels` | string | No | Filter by labels |
| `limit` | number | No | Max results |

**Example:**
```
gitlab_merge_request_search(
  search: "runner disconnect pipeline",
  project_id: "gitlab-org/gitlab",
  state: "opened",
  limit: 10
)
```

### gitlab_issue_search

Search issues (for linking to MRs).

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |
| `state` | string | No | `opened`, `closed`, `all` |
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

### Get Project from Git Remote

```bash
git remote get-url origin | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

### Create Branch and MR

```
1. gitlab_create_commit(
     project_id: "<project>",
     branch: "<new-branch>",
     start_branch: "main",
     commit_message: "<message>",
     actions: [...]
   )
2. gitlab_create_merge_request(
     id: "<project>",
     title: "<title>",
     source_branch: "<new-branch>",
     target_branch: "main"
   )
3. gitlab_update_merge_request(
     project_id: "<project>",
     mr_iid: <mr_iid>,
     description: "<description>",
     labels: "<labels>"
   )
```

### Monitor Pipeline Status

```
1. gitlab_get_mr_pipelines(project_id: "<project>", mr_iid: <mr_iid>)
2. Check latest pipeline status
3. If failed: gitlab_get_pipeline_failing_jobs(project_id: "<project>", pipeline_id: <id>)
4. Get logs: gitlab_get_job_log(project_id: "<project>", job_id: <job_id>)
```

### Cross-Project MR (Fork Workflow)

```
gitlab_create_merge_request(
  id: "<fork-project>",
  title: "<title>",
  source_branch: "<feature-branch>",
  target_branch: "main",
  target_project_id: <upstream-project-id>
)
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| 404 Not Found | Invalid project/MR ID | Verify ID/path exists |
| 403 Forbidden | Insufficient permissions | Check user access level |
| 400 Bad Request | Invalid parameters | Check required fields |
| 409 Conflict | Branch already exists | Use different branch name |
| 422 Unprocessable | Branch doesn't exist | Create branch first |
