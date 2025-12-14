# GitLab API Tools Reference

Tools available for documentation generation and maintenance workflows.

## Table of Contents
- [Repository Tools](#repository-tools)
  - [File Operations](#file-operations)
  - [Commit Operations](#commit-operations)
  - [Branch Operations](#branch-operations)
- [Merge Request Tools](#merge-request-tools)
- [Project Tools](#project-tools)
- [Common Patterns](#common-patterns)

## Repository Tools

### File Operations

#### gitlab_get_file

Read a file from the repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `file_path` | string | Yes | Path to file in repository |
| `ref` | string | No | Branch, tag, or commit SHA (default: default branch) |

**Example:**
```
gitlab_get_file(
  project_id: "gitlab-org/gitlab",
  file_path: "README.md",
  ref: "main"
)
```

**Returns:** File content (base64 encoded for binary files).

#### gitlab_list_repository_tree

List files and directories in repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `path` | string | No | Path to directory (default: root) |
| `ref` | string | No | Branch, tag, or commit SHA |
| `recursive` | boolean | No | Recursive listing |
| `per_page` | number | No | Results per page |

**Example:**
```
gitlab_list_repository_tree(
  project_id: "gitlab-org/gitlab",
  path: "docs",
  recursive: true
)
```

**Returns:** Array of files and directories with names, paths, types.

### Commit Operations

#### gitlab_create_commit

Create a commit with multiple file actions.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `branch` | string | Yes | Branch name |
| `commit_message` | string | Yes | Commit message |
| `actions` | array | Yes | Array of file actions |
| `start_branch` | string | No | Branch to start from (for new branches) |
| `author_name` | string | No | Author name |
| `author_email` | string | No | Author email |

**Action types:**
- `create` - Create new file
- `update` - Update existing file
- `delete` - Delete file
- `move` - Move/rename file
- `chmod` - Change file permissions

**Example:**
```
gitlab_create_commit(
  project_id: "gitlab-org/gitlab",
  branch: "docs-update-readme",
  start_branch: "main",
  commit_message: "Update README with installation instructions",
  actions: [
    {
      "action": "update",
      "file_path": "README.md",
      "content": "# Project\n\nUpdated content..."
    },
    {
      "action": "create",
      "file_path": "docs/architecture.md",
      "content": "# Architecture\n\n..."
    }
  ]
)
```

#### gitlab_list_commits

List commits in repository.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `ref` | string | No | Branch, tag, or commit SHA |
| `since` | string | No | ISO 8601 date (YYYY-MM-DD) |
| `until` | string | No | ISO 8601 date |
| `path` | string | No | File path to filter commits |
| `limit` | number | No | Max results |

**Example:**
```
gitlab_list_commits(
  project_id: "gitlab-org/gitlab",
  ref: "main",
  since: "2024-01-01",
  limit: 100
)
```

**Returns:** Array of commits with SHA, message, author, date.

#### gitlab_get_commit

Get a single commit with details.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `sha` | string | Yes | Commit SHA |

**Returns:** Commit details including stats, parent commits, full message.

#### gitlab_get_commit_diff

Get the diff for a commit.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `sha` | string | Yes | Commit SHA |

**Returns:** Array of file diffs with changes.

### Branch Operations

#### gitlab_list_branches

List repository branches.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `search` | string | No | Search pattern |

**Example:**
```
gitlab_list_branches(
  project_id: "gitlab-org/gitlab",
  search: "docs-"
)
```

**Returns:** Array of branches with names, commit info, protected status.

## Merge Request Tools

### gitlab_create_merge_request

Create a new merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or path |
| `title` | string | Yes | MR title |
| `source_branch` | string | Yes | Source branch |
| `target_branch` | string | Yes | Target branch |
| `target_project_id` | integer | No | For cross-project MRs |

**Example:**
```
gitlab_create_merge_request(
  id: "gitlab-org/gitlab",
  title: "Update documentation",
  source_branch: "docs-update-readme",
  target_branch: "main"
)
```

### gitlab_update_merge_request

Update an existing merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `title` | string | No | New title |
| `description` | string | No | New description |
| `labels` | string | No | Comma-separated labels |
| `remove_source_branch` | boolean | No | Delete branch after merge |
| `squash` | boolean | No | Squash commits |

**Example:**
```
gitlab_update_merge_request(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  description: "## Summary\n\nUpdates README...",
  labels: "documentation,type::maintenance",
  remove_source_branch: true
)
```

## Project Tools

### gitlab_get_project

Get project details.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |

**Returns:** Project info including ID, path, default branch, description, languages.

### gitlab_search

Search across GitLab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scope` | string | Yes | Search scope (blobs, commits, etc.) |
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |

**Example:**
```
gitlab_search(
  scope: "blobs",
  search: "API documentation",
  project_id: "gitlab-org/gitlab"
)
```

### gitlab_blob_search

Search file content in repositories.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `search` | string | Yes | Search query |
| `project_id` | string | No | Limit to project |
| `limit` | number | No | Max results |

**Example:**
```
gitlab_blob_search(
  search: "function authenticate",
  project_id: "gitlab-org/gitlab"
)
```

## Common Patterns

### Get Project from Current Directory

```bash
# Extract project path from git remote
git remote get-url origin | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

### Check if File Exists

```
# Try to get file, handle 404 error
gitlab_get_file(
  project_id: "<project>",
  file_path: "README.md"
)
# If 404, file doesn't exist
```

### Create Documentation Branch

```
# List branches to check if name is available
gitlab_list_branches(project_id: "<project>", search: "docs-")

# Create commit on new branch
gitlab_create_commit(
  project_id: "<project>",
  branch: "docs-<unique-name>",
  start_branch: "main",
  commit_message: "Add documentation",
  actions: [...]
)
```

### Update Multiple Documentation Files

```
gitlab_create_commit(
  project_id: "<project>",
  branch: "docs-update",
  start_branch: "main",
  commit_message: "Update documentation files",
  actions: [
    {"action": "update", "file_path": "README.md", "content": "..."},
    {"action": "update", "file_path": "CHANGELOG.md", "content": "..."},
    {"action": "create", "file_path": "docs/api.md", "content": "..."}
  ]
)
```

### Get Commits for Changelog

```
# Get commits since last tag/release
gitlab_list_commits(
  project_id: "<project>",
  ref: "main",
  since: "2024-01-01",
  limit: 100
)

# Or get commits between two refs
# First get commit SHA of last release
gitlab_get_commit(project_id: "<project>", sha: "<last_release_sha>")

# Then list commits since that SHA
gitlab_list_commits(
  project_id: "<project>",
  ref: "main",
  since: "<last_release_date>"
)
```

### Analyze Project Structure

```
# Get root directory listing
gitlab_list_repository_tree(
  project_id: "<project>",
  path: "",
  recursive: false
)

# Check for specific files
gitlab_get_file(project_id: "<project>", file_path: "package.json")
gitlab_get_file(project_id: "<project>", file_path: "requirements.txt")
gitlab_get_file(project_id: "<project>", file_path: "Gemfile")
```

### Create Documentation MR

```
# 1. Create commit with documentation
gitlab_create_commit(...)

# 2. Create MR
mr = gitlab_create_merge_request(
  id: "<project>",
  title: "Add/Update documentation",
  source_branch: "docs-<name>",
  target_branch: "main"
)

# 3. Update MR with description and labels
gitlab_update_merge_request(
  project_id: "<project>",
  mr_iid: mr.iid,
  description: "## Summary\n\n...",
  labels: "documentation,type::maintenance",
  remove_source_branch: true
)
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| 404 Not Found | File/branch doesn't exist | Check path, create if needed |
| 400 Bad Request | Invalid file action | Use "update" for existing files, "create" for new |
| 409 Conflict | Branch already exists | Use different branch name or update existing |
| 403 Forbidden | Insufficient permissions | Check user access level |
