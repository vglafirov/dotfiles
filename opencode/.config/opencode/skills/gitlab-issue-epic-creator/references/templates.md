# Issue and Epic Templates

Standard templates for GitLab issues and epics following GitLab conventions.

## Table of Contents
- [Bug Report Template](#bug-report-template)
- [Feature Proposal Template](#feature-proposal-template)
- [Maintenance/Tech Debt Template](#maintenancetech-debt-template)
- [Spike/Research Template](#spikeresearch-template)
- [Epic Template](#epic-template)

## Bug Report Template

```markdown
### Summary

[Brief description of the bug]

### Steps to reproduce

1. [First step]
2. [Second step]
3. [Expected action that fails]

### What is the current bug behavior?

[Describe what happens]

### What is the expected correct behavior?

[Describe what should happen]

### Relevant logs and/or screenshots

[Paste any relevant logs or attach screenshots]

### Environment

- GitLab version: [e.g., 16.5, GitLab.com]
- Installation type: [Omnibus, Helm chart, Docker, Source, GitLab.com]
- Browser (if applicable): [e.g., Chrome 119, Firefox 120]

### Possible fixes

[Optional: If you have ideas on how to fix this]

/label ~"type::bug"
```

## Feature Proposal Template

```markdown
### Problem to solve

[What problem does this solve? Who is affected? Why is it important?]

### Intended users

[Who will use this feature? Reference GitLab personas if applicable]

### User experience goal

[What is the single user experience workflow this feature enables?]

### Proposal

[How should this feature work? Be specific about the user flow]

### Further details

[Additional context, mockups, related issues]

### Permissions and Security

[Are there any security implications? Who should have access?]

### Documentation

[What documentation is needed?]

### Availability & Testing

[How should this be tested? Any specific environments?]

### What does success look like?

[How will we know this feature is successful?]

/label ~"type::feature"
```

## Maintenance/Tech Debt Template

```markdown
### Summary

[Brief description of the maintenance work]

### Current state

[Describe the current situation and why it needs to change]

### Proposed changes

[What changes are proposed?]

### Benefits

- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

### Risks

[What are the risks of making or not making this change?]

### Implementation plan

[High-level steps to implement]

### Definition of done

- [ ] [Completion criteria 1]
- [ ] [Completion criteria 2]
- [ ] Tests added/updated
- [ ] Documentation updated

/label ~"type::maintenance"
```

## Spike/Research Template

```markdown
### Objective

[What question(s) are we trying to answer?]

### Background

[Context and why this research is needed]

### Scope

[What is in scope and out of scope for this spike?]

### Research questions

1. [Question 1]
2. [Question 2]
3. [Question 3]

### Approach

[How will we investigate this?]

### Time box

[Recommended: 1-2 days for spikes]

### Expected deliverables

- [ ] Findings documented in this issue
- [ ] Recommendation for next steps
- [ ] Follow-up issues created (if applicable)

### Findings

[To be filled in after research]

### Recommendation

[To be filled in after research]

/label ~"type::spike"
```

## Epic Template

```markdown
## Summary

[Brief overview of what this epic aims to achieve]

## Goals

- [Goal 1]
- [Goal 2]
- [Goal 3]

## Non-Goals

- [What this epic explicitly does NOT cover]

## Background

[Context and motivation for this epic]

## Proposal

[High-level approach to achieving the goals]

## Design

[Link to design documents, mockups, or technical specifications]

## Success metrics

[How will we measure success?]

## Child issues

[List child issues or note that they will be created]

## Timeline

[Target dates or milestones]

## Stakeholders

[Who needs to be involved or informed?]
```

## Quick Templates (Minimal)

### Quick Bug
```markdown
**Summary**: [Brief description]

**Steps**: 
1. [Steps to reproduce]

**Expected**: [What should happen]
**Actual**: [What happens instead]

/label ~"type::bug"
```

### Quick Feature
```markdown
**Problem**: [What problem does this solve?]

**Proposal**: [How should it work?]

**Benefit**: [Why is this valuable?]

/label ~"type::feature"
```

### Quick Maintenance
```markdown
**What**: [What needs to be done]

**Why**: [Why is this needed]

**How**: [High-level approach]

/label ~"type::maintenance"
```

## Template Selection Guide

| Scenario | Template | Type Label |
|----------|----------|------------|
| Something is broken | Bug Report | `type::bug` |
| New functionality needed | Feature Proposal | `type::feature` |
| Code cleanup, refactoring | Maintenance | `type::maintenance` |
| Need to investigate first | Spike/Research | `type::spike` |
| Multiple related issues | Epic | N/A (epics don't need type) |
| Quick internal tracking | Quick Templates | Varies |

## Notes

- Templates are starting points - adapt as needed
- Always include enough context for someone unfamiliar with the problem
- Link to related issues, MRs, or documentation
- Use `/label` quick actions for labels
- For security issues, add `confidential: true` to the API call
