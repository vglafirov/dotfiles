---
name: gitlab-mr-reviewer
description: Review and comment on GitLab merge requests following GitLab code review guidelines. Automatically posts comments to code lines during review. Use when reviewing MRs, providing feedback, analyzing code changes, checking pipelines, or conducting self-reviews. Supports all reviewer roles (author self-review, reviewer, maintainer) with conventional comments, suggested changes, security/performance/database review checks, and workflow label management.
---

# GitLab Merge Request Reviewer

Review merge requests following GitLab's code review guidelines, conventions, and best practices.

## ⚠️ IMPORTANT: Default Behavior

**When asked to review an MR, automatically post comments to the MR.** Do not just show a review document.

- ✅ DO: Post comments as discussions on specific code lines as you identify issues
- ✅ DO: Use `gitlab_create_mr_discussion` with position for code-specific feedback
- ✅ DO: Provide a summary of posted comments at the end
- ❌ DON'T: Just show a review document unless explicitly requested
- ❌ DON'T: Ask for permission to post comments

**Exception:** Only show a review document without posting if the user explicitly asks to "show", "draft", or "preview" the review.

## Quick Start

```
User: "Review MR !12345 in gitlab-org/gitlab"
→ Get MR details → Get changes → Analyze code → Post comments automatically to code lines

User: "Review MR !789 but just show me the summary"
→ Get MR details → Get changes → Analyze code → Show review document (no posting)

User: "Check the pipeline status on MR !789"
→ Get pipelines → Show status → If failed, analyze logs

User: "Add a comment suggesting to rename this variable"
→ Format as conventional comment → Add suggested change → Post comment

User: "Reply to the discussion about error handling"
→ Get discussions → Find relevant thread → Reply with discussion_id

User: "Show me all unresolved discussions on MR !456"
→ Get discussions → Filter by resolved: false → Show summary

User: "Resolve the discussion about null checks"
→ Get discussion ID → Mark as resolved

User: "Do a self-review checklist for my MR"
→ Run acceptance checklist → Identify issues → Suggest improvements
```

## Workflow

### Default Behavior: Automatic Comment Posting

**By default, when asked to review an MR, automatically post comments to the MR.** Do not just show a review document unless explicitly requested.

The standard review workflow:
1. Get MR information
2. Analyze changes
3. **Automatically post comments as discussions on relevant code lines**
4. Provide a summary of posted comments to the user

Only show a review document without posting if the user explicitly asks for:
- "Show me a review summary"
- "Draft a review" 
- "What would you comment on"
- Or similar phrasing indicating they want to see before posting

### 1. Determine Project Context

Get project from user or current directory:
```bash
git remote get-url origin | sed -E 's/.*gitlab\.com[:/](.*)\.git$/\1/'
```

### 2. Get MR Information

Gather MR context before reviewing:
```
gitlab_get_merge_request(id: "<project>", merge_request_iid: <iid>)
gitlab_get_mr_changes(project_id: "<project>", mr_iid: <iid>)
gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)
gitlab_get_mr_commits(project_id: "<project>", mr_iid: <iid>)
```

**Note:** Use `gitlab_list_mr_discussions` to see threaded conversations with resolution status. Use `gitlab_list_mr_notes` for a flat chronological view of all comments.

### 3. Analyze Changes

Review based on role and change type:

| Change Type | Review Focus |
|-------------|--------------|
| Backend code | Logic, security, performance, tests |
| Frontend code | UX, accessibility, browser compat |
| Database changes | Query performance, migrations, rollback |
| API changes | Backwards compatibility, documentation |
| Documentation | Accuracy, completeness, style |

### 4. Post Comments Automatically

**IMPORTANT: When reviewing an MR, automatically post comments as you identify issues. Do not wait or ask for permission.**

**⚠️ CRITICAL: To post comments ON SPECIFIC CODE LINES, you MUST use the `position` parameter!**
- Without `position`: Comment appears in MR activity feed only (general comment)
- With `position`: Comment appears on the specific code line in the diff view (code review comment)

#### Decision Matrix: When to Use Position Parameter

| Comment Type | Use Position? | Example |
|--------------|---------------|---------|
| Suggestion about specific code | **YES** | "suggestion: Use const instead of let" on line 42 |
| Issue with specific line | **YES** | "issue: Missing null check" on line 15 |
| Question about specific code | **YES** | "question: Why was this removed?" on deleted line |
| Nitpick about naming/style | **YES** | "nitpick: Variable name could be clearer" |
| Overall architecture feedback | NO | "thought: Consider splitting this into two services" |
| General praise for the MR | NO | "praise: Great test coverage overall!" |
| Missing tests (no specific line) | NO | "suggestion: Add integration tests for edge cases" |
| Documentation consistency | NO | "note: Remember to update the changelog" |

**Rule of thumb:** If your comment references a specific file and line of code, USE POSITION. If it's about the MR as a whole, DON'T use position.

For each issue, suggestion, or question identified during review:

1. **Format using [Conventional Comments](https://conventionalcomments.org/)**:
   ```
   <label>: <subject>
   
   [discussion]
   ```

2. **Post immediately using the appropriate tool**:
   - **For code-specific comments: Use `gitlab_create_mr_discussion` WITH `position` parameter** (REQUIRED for inline comments!)
   - For general MR comments: Use `gitlab_create_mr_discussion` without position
   - For praise or minor notes: Use `gitlab_create_mr_note`

**Labels:**
- `suggestion:` - Propose improvement (non-blocking by default)
- `issue:` - Problem that must be addressed
- `question:` - Need clarification
- `thought:` - Share consideration without blocking
- `nitpick:` - Minor style preference (non-blocking)
- `praise:` - Highlight good work

**Decorations** (in parentheses):
- `(blocking)` - Must resolve before merge
- `(non-blocking)` - Optional, can merge without
- `(if-minor)` - Blocking only if change is small

### 5. Comment Posting Details

#### Posting Code-Specific Comments (REQUIRED for inline review!)

**⚠️ Without the `position` parameter, your comment will NOT appear on the code line!**

When you identify an issue in a specific file and line, **you MUST post it as a code-specific discussion with position**:

```
gitlab_create_mr_discussion(
  project_id: "<project>",
  mr_iid: <iid>,
  body: "<formatted comment>",
  position: {
    base_sha: "<base_commit_sha>",
    start_sha: "<start_commit_sha>",
    head_sha: "<head_commit_sha>",
    position_type: "text",
    new_path: "path/to/file.rb",
    new_line: 42
  }
)
```

**How to get the SHAs:**
- `base_sha`: From MR details `diff_refs.base_sha`
- `start_sha`: From MR details `diff_refs.start_sha`  
- `head_sha`: From MR details `diff_refs.head_sha`

**How to get line numbers from the diff:**

The diff from `gitlab_get_mr_changes` uses unified diff format. To find the correct line number:

```
@@ -136,22 +136,56 @@ context line
```
- The `+136` means new lines start at line 136
- Count down from there for added/modified lines (lines starting with `+`)
- Use `new_line` for added lines (`+`)
- Use `old_line` for deleted lines (`-`)

**Example diff parsing:**
```diff
@@ -10,6 +10,8 @@ def initialize
   def process(user)
+    return if user.nil?  # This is new_line: 12
+    validate(user)       # This is new_line: 13
     user.update(status: 'active')
   end
```

In this example:
- The `@@ -10,6 +10,8 @@` header means new content starts at line 10
- Line `def process(user)` is line 11
- The first `+` line (`return if user.nil?`) is `new_line: 12`
- The second `+` line (`validate(user)`) is `new_line: 13`

**Example workflow:**
```
# 1. Get MR details to extract SHAs
mr = gitlab_get_merge_request(id: "gitlab-org/gitlab", merge_request_iid: 12345)
base_sha = mr['diff_refs']['base_sha']
start_sha = mr['diff_refs']['start_sha']
head_sha = mr['diff_refs']['head_sha']

# 2. Get changes to identify files and lines
changes = gitlab_get_mr_changes(project_id: "gitlab-org/gitlab", mr_iid: 12345)

# 3. Parse the diff to find line numbers
# Example: if diff shows "@@ -40,6 +40,8 @@" and you want to comment on
# the 3rd line after that header, use new_line: 42

# 4. For each issue found, post immediately with position
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "issue (blocking): Missing null check\n\nThis will throw if user is undefined.",
  position: {
    base_sha: base_sha,
    start_sha: start_sha,
    head_sha: head_sha,
    position_type: "text",
    new_path: "app/services/user_service.rb",
    new_line: 42
  }
)
```

#### Posting General MR Comments

For comments not tied to specific code lines (e.g., overall architecture, missing tests):

```
gitlab_create_mr_discussion(
  project_id: "<project>",
  mr_iid: <iid>,
  body: "<formatted comment>"
)
```

#### Posting Praise or Minor Notes

For positive feedback or informational notes:

```
gitlab_create_mr_note(
  project_id: "<project>",
  mr_iid: <iid>,
  body: "<formatted comment>"
)
```

#### Reply to Existing Discussion Thread

Only use this when responding to an existing discussion:

```
gitlab_create_mr_note(
  project_id: "<project>",
  mr_iid: <iid>,
  body: "<reply content>",
  discussion_id: "<discussion_id>"
)
```

#### Suggested Code Changes (MUST use position!)

**CRITICAL: For suggestions to appear on specific code lines, you MUST:**
1. Use `gitlab_create_mr_discussion` with the `position` parameter
2. Use GitLab's suggestion syntax with line range specifier

**GitLab Suggestion Syntax:**
````markdown
suggestion: Consider renaming for clarity

```suggestion:-0+0
const userAccountId = getUserId();
```
````

**Line Range Specifiers:**
- `suggestion:-0+0` - Replaces only the current line (most common)
- `suggestion:-1+0` - Replaces from 1 line before through current line
- `suggestion:-2+0` - Replaces from 2 lines before through current line

**Complete example with position:**
```
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "suggestion: Consider renaming for clarity\n\n```suggestion:-0+0\nconst userAccountId = getUserId();\n```",
  position: {
    base_sha: "<base_sha>",
    start_sha: "<start_sha>",
    head_sha: "<head_sha>",
    position_type: "text",
    new_path: "src/utils/user.js",
    new_line: 42
  }
)
```

**Without position = general MR comment (NOT on code line!)**

### 6. Complete Review Workflow Example

**Standard automatic review process:**

```
# Step 1: Get MR information
mr = gitlab_get_merge_request(id: "gitlab-org/gitlab", merge_request_iid: 12345)
changes = gitlab_get_mr_changes(project_id: "gitlab-org/gitlab", mr_iid: 12345)

# Extract SHAs for positioning
base_sha = mr['diff_refs']['base_sha']
start_sha = mr['diff_refs']['start_sha']
head_sha = mr['diff_refs']['head_sha']

# Step 2: Analyze each changed file
for each file in changes:
  # Review the diff
  # Identify issues, suggestions, questions
  
  # Step 3: Post comments immediately as you find them
  if issue_found:
    gitlab_create_mr_discussion(
      project_id: "gitlab-org/gitlab",
      mr_iid: 12345,
      body: "issue (blocking): [description]\n\n[details]",
      position: {
        base_sha: base_sha,
        start_sha: start_sha,
        head_sha: head_sha,
        position_type: "text",
        new_path: file['new_path'],
        new_line: problematic_line_number
      }
    )
  
  if suggestion_found:
    gitlab_create_mr_discussion(
      project_id: "gitlab-org/gitlab",
      mr_iid: 12345,
      body: "suggestion: [description]\n\n```suggestion:-0+0\n[corrected code]\n```",
      position: {
        base_sha: base_sha,
        start_sha: start_sha,
        head_sha: head_sha,
        position_type: "text",
        new_path: file['new_path'],
        new_line: line_number
      }
    )

# Step 4: Post general MR-level comments if needed
if overall_feedback:
  gitlab_create_mr_discussion(
    project_id: "gitlab-org/gitlab",
    mr_iid: 12345,
    body: "note: [overall feedback]"
  )

# Step 5: Provide summary to user
"✅ Review complete! Posted X comments:
- Y blocking issues
- Z suggestions
- W questions

View all comments on the MR: [MR URL]"
```

**Key principles:**
1. **Post as you go** - Don't accumulate comments, post each one immediately after identifying it
2. **Use code positions** - Always attach comments to specific lines when possible
3. **Be specific** - Reference exact line numbers and file paths
4. **Provide context** - Explain why something is an issue and how to fix it
5. **Summarize at the end** - Tell the user what you posted

**Real-world example with actual API calls:**

```
User: "Review MR !12345"

# Step 1: Get MR details
mr = gitlab_get_merge_request(id: "gitlab-org/gitlab", merge_request_iid: 12345)
# Extract: base_sha = "abc123", start_sha = "abc123", head_sha = "def456"

# Step 2: Get changes
changes = gitlab_get_mr_changes(project_id: "gitlab-org/gitlab", mr_iid: 12345)
# Returns diff showing changes in app/services/user_service.rb

# Step 3: Post CODE-SPECIFIC comments WITH position
# Found issue at line 42 in user_service.rb
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "issue (blocking): Missing null check\n\nThis will throw if user is undefined.",
  position: {
    base_sha: "abc123",
    start_sha: "abc123", 
    head_sha: "def456",
    position_type: "text",
    new_path: "app/services/user_service.rb",
    new_line: 42
  }
)

# Found N+1 at line 58
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "issue: N+1 query detected\n\nEach iteration queries separately. Use `includes(:projects)`.",
  position: {
    base_sha: "abc123",
    start_sha: "abc123",
    head_sha: "def456", 
    position_type: "text",
    new_path: "app/services/user_service.rb",
    new_line: 58
  }
)

# Step 4: Post GENERAL comment WITHOUT position (not about specific line)
gitlab_create_mr_discussion(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345,
  body: "suggestion (non-blocking): Add integration tests\n\nThe new service methods would benefit from integration tests covering the happy path and error cases."
)
# Note: NO position parameter = appears in MR activity feed

# Step 5: Tell user
"✅ Posted 3 comments on MR !12345:
- 2 inline code comments (on lines 42 and 58)
- 1 general MR comment (about testing)"
```

**Key distinction:**
- Comments about **specific code lines** → USE `position` parameter
- Comments about **the MR overall** → DON'T use `position` parameter

**Assistant does NOT:**
- Show a review document first
- Ask "Should I post these comments?"
- Wait for confirmation
- Post ALL comments without position (this is the bug to avoid!)

### 7. Update Workflow Labels

Suggest label changes based on review outcome:

| Outcome | Label Action |
|---------|--------------|
| Approved, no changes needed | Remove `workflow::in review`, ready for maintainer |
| Changes requested | Add `workflow::blocked` or keep `workflow::in review` |
| Questions pending | Keep in review, mention author |
| All discussions resolved | Ready to merge (if pipeline passes) |

### 8. Manage Discussion Threads

#### View Discussions

Get all discussion threads to see unresolved feedback:
```
gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)
```

Each discussion has:
- `id` - use for replies and resolution
- `notes` - array of comments in thread
- `resolved` - whether thread is resolved
- `resolvable` - whether thread can be resolved

#### Reply to Discussions

Reply to existing discussion thread:
```
gitlab_create_mr_note(
  project_id: "<project>",
  mr_iid: <iid>,
  body: "<reply>",
  discussion_id: "<discussion_id>"
)
```

Or use universal reply tool:
```
gitlab_reply_to_discussion(
  resource_type: "merge_request",
  project_id: "<project>",
  iid: <iid>,
  discussion_id: "<discussion_id>",
  body: "<reply>"
)
```

#### Resolve Discussions

Mark discussion as resolved after addressing feedback:
```
gitlab_resolve_mr_discussion(
  project_id: "<project>",
  mr_iid: <iid>,
  discussion_id: "<discussion_id>"
)
```

Reopen if more work needed:
```
gitlab_unresolve_mr_discussion(
  project_id: "<project>",
  mr_iid: <iid>,
  discussion_id: "<discussion_id>"
)
```

## Discussion Management Best Practices

### When to Start a New Discussion vs. Reply

**Start new discussion (`gitlab_create_mr_discussion`):**
- New, independent feedback point
- Different topic from existing threads
- Code-specific comment on a particular line
- General MR-level feedback

**Reply to existing discussion (`gitlab_create_mr_note` with `discussion_id`):**
- Responding to author's question
- Providing additional context to your original comment
- Acknowledging author's fix
- Continuing conversation on same topic

### When to Resolve Discussions

**Resolve when:**
- Author has implemented requested changes
- Question has been answered satisfactorily
- Issue is no longer relevant (e.g., code was removed)
- Agreement reached on approach

**Don't resolve when:**
- You're the author (let reviewer resolve)
- Changes are incomplete
- Waiting for clarification
- Discussion needs maintainer input

### Tracking Review Progress

Check unresolved discussions before approving:
```
gitlab_list_mr_discussions(project_id: "<project>", mr_iid: <iid>)
```

Filter for:
- `resolved: false` - unresolved threads
- `resolvable: true` - can be resolved (excludes system notes)

All resolvable discussions should be resolved before merge.

**Example - Finding unresolved discussions:**
```
# Get all discussions
discussions = gitlab_list_mr_discussions(
  project_id: "gitlab-org/gitlab",
  mr_iid: 12345
)

# Filter for unresolved, resolvable discussions
unresolved = [
  d for d in discussions 
  if not d.get('resolved', False) 
  and d.get('resolvable', False)
]

# Check if ready to merge
if len(unresolved) == 0:
  print("✅ All discussions resolved - ready to merge!")
else:
  print(f"⚠️  {len(unresolved)} unresolved discussion(s) remaining")
  for disc in unresolved:
    first_note = disc['notes'][0]
    print(f"  - {first_note['body'][:50]}...")
```

### Discussion Lifecycle

```
┌─────────────────────────────────────────────────────────┐
│                   Discussion Workflow                    │
└─────────────────────────────────────────────────────────┘

1. CREATE                    2. DISCUSS
   ↓                            ↓
   gitlab_create_mr_discussion  gitlab_create_mr_note
   (new thread)                 (with discussion_id)
                                ↓
                                Multiple replies possible
                                ↓
3. RESOLVE                   4. REOPEN (if needed)
   ↓                            ↓
   gitlab_resolve_mr_discussion gitlab_unresolve_mr_discussion
   (when addressed)             (if issues found)
```

**Tracking Progress:**
- Use `gitlab_list_mr_discussions` to see all threads
- Filter by `resolved: false` and `resolvable: true` for pending items
- All resolvable discussions should be resolved before merge

## Review Types

### Self-Review (Author)

Before requesting review, verify:

1. **Acceptance Checklist** - See [references/code_review_guidelines.md](references/code_review_guidelines.md)
2. **Tests pass** - All CI jobs green
3. **Description complete** - What/why/how documented
4. **Labels applied** - Type, stage, group labels set
5. **Related issues linked** - Using full URLs

**When conducting self-review:** Post comments on your own MR for issues you find. This shows reviewers you've done due diligence.

### First Review (Reviewer)

Focus on:
- Solution correctness and edge cases
- Code quality and maintainability
- Test coverage adequacy
- Security considerations
- Performance implications

**Action:** Post comments immediately as you identify issues. Don't wait until the end.

### Maintainer Review

Focus on:
- Overall architecture fit
- Cross-domain consistency
- GitLab-specific concerns (see guidelines)
- Final approval criteria

**Action:** Post architectural and high-level concerns as discussions on the MR.

## Review Focus Areas

### Code Quality
- Logic correctness, edge cases
- DRY principles, code reuse
- Clear naming and structure
- Appropriate abstractions

### Security
- Input validation
- Authorization checks
- Sensitive data handling
- SQL injection prevention
- See [secure coding guidelines](https://docs.gitlab.com/ee/development/secure_coding_guidelines.html)

### Performance
- Query efficiency (N+1 queries)
- Caching opportunities
- Background job suitability
- Memory usage

### Database
- Migration reversibility
- Query performance (EXPLAIN ANALYZE)
- Index usage
- Multi-version compatibility
- See [references/code_review_guidelines.md](references/code_review_guidelines.md#database-review)

### Tests
- Coverage of new code
- Edge case testing
- Test isolation
- Appropriate test level (unit/integration/e2e)

### Documentation
- Code comments for complex logic
- API documentation updates
- Changelog entries
- User-facing documentation

## Pipeline Analysis

Check pipeline status:
```
gitlab_get_mr_pipelines(project_id: "<project>", mr_iid: <iid>)
```

For failed pipelines:
```
gitlab_get_pipeline_failing_jobs(project_id: "<project>", pipeline_id: <id>)
gitlab_get_job_log(project_id: "<project>", job_id: <job_id>)
```

Analyze failure patterns:
- Test failures → check test output, may be flaky
- Linting failures → style issues to fix
- Security scans → potential vulnerabilities
- Build failures → compilation/dependency issues

## Comment Patterns

### Suggesting Code Changes

**IMPORTANT: Use `suggestion:-0+0` syntax (with line range) for proper rendering!**

````markdown
suggestion: Extract repeated logic into helper method

The validation logic appears in three places. Consider extracting:

```suggestion:-0+0
def validate_user_permissions(user, resource)
  return false unless user.active?
  user.can_access?(resource)
end
```
````

**This MUST be posted with `position` parameter to appear on the code line!**

### Asking Questions

```markdown
question: Is this intentional?

This changes the default behavior from `true` to `false`. Was this intentional or a side effect of the refactoring?
```

### Raising Issues

```markdown
issue (blocking): Missing authorization check

This endpoint modifies user data but doesn't verify the current user has permission. Please add an authorization check before the update.

See: https://docs.gitlab.com/ee/development/secure_coding_guidelines.html#authorization
```

### Non-blocking Suggestions

````markdown
suggestion (non-blocking): Consider using early return

This would reduce nesting:

```suggestion:-0+0
return unless user.present?
# rest of method
```
````

### Praise

```markdown
praise: Great test coverage!

The edge cases are well covered, especially the timeout scenarios.
```

### Discussion Thread Management

#### Starting a Discussion on Specific Code

**Remember: MUST include `position` parameter when calling `gitlab_create_mr_discussion`!**

````markdown
issue (blocking): Missing null check

This will throw if `user` is undefined. Please add validation before accessing properties.

```suggestion:-0+0
return unless user.present?
user.update(status: 'active')
```
````

#### Replying to a Discussion

When replying to an existing discussion thread, reference the original concern:

```markdown
Thanks for the feedback! I've added the null check and also included a test case for this scenario.

The updated code now handles both nil and undefined cases gracefully.
```

#### Resolving Your Own Comments

After the author addresses your feedback, review the changes and resolve:

```markdown
Looks good! The null check is now in place and the test coverage confirms it works correctly.
```

Then call `gitlab_resolve_mr_discussion` to mark as resolved.

#### Reopening a Discussion

If you notice an issue with the resolution:

```markdown
Actually, I noticed the null check doesn't cover the case where `user.profile` is nil. Could you add that as well?
```

Then call `gitlab_unresolve_mr_discussion` to reopen the thread.

## Available Tools

### Core MR Tools
| Tool | Purpose |
|------|---------|
| `gitlab_get_merge_request` | Get MR details (title, description, state, labels) |
| `gitlab_get_mr_changes` | Get file diffs |
| `gitlab_get_mr_commits` | Get commit list |
| `gitlab_update_merge_request` | Update labels, assignees, state |

### Discussion & Comment Tools
| Tool | Purpose |
|------|---------|
| `gitlab_list_mr_discussions` | Get threaded discussions with nested notes |
| `gitlab_get_mr_discussion` | Get specific discussion thread with all replies |
| `gitlab_list_mr_notes` | Get all comments in flat structure |
| `gitlab_create_mr_note` | Add a comment or reply to discussion |
| `gitlab_create_mr_discussion` | Start new discussion thread (optionally on specific code) |
| `gitlab_resolve_mr_discussion` | Mark discussion as resolved |
| `gitlab_unresolve_mr_discussion` | Reopen resolved discussion |

### Pipeline & CI Tools
| Tool | Purpose |
|------|---------|
| `gitlab_get_mr_pipelines` | Get pipeline status |
| `gitlab_get_pipeline` | Get pipeline details with jobs |
| `gitlab_list_pipeline_jobs` | List jobs in pipeline (with scope filter) |
| `gitlab_get_pipeline_failing_jobs` | Get only failed jobs |
| `gitlab_get_job_log` | Get job output |
| `gitlab_retry_job` | Retry failed job |

### Universal Discussion Tools
| Tool | Purpose |
|------|---------|
| `gitlab_reply_to_discussion` | Universal reply to any discussion (MR, issue, commit, etc.) |
| `gitlab_get_discussion` | Universal get discussion from any resource |

See [references/api_reference.md](references/api_reference.md) for full API details.

## Troubleshooting

### Comments appear in activity feed instead of on code lines

**Problem:** Your review comments show up in the MR activity feed but not inline on the specific code lines.

**Cause:** The `position` parameter was not included when calling `gitlab_create_mr_discussion`.

**Solution:** Always include the `position` parameter for code-specific comments:
```
gitlab_create_mr_discussion(
  project_id: "...",
  mr_iid: 123,
  body: "suggestion: ...",
  position: {                    # <-- THIS IS REQUIRED!
    base_sha: "<from diff_refs>",
    start_sha: "<from diff_refs>",
    head_sha: "<from diff_refs>",
    position_type: "text",
    new_path: "path/to/file.rb",
    new_line: 42
  }
)
```

### Suggestion syntax not rendering properly

**Problem:** The suggestion block shows as plain text instead of a clickable "Apply suggestion" button.

**Cause:** Missing the line range specifier in the suggestion syntax.

**Solution:** Use `suggestion:-0+0` format:
```markdown
```suggestion:-0+0
const userId = getUserId();
```
```

### Can't find the right line number

**Problem:** Not sure what line number to use in `new_line`.

**Solution:** Parse the diff output from `gitlab_get_mr_changes`:
1. Find the `@@ -X,Y +Z,W @@` header (called a "hunk header")
2. The `+Z` number is where new lines start
3. Count lines from there (including context lines shown without `+` or `-`)
4. Lines with `+` prefix = use `new_line`
5. Lines with `-` prefix = use `old_line`

**Example:**
```diff
@@ -10,6 +10,8 @@ def initialize
   def process(user)      # line 11 (context)
+    return if user.nil?  # line 12 (new_line: 12)
+    validate(user)       # line 13 (new_line: 13)  
     user.update(...)     # line 14 (context)
```

### Position parameter rejected by API

**Problem:** API returns error when posting with position.

**Causes & Solutions:**
1. **Wrong SHAs:** Get fresh SHAs from `gitlab_get_merge_request` response's `diff_refs` object
2. **File path mismatch:** Use exact path from `gitlab_get_mr_changes` (case-sensitive)
3. **Line number out of range:** Ensure line exists in the current diff
4. **Commenting on context line:** Only `+` lines work with `new_line`, `-` lines need `old_line`

## References

- [references/api_reference.md](references/api_reference.md) - GitLab API tools for reviews
- [references/code_review_guidelines.md](references/code_review_guidelines.md) - GitLab review standards and checklists
- [references/comment_templates.md](references/comment_templates.md) - Conventional comment examples
- [references/labels.md](references/labels.md) - Review workflow labels
