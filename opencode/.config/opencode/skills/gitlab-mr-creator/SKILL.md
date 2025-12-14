---
name: gitlab-mr-creator
description: Create well-structured GitLab merge requests with proper labels, descriptions, and GitLab conventions. Use when creating MRs for bug fixes, features, documentation, database migrations, or refactoring. Supports branch creation via commits, cross-project MRs for forks, pipeline monitoring, and applying appropriate labels based on content. Follows GitLab development workflows and contribution guidelines.
---

# GitLab Merge Request Creator

Create merge requests following GitLab's development processes, commit message guidelines, and labeling conventions.

## Quick Start

```
User: "Create an MR for fixing the pipeline failure bug"
→ Ask for related issue → Create branch with commits → Create MR → Add description/labels

User: "Create a feature MR from my fork to the upstream project"
→ Get fork and upstream project IDs → Create cross-project MR → Add description/labels

User: "Check the pipeline status on MR !12345"
→ Get MR pipelines → Show status → If failed, get failing jobs and logs
```

## Workflow

### 1. Determine Project Context

Get project from current directory unless user specifies another:
```bash
git remote get-url origin | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

For forks, also get the upstream project:
```bash
git remote get-url upstream | sed 's/.*gitlab.com[:/]\(.*\)\.git/\1/'
```

### 2. Ask for Related Issues

Before creating MR, ask user for related issues:
- "What issue does this MR address? (e.g., #12345 or full URL)"
- If user provides issue number, include in description and commit message

### 3. Determine MR Type

Based on user request, identify type:

| User Intent | Type Label | Template |
|-------------|------------|----------|
| Bug fix, defect resolution | `type::bug` | Bug Fix |
| New functionality | `type::feature` | Feature |
| Documentation updates | `type::maintenance` | Documentation |
| Database changes | `type::maintenance` | Database Migration |
| Refactoring, cleanup | `type::maintenance` | Refactoring |
| Security fix | `type::bug` + `security` | Security Fix |

### 4. Create Branch and Commits (if needed)

If user doesn't have a branch yet:
```
gitlab_create_commit(
  project_id: "<project>",
  branch: "<new-branch-name>",
  start_branch: "main",
  commit_message: "<message following guidelines>",
  actions: [
    {"action": "update", "file_path": "<path>", "content": "<content>"}
  ]
)
```

**Branch naming conventions:**
- Bug fixes: `fix-<issue-number>-<short-description>`
- Features: `feature-<issue-number>-<short-description>`
- Docs: `docs-<short-description>`

**Commit message requirements:**
- Subject: capitalized, ≤72 chars, no period, ≥3 words
- Body: explain what/why, wrap at 72 chars, use full issue URLs
- No emojis

### 5. Create Merge Request

```
gitlab_create_merge_request(
  id: "<project_path>",
  title: "<title>",
  source_branch: "<source>",
  target_branch: "main"
)
```

For cross-project MRs (forks):
```
gitlab_create_merge_request(
  id: "<fork_project_path>",
  title: "<title>",
  source_branch: "<source>",
  target_branch: "main",
  target_project_id: <upstream_project_id>
)
```

### 6. Update MR with Description and Labels

After creation, update with full details:
```
gitlab_update_merge_request(
  project_id: "<project>",
  mr_iid: <mr_iid>,
  description: "<generated from template>",
  labels: "<comma-separated labels>",
  squash: true,
  remove_source_branch: true
)
```

### 7. Apply Labels

**Required:**
- Type label (`type::bug`, `type::feature`, `type::maintenance`)

**Recommended (infer from content):**
- DevOps stage (`devops::*`)
- Group (`group::*`)
- Specialization (`frontend`, `backend`, `database`, `documentation`)

**For database changes:**
- Add `database,database::review pending`

See [references/labels.md](references/labels.md) for complete reference.

## MR Type Workflows

### Bug Fix MR

1. Gather: issue link, root cause, solution approach
2. Generate description from bug fix template
3. Apply labels: `type::bug`, stage, group, specialization
4. For security bugs: add `security` label

### Feature MR

1. Gather: issue link, problem, solution, validation steps
2. Generate description from feature template
3. Apply labels: `type::feature`, stage, group, specialization
4. Include feature flag info if applicable

### Documentation MR

1. Gather: what's being documented, related MR/issue
2. Generate description from documentation template
3. Apply labels: `type::maintenance`, `documentation`, `technical writing`

### Database Migration MR

1. Gather: migration type, tables affected, rollback plan
2. Generate description from database template
3. Apply labels: `type::maintenance`, `database`, `database::review pending`
4. Include query analysis

### Refactoring MR

1. Gather: what's being refactored, benefits, risk assessment
2. Generate description from refactoring template
3. Apply labels: `type::maintenance`, stage, group

## Pipeline Monitoring

Check MR pipeline status:
```
gitlab_get_mr_pipelines(project_id: "<project>", mr_iid: <mr_iid>)
```

If pipeline failed:
```
gitlab_get_pipeline_failing_jobs(project_id: "<project>", pipeline_id: <pipeline_id>)
```

Get job logs:
```
gitlab_get_job_log(project_id: "<project>", job_id: <job_id>)
```

Retry failed job:
```
gitlab_retry_job(project_id: "<project>", job_id: <job_id>)
```

## Label Auto-Selection Guide

Based on content keywords, suggest labels:

| Keywords | Suggested Labels |
|----------|------------------|
| pipeline, CI, job, runner | `devops::verify`, `group::pipeline execution` |
| merge request, code review | `devops::create`, `group::code review` |
| security, vulnerability | `security`, potentially confidential |
| performance, slow, timeout | `bug::performance` if bug fix |
| database, migration, schema | `database`, `database::review pending` |
| frontend, UI, CSS, JavaScript | `frontend` |
| API, endpoint, REST, GraphQL | `backend` |
| docs, documentation | `documentation`, `technical writing` |

## Cross-Project MR Workflow (Forks)

1. Get upstream project ID:
   ```
   gitlab_get_project(project_id: "<upstream_path>")
   ```

2. Create MR from fork to upstream:
   ```
   gitlab_create_merge_request(
     id: "<fork_path>",
     title: "<title>",
     source_branch: "<branch>",
     target_branch: "main",
     target_project_id: <upstream_id>
   )
   ```

3. Update with description/labels as normal

## Available Tools

| Tool | Purpose |
|------|---------|
| `gitlab_create_merge_request` | Create new MR |
| `gitlab_update_merge_request` | Add description, labels, reviewers |
| `gitlab_get_merge_request` | Get MR details |
| `gitlab_create_commit` | Create branch and commits |
| `gitlab_get_mr_pipelines` | Check pipeline status |
| `gitlab_get_pipeline_failing_jobs` | Get failed jobs |
| `gitlab_get_job_log` | Get CI job output |
| `gitlab_retry_job` | Retry failed job |
| `gitlab_list_branches` | List existing branches |
| `gitlab_get_project` | Get project details |

See [references/api_reference.md](references/api_reference.md) for full API details.

## References

- [references/labels.md](references/labels.md) - Complete label reference for MRs
- [references/templates.md](references/templates.md) - MR description templates
- [references/api_reference.md](references/api_reference.md) - GitLab API tools
- [references/workflow.md](references/workflow.md) - GitLab MR workflow guidelines
