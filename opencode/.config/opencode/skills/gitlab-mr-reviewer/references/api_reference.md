# GitLab MR Review API Tools Reference

Tools for reviewing merge requests and providing feedback.

## Table of Contents
- [MR Information Tools](#mr-information-tools)
- [Comment Tools](#comment-tools)
- [Pipeline Tools](#pipeline-tools)
- [Update Tools](#update-tools)
- [Common Patterns](#common-patterns)

## MR Information Tools

### gitlab_get_merge_request

Get full merge request details.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Project ID or URL-encoded path |
| `merge_request_iid` | integer | Yes | MR internal ID |

**Returns:** Title, description, state, labels, author, assignees, reviewers, source/target branches, created/updated dates.

**Example:**
```
gitlab_get_merge_request(
  id: "gitlab-org/gitlab",
  merge_request_iid: 12345
)
```

### gitlab_get_mr_changes

Get file diffs for a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** List of changed files with:
- `old_path`, `new_path` - file paths
- `diff` - unified diff content
- `new_file`, `renamed_file`, `deleted_file` - change type flags

**Example:**
```
gitlab_get_mr_changes(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345
)
```

### gitlab_get_mr_commits

Get commits in a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** List of commits with SHA, title, message, author, date.

### gitlab_list_mr_notes

List all comments on a merge request in flat structure.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** All comments including system notes, code review comments, general discussion.

**Example:**
```
gitlab_list_mr_notes(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345
)
```

### gitlab_list_mr_discussions

List discussion threads on a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** Threaded discussions with nested notes. Each discussion has:
- `id` - discussion ID (use for replies and resolution)
- `notes` - array of comments in thread
- `resolved` - whether thread is resolved
- `resolvable` - whether thread can be resolved
- `individual_note` - true if single comment, false if thread

**Example:**
```
gitlab_list_mr_discussions(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345
)
```

**Use this to:**
- See all discussion threads with resolution status
- Identify unresolved feedback
- Get discussion IDs for replies
- Track review progress

## Comment Tools

### gitlab_create_mr_note

Add a comment to a merge request or reply to an existing discussion thread.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `body` | string | Yes | Comment content (markdown) |
| `discussion_id` | string | No | Discussion ID to reply to (creates reply in thread) |

**Example - Simple comment:**
```
gitlab_create_mr_note(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "suggestion: Consider using `let` instead of `var` here for block scoping."
)
```

**Example - Reply to discussion:**
```
gitlab_create_mr_note(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "Thanks for addressing this! The changes look good.",
  discussion_id: "abc123def456"
)
```

**Example - Comment with suggested change:**
```
gitlab_create_mr_note(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "suggestion: Rename for clarity\n\n```suggestion\nconst userId = getCurrentUserId();\n```"
)
```

**Example - Blocking issue:**
```
gitlab_create_mr_note(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "issue (blocking): Missing null check\n\nThis will throw if `user` is undefined. Please add validation."
)
```

### gitlab_create_mr_discussion

Start a new discussion thread on a merge request. Optionally position on specific code lines.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `body` | string | Yes | Discussion content (markdown) |
| `position` | object | No | Code position for line-specific comments |

**Position object structure:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `base_sha` | string | Yes | Base commit SHA |
| `start_sha` | string | Yes | Start commit SHA |
| `head_sha` | string | Yes | Head commit SHA |
| `position_type` | string | Yes | "text" or "image" |
| `new_path` | string | No | Path to file (for new/modified files) |
| `old_path` | string | No | Path to file (for deleted/renamed files) |
| `new_line` | number | No | Line number in new version |
| `old_line` | number | No | Line number in old version |

**Example - General discussion:**
```
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "question: Should we add feature flag for this change?"
)
```

**Example - Code-specific discussion:**
```
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "issue: This query may cause N+1 problems\n\nConsider using `includes(:projects)`",
  position: {
    base_sha: "abc123",
    start_sha: "abc123",
    head_sha: "def456",
    position_type: "text",
    new_path: "app/models/user.rb",
    new_line: 42
  }
)
```

### gitlab_get_mr_discussion

Get a specific discussion thread with all its replies.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `discussion_id` | string | Yes | Discussion ID |

**Returns:** Discussion object with:
- `id` - discussion ID
- `notes` - array of all comments in thread
- `resolved` - resolution status
- `resolvable` - whether can be resolved

**Example:**
```
gitlab_get_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  discussion_id: "abc123def456"
)
```

### gitlab_resolve_mr_discussion

Mark a discussion thread as resolved.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `discussion_id` | string | Yes | Discussion ID to resolve |

**Example:**
```
gitlab_resolve_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  discussion_id: "abc123def456"
)
```

**Use when:**
- Author has addressed your feedback
- Issue has been fixed
- Question has been answered
- Discussion is no longer relevant

### gitlab_unresolve_mr_discussion

Reopen a resolved discussion thread.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `discussion_id` | string | Yes | Discussion ID to unresolve |

**Example:**
```
gitlab_unresolve_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  discussion_id: "abc123def456"
)
```

**Use when:**
- Resolution was premature
- New issues discovered
- Additional work needed
- Clarification required

## Pipeline Tools

### gitlab_get_mr_pipelines

Get pipelines for a merge request.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |

**Returns:** List of pipelines with:
- `id` - pipeline ID
- `status` - `success`, `failed`, `running`, `pending`, `canceled`
- `sha` - commit SHA
- `ref` - branch name
- `web_url` - link to pipeline

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
| `scope` | string | No | Filter: `created`, `pending`, `running`, `failed`, `success`, `canceled`, `skipped`, `manual` |

### gitlab_get_pipeline_failing_jobs

Get only failed jobs in a pipeline.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `pipeline_id` | number | Yes | Pipeline ID |

**Returns:** List of failed jobs with name, stage, status, failure reason.

### gitlab_get_job_log

Get log output from a CI job.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `job_id` | number | Yes | Job ID |

**Returns:** Raw job log output (can be large).

### gitlab_retry_job

Retry a failed CI job.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `job_id` | number | Yes | Job ID |

## Update Tools

### gitlab_update_merge_request

Update merge request properties.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project ID or path |
| `mr_iid` | number | Yes | MR internal ID |
| `labels` | string | No | Comma-separated labels (replaces all) |
| `assignee_ids` | array | No | User IDs to assign |
| `reviewer_ids` | array | No | User IDs for reviewers |
| `state_event` | string | No | `close` or `reopen` |

**Example - Update labels after review:**
```
gitlab_update_merge_request(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  labels: "type::bug,workflow::in review,backend,needs-discussion"
)
```

## Universal Discussion Tools

### gitlab_reply_to_discussion

Universal tool for replying to any discussion thread across GitLab resources.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `resource_type` | string | Yes | "merge_request", "issue", "epic", "commit", or "snippet" |
| `discussion_id` | string | Yes | Discussion ID to reply to |
| `body` | string | Yes | Reply content (markdown) |
| `project_id` | string | Conditional | Required for MR, issue, commit, snippet |
| `group_id` | string | Conditional | Required for epic |
| `iid` | number | Conditional | Required for MR, issue, epic |
| `sha` | string | Conditional | Required for commit |
| `snippet_id` | number | Conditional | Required for snippet |

**Example - Reply to MR discussion:**
```
gitlab_reply_to_discussion(
  resource_type: "merge_request",
  project_id: "gitlab-org/gitlab",
  iid: 12345,
  discussion_id: "abc123",
  body: "Thanks for the feedback! I've addressed this."
)
```

### gitlab_get_discussion

Universal tool for fetching discussion details from any GitLab resource.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `resource_type` | string | Yes | "merge_request", "issue", "epic", "commit", or "snippet" |
| `discussion_id` | string | Yes | Discussion ID to fetch |
| `project_id` | string | Conditional | Required for MR, issue, commit, snippet |
| `group_id` | string | Conditional | Required for epic |
| `iid` | number | Conditional | Required for MR, issue, epic |
| `sha` | string | Conditional | Required for commit |
| `snippet_id` | number | Conditional | Required for snippet |

**Returns:** Discussion with notes array containing all comments in thread.

## Common Patterns

### Complete MR Review Workflow

```
1. Get MR overview
   gitlab_get_merge_request(id: "<project>", merge_request_iid: <iid>)

2. Get code changes
   gitlab_get_mr_changes(project_id: "<project>", mr_iid: <iid>)

3. Check existing discussions
   gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)

4. Check pipeline status
   gitlab_get_mr_pipelines(project_id: "<project>", mr_iid: <iid>)

5. Start new discussion threads
   gitlab_create_mr_discussion(project_id: "<project>", mr_iid: <iid>, body: "<comment>")

6. Reply to existing discussions
   gitlab_create_mr_note(
     project_id: "<project>", 
     mr_iid: <iid>, 
     body: "<reply>",
     discussion_id: "<discussion_id>"
   )

7. Resolve addressed discussions
   gitlab_resolve_mr_discussion(
     project_id: "<project>", 
     mr_iid: <iid>, 
     discussion_id: "<discussion_id>"
   )

8. Update workflow labels if needed
   gitlab_update_merge_request(project_id: "<project>", mr_iid: <iid>, labels: "<updated labels>")
```

### Discussion Thread Workflow

```
1. List all discussions to see unresolved threads
   gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)

2. Get specific discussion details
   gitlab_get_mr_discussion(
     project_id: "<project>", 
     mr_iid: <iid>,
     discussion_id: "<discussion_id>"
   )

3. Reply to discussion
   gitlab_create_mr_note(
     project_id: "<project>", 
     mr_iid: <iid>,
     body: "<reply>",
     discussion_id: "<discussion_id>"
   )

4. Resolve when addressed
   gitlab_resolve_mr_discussion(
     project_id: "<project>", 
     mr_iid: <iid>,
     discussion_id: "<discussion_id>"
   )

5. Reopen if needed
   gitlab_unresolve_mr_discussion(
     project_id: "<project>", 
     mr_iid: <iid>,
     discussion_id: "<discussion_id>"
   )
```

### Analyze Failed Pipeline

```
1. Get pipeline list
   gitlab_get_mr_pipelines(project_id: "<project>", mr_iid: <iid>)

2. Get failed jobs from latest pipeline
   gitlab_get_pipeline_failing_jobs(project_id: "<project>", pipeline_id: <latest_id>)

3. Get logs for each failed job
   gitlab_get_job_log(project_id: "<project>", job_id: <job_id>)

4. Optionally retry if flaky
   gitlab_retry_job(project_id: "<project>", job_id: <job_id>)
```

### Check Review Status

```
1. Get MR details for labels and state
   gitlab_get_merge_request(id: "<project>", merge_request_iid: <iid>)

2. Get discussions to check for unresolved threads
   gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)

3. Count unresolved discussions
   Filter discussions where:
   - resolved: false
   - resolvable: true (exclude non-resolvable system notes)

4. Check if ready to merge
   - All resolvable discussions resolved
   - Pipeline passing
   - Required approvals obtained
```

### Code-Specific Review Comments

```
1. Get MR changes to identify file paths and line numbers
   gitlab_get_mr_changes(project_id: "<project>", mr_iid: <iid>)

2. Get commit SHAs for position
   gitlab_get_mr_commits(project_id: "<project>", mr_iid: <iid>)

3. Create discussion on specific code line
   gitlab_create_mr_discussion(
     project_id: "<project>",
     mr_iid: <iid>,
     body: "issue: This needs optimization",
     position: {
       base_sha: "<base_sha>",
       start_sha: "<start_sha>",
       head_sha: "<head_sha>",
       position_type: "text",
       new_path: "app/models/user.rb",
       new_line: 42
     }
   )
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| 404 Not Found | Invalid project/MR ID | Verify ID/path exists |
| 403 Forbidden | Insufficient permissions | Check user has at least Reporter role |
| 400 Bad Request | Invalid parameters | Check required fields |
| 422 Unprocessable | Invalid state transition | Check MR current state |

## Troubleshooting Discussion Management

### Discussion ID not found
- Ensure you're using `gitlab_list_mr_discussions` to get valid discussion IDs
- Discussion IDs are unique to each MR and cannot be reused across MRs
- Verify the discussion hasn't been deleted

### Cannot resolve discussion
- Only resolvable discussions can be resolved (check `resolvable: true`)
- System notes and individual comments (`individual_note: true`) cannot be resolved
- You must have appropriate permissions (at least Reporter role)
- The discussion must exist and not already be resolved

### Reply not appearing in thread
- Verify you're using the correct `discussion_id` from `gitlab_list_mr_discussions`
- Ensure the discussion thread still exists
- Check that the MR is still open (cannot reply to discussions on closed MRs)
- Confirm you have permission to comment on the MR

### Position-based comments failing
- Verify all three SHAs are correct: `base_sha`, `start_sha`, `head_sha`
- Ensure the file path exists in the MR changes
- Line numbers must be valid for the specified file version
- Use `new_line` for additions/modifications, `old_line` for deletions
