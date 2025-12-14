# Comment Templates for MR Reviews

Conventional comment formats and GitLab suggested changes syntax.

## Table of Contents
- [Conventional Comments Format](#conventional-comments-format)
- [Comment Labels](#comment-labels)
- [Decorations](#decorations)
- [Suggested Changes Syntax](#suggested-changes-syntax)
- [Templates by Category](#templates-by-category)
- [Quick Reference](#quick-reference)

## Conventional Comments Format

Structure:
```
<label> [decorations]: <subject>

[discussion]
```

Example:
```
suggestion (non-blocking): Consider using a guard clause

This would reduce nesting and improve readability.
```

## Comment Labels

### suggestion

Proposes an improvement. Non-blocking by default.

```
suggestion: Extract this into a helper method

This logic appears in three places. A shared helper would improve maintainability.
```

### issue

Identifies a problem that should be addressed. Blocking by default.

```
issue: This query may cause N+1 problems

Each iteration calls `user.projects` separately. Consider using `includes(:projects)`.
```

### question

Requests clarification or understanding.

```
question: Is this behavior intentional?

The default changed from `true` to `false`. Was this deliberate?
```

### thought

Shares an idea without requesting action. Non-blocking.

```
thought: We might want to add caching here later

Not necessary now, but if this endpoint gets heavy traffic, caching would help.
```

### nitpick

Minor stylistic preference. Non-blocking.

```
nitpick: Prefer single quotes for strings without interpolation

Ruby convention is to use single quotes when not interpolating.
```

### praise

Highlights something positive.

```
praise: Excellent error handling!

The fallback logic and user-friendly messages are well thought out.
```

### note

Provides additional context or information.

```
note: This is required for backwards compatibility

We need to support the old format until v16.0 deprecation completes.
```

## Decorations

Add in parentheses after the label:

### (blocking)

Must be resolved before merge. Use sparingly.

```
issue (blocking): Missing authorization check

This endpoint modifies data without verifying user permissions.
```

### (non-blocking)

Optional improvement. Can merge without addressing.

```
suggestion (non-blocking): Consider renaming for clarity

`data` is generic. `userPreferences` would be more descriptive.
```

### (if-minor)

Blocking only if the change is small.

```
suggestion (if-minor): Add a code comment explaining this regex

If this is a small MR, please add context. Otherwise, fine to skip.
```

## Suggested Changes Syntax

GitLab supports inline code suggestions that authors can apply directly.

**⚠️ CRITICAL: Suggestions MUST be posted with `position` parameter to appear on code lines!**

Without `position`, suggestions appear as general MR comments, NOT on the specific code line.

### Line Range Syntax

The suggestion block uses the format `suggestion:-N+M` where:
- `-N` = number of lines BEFORE the current line to include
- `+M` = number of lines AFTER the current line to include (usually 0)

Common patterns:
- `suggestion:-0+0` - Replace only the current line (most common)
- `suggestion:-1+0` - Replace current line and 1 line before
- `suggestion:-2+0` - Replace current line and 2 lines before

### Single-line suggestion

````markdown
suggestion: Use const instead of let

```suggestion:-0+0
const userId = params[:user_id];
```
````

**API call example:**
```
gitlab_create_mr_discussion(
  project_id: "myproject",
  mr_iid: 123,
  body: "suggestion: Use const instead of let\n\n```suggestion:-0+0\nconst userId = params[:user_id];\n```",
  position: {
    base_sha: "<base_sha>",
    start_sha: "<start_sha>",
    head_sha: "<head_sha>",
    position_type: "text",
    new_path: "src/utils.js",
    new_line: 15
  }
)
```

### Multi-line suggestion

When replacing multiple lines, use the line range specifier:

````markdown
suggestion: Extract validation logic

```suggestion:-2+0
def valid_user?(user)
  return false unless user.present?
  return false unless user.active?
  user.verified?
end
```
````

### Suggestion with explanation

````markdown
suggestion: Simplify with early return

This reduces nesting and makes the happy path clearer:

```suggestion:-0+0
return unless user.present?
return unless user.can_access?(resource)

process_request(user, resource)
```
````

### Multiple suggestions in one comment

````markdown
suggestion: Two improvements here

First, use `let` for reassigned variables:
```suggestion:-0+0
let counter = 0;
```

Second, use `const` for constants:
```suggestion:-2+0
const MAX_RETRIES = 3;
```
````

## Templates by Category

### Review Summary

After completing a review, provide a summary comment:

```markdown
Thank you for the MR! I've reviewed the changes and have the following feedback:

**Required changes:**
- [List blocking issues that must be addressed]

**Suggestions:**
- [List non-blocking suggestions for improvement]

**Questions:**
- [List clarification questions]

Please address the required changes, and feel free to discuss any of the suggestions or questions.
```

Or for an approved review:

```markdown
Thank you for the MR! The changes look good overall.

**Approved with minor suggestions:**
- [List any non-blocking suggestions]

The code is ready to merge once the pipeline passes. Nice work!
```

### Code Quality

#### Naming
````
suggestion: More descriptive name

`d` doesn't convey meaning. Consider:

```suggestion:-0+0
const daysSinceLastLogin = calculateDaysSince(user.lastLoginAt);
```
````

#### DRY Violation
````
suggestion: Extract repeated logic

This pattern appears in 3 places. Consider a shared method:

```suggestion:-0+0
def format_timestamp(time)
  time.strftime('%Y-%m-%d %H:%M:%S')
end
```
````

#### Complexity
````
suggestion: Simplify conditional logic

This nested condition is hard to follow. Consider:

```suggestion:-0+0
return early_exit_value if should_exit_early?

# main logic here
```
````

### Security

#### Missing Authorization
````
issue (blocking): Missing authorization check

This endpoint modifies user data without verifying permissions.

See: https://docs.gitlab.com/ee/development/secure_coding_guidelines.html#authorization

```suggestion:-0+0
authorize! :update, @resource
```
````

#### Input Validation
````
issue (blocking): Unvalidated user input

`params[:url]` is used directly without validation. This could enable SSRF.

```suggestion:-0+0
validated_url = validate_url(params[:url])
raise ArgumentError, 'Invalid URL' unless validated_url
```
````

#### Sensitive Data
````
issue (blocking): Sensitive data in logs

This logs the full request including auth tokens. Please redact:

```suggestion:-0+0
Rails.logger.info("Request received", request_id: request.id)
```
````

### Performance

#### N+1 Query
````
issue: N+1 query detected

Each `project.members` call triggers a separate query. Use eager loading:

```suggestion:-0+0
@projects = Project.includes(:members).where(user: current_user)
```
````

#### Missing Index
````
suggestion: Consider adding an index

This query filters on `status` frequently. An index would help:

```ruby
add_index :jobs, :status
```
````

#### Inefficient Loop
````
suggestion: Use batch processing

Processing 10k+ records in memory may cause issues. Consider:

```suggestion:-0+0
User.find_each(batch_size: 1000) do |user|
  process(user)
end
```
````

### Database

#### Migration Reversibility
````
issue (blocking): Migration not reversible

This migration lacks a `down` method. All migrations must be reversible:

```suggestion:-0+0
def down
  remove_column :users, :preferences
end
```
````

#### Large Table Migration
```
issue: Use background migration for large tables

The `users` table has millions of rows. Use batched background migration:

See: https://docs.gitlab.com/ee/development/database/batched_background_migrations.html
```

#### Missing Query Analysis
```
question: Can you add EXPLAIN ANALYZE output?

For database changes, please include query analysis showing performance impact.
```

### Testing

#### Missing Test Coverage
````
suggestion: Add test for edge case

The nil case isn't covered. Consider:

```ruby
it 'handles nil input gracefully' do
  expect { subject.process(nil) }.not_to raise_error
end
```
````

#### Flaky Test Pattern
````
issue: Potential flaky test

Using `sleep` in tests is unreliable. Consider:

```suggestion:-0+0
expect(page).to have_content('Success', wait: 5)
```
````

### Documentation

#### Missing Code Comment
````
suggestion (non-blocking): Add comment explaining why

This logic isn't obvious. A comment would help future maintainers:

```suggestion:-0+0
# Skip validation for legacy records created before v14.0
# See: https://gitlab.com/gitlab-org/gitlab/-/issues/12345
next if record.legacy?
```
````

#### Changelog Entry
```
note: Changelog entry may be needed

This is a user-facing change. Consider adding a changelog entry if not already present.
```

## Discussion Thread Examples

### Starting a Discussion Thread

Use `gitlab_create_mr_discussion` **with `position` parameter** to start a thread on specific code:

````markdown
issue (blocking): Missing error handling

This API call can fail, but there's no error handling. Consider:

```suggestion:-0+0
try {
  const result = await api.fetchUser(userId);
  return result;
} catch (error) {
  logger.error('Failed to fetch user', { userId, error });
  throw new UserFetchError('Unable to retrieve user data');
}
```
````

**API call (note the position parameter!):**
```
gitlab_create_mr_discussion(
  project_id: "myproject",
  mr_iid: 123,
  body: "issue (blocking): Missing error handling\n\n...",
  position: {
    base_sha: "<base_sha>",
    start_sha: "<start_sha>",
    head_sha: "<head_sha>",
    position_type: "text",
    new_path: "src/api/users.js",
    new_line: 42
  }
)
```

### Replying to a Discussion

Use `gitlab_create_mr_note` with `discussion_id`:

```markdown
Thanks for catching this! I've added error handling and also included a retry mechanism for transient failures.

The updated code now:
- Catches and logs errors
- Retries up to 3 times with exponential backoff
- Throws a custom error with context
```

### Resolving a Discussion

After author addresses feedback, add a final comment and resolve:

```markdown
Perfect! The error handling looks good now. The retry logic is a nice addition.
```

Then call `gitlab_resolve_mr_discussion`.

### Reopening a Discussion

If you notice an issue after resolution:

```markdown
Actually, I just realized the retry logic doesn't handle rate limiting errors. Could you add a check for 429 status codes?
```

Then call `gitlab_unresolve_mr_discussion`.

## Quick Reference

| Situation | Template Start | Tool | Use Position? |
|-----------|----------------|------|---------------|
| Code suggestion | `suggestion:` | `gitlab_create_mr_discussion` | **YES** - on code line |
| Code issue | `issue (blocking):` | `gitlab_create_mr_discussion` | **YES** - on code line |
| Code question | `question:` | `gitlab_create_mr_discussion` | **YES** - on code line |
| Code nitpick | `nitpick:` | `gitlab_create_mr_discussion` | **YES** - on code line |
| General suggestion | `suggestion (non-blocking):` | `gitlab_create_mr_discussion` | NO - general comment |
| Overall praise | `praise:` | `gitlab_create_mr_note` | NO - general comment |
| FYI note | `note:` | `gitlab_create_mr_note` | NO - general comment |
| Reply to thread | (any format) | `gitlab_create_mr_note` + `discussion_id` | NO - uses existing thread |
| Security on code | `issue (blocking): [Security]` | `gitlab_create_mr_discussion` | **YES** - on code line |
| General security | `issue (blocking): [Security]` | `gitlab_create_mr_discussion` | NO - general comment |

**Key Rule:** If your comment is about a SPECIFIC LINE OF CODE, you MUST use the `position` parameter to attach it to that line. Otherwise the comment appears only in the MR activity feed.

### Suggested Change Block

**Use line range specifier for proper rendering:**

````
```suggestion:-0+0
<corrected code here>
```
````

Line range options:
- `-0+0` = replace current line only
- `-1+0` = replace current + 1 line before
- `-2+0` = replace current + 2 lines before

### Discussion Management

| Action | Tool |
|--------|------|
| Start new discussion | `gitlab_create_mr_discussion` |
| Reply to discussion | `gitlab_create_mr_note` with `discussion_id` |
| Get discussion details | `gitlab_get_mr_discussion` |
| List all discussions | `gitlab_list_mr_discussions` |
| Resolve discussion | `gitlab_resolve_mr_discussion` |
| Reopen discussion | `gitlab_unresolve_mr_discussion` |
