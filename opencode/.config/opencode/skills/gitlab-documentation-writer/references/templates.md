# Documentation Templates

Standard templates for various documentation types following GitLab conventions.

## Table of Contents
- [README Template](#readme-template)
- [Changelog Template](#changelog-template)
- [Contributing Guidelines Template](#contributing-guidelines-template)
- [API Documentation Template](#api-documentation-template)
- [Architecture Documentation Template](#architecture-documentation-template)
- [Security Policy Template](#security-policy-template)
- [Code of Conduct Template](#code-of-conduct-template)

## README Template

```markdown
# Project Name

Brief description of what this project does and who it's for.

[![CI Status](https://gitlab.com/namespace/project/badges/main/pipeline.svg)](https://gitlab.com/namespace/project/-/pipelines)
[![Coverage](https://gitlab.com/namespace/project/badges/main/coverage.svg)](https://gitlab.com/namespace/project/-/graphs/main/charts)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

### Prerequisites

- Requirement 1 (e.g., Node.js 18+)
- Requirement 2 (e.g., PostgreSQL 14+)

### Quick Start

\`\`\`bash
# Clone the repository
git clone https://gitlab.com/namespace/project.git
cd project

# Install dependencies
npm install

# Configure
cp .env.example .env

# Run
npm start
\`\`\`

## Usage

### Basic Example

\`\`\`javascript
const example = require('project');

example.doSomething();
\`\`\`

### Advanced Usage

[More detailed examples]

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `3000` |
| `DATABASE_URL` | Database connection | - |

## API Reference

See [API Documentation](docs/api.md) for detailed API reference.

## Development

### Setup

\`\`\`bash
npm install
npm run dev
\`\`\`

### Testing

\`\`\`bash
npm test
npm run test:coverage
\`\`\`

### Building

\`\`\`bash
npm run build
\`\`\`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## Support

- Documentation: [docs/](docs/)
- Issues: [GitLab Issues](https://gitlab.com/namespace/project/-/issues)
- Discussions: [GitLab Discussions](https://gitlab.com/namespace/project/-/issues)
\`\`\`

## Changelog Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New features that have been added

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security fixes

## [2.0.0] - 2024-01-15

### Added
- New authentication system (#123)
- Support for multiple databases (!456)
- API rate limiting (#789)

### Changed
- Updated dependencies to latest versions
- Improved error handling across the application (!234)

### Deprecated
- Old authentication API (will be removed in 3.0.0)

### Removed
- Legacy configuration format
- Deprecated endpoints from 1.x

### Fixed
- Memory leak in background worker (#456)
- Race condition in cache invalidation (!567)

### Security
- Fixed SQL injection vulnerability (CVE-2024-1234)

## [1.5.0] - 2023-12-01

### Added
- Feature X (#100)
- Feature Y (#101)

### Fixed
- Bug in feature Z (#102)

[Unreleased]: https://gitlab.com/namespace/project/-/compare/v2.0.0...main
[2.0.0]: https://gitlab.com/namespace/project/-/compare/v1.5.0...v2.0.0
[1.5.0]: https://gitlab.com/namespace/project/-/compare/v1.0.0...v1.5.0
\`\`\`

## Contributing Guidelines Template

```markdown
# Contributing to Project Name

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

This project adheres to the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Development Setup

1. Fork the repository
2. Clone your fork:
   \`\`\`bash
   git clone https://gitlab.com/your-username/project.git
   cd project
   \`\`\`
3. Add upstream remote:
   \`\`\`bash
   git remote add upstream https://gitlab.com/namespace/project.git
   \`\`\`
4. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`
5. Create a branch:
   \`\`\`bash
   git checkout -b feature-name
   \`\`\`

## Development Workflow

### Branch Naming

- Features: `feature-<issue-number>-<short-description>`
- Bug fixes: `fix-<issue-number>-<short-description>`
- Documentation: `docs-<short-description>`

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

\`\`\`
type(scope): subject

body

footer
\`\`\`

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Example:**
\`\`\`
feat(auth): add OAuth2 support

Implement OAuth2 authentication flow with support for
Google and GitHub providers.

Closes #123
\`\`\`

### Code Style

- Follow the existing code style
- Run linter before committing: `npm run lint`
- Format code: `npm run format`

### Testing

- Write tests for new features
- Ensure all tests pass: `npm test`
- Maintain or improve code coverage
- Run tests locally before pushing

### Documentation

- Update README.md if adding features
- Add JSDoc comments for public APIs
- Update CHANGELOG.md following Keep a Changelog format

## Submitting Changes

### Creating a Merge Request

1. Push your branch to your fork
2. Create a merge request from your fork to the main repository
3. Fill out the MR template completely
4. Link related issues using `Closes #123` or `Related to #456`
5. Request review from maintainers

### MR Guidelines

- Keep changes focused and atomic
- Include tests for new functionality
- Update documentation as needed
- Ensure CI pipeline passes
- Respond to review feedback promptly

### Review Process

1. Automated checks must pass (CI, linting, tests)
2. At least one maintainer approval required
3. Address all review comments
4. Squash commits if requested
5. Maintainer will merge when ready

## Reporting Issues

### Bug Reports

Include:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, version, etc.)
- Relevant logs or screenshots

### Feature Requests

Include:
- Problem you're trying to solve
- Proposed solution
- Alternative solutions considered
- Additional context

## Questions?

- Check existing [documentation](docs/)
- Search [existing issues](https://gitlab.com/namespace/project/-/issues)
- Ask in [discussions](https://gitlab.com/namespace/project/-/issues)

## License

By contributing, you agree that your contributions will be licensed under the project's license.
\`\`\`

## API Documentation Template

```markdown
# API Documentation

REST API documentation for Project Name.

## Base URL

\`\`\`
https://api.example.com/v1
\`\`\`

## Authentication

All API requests require authentication using Bearer tokens:

\`\`\`bash
curl -H "Authorization: Bearer YOUR_TOKEN" https://api.example.com/v1/endpoint
\`\`\`

## Endpoints

### Users

#### GET /users

List all users.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Results per page (default: 20) |
| `search` | string | No | Search query |

**Response (200):**
\`\`\`json
{
  "users": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 100
  }
}
\`\`\`

#### POST /users

Create a new user.

**Request Body:**
\`\`\`json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secure_password"
}
\`\`\`

**Response (201):**
\`\`\`json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2024-01-01T00:00:00Z"
}
\`\`\`

**Errors:**
- `400 Bad Request`: Invalid input
- `409 Conflict`: User already exists

#### GET /users/:id

Get a specific user.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | integer | User ID |

**Response (200):**
\`\`\`json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2024-01-01T00:00:00Z"
}
\`\`\`

**Errors:**
- `404 Not Found`: User not found

## Error Responses

All errors follow this format:

\`\`\`json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {}
  }
}
\`\`\`

## Rate Limiting

- 1000 requests per hour per API key
- Rate limit headers included in responses:
  - `X-RateLimit-Limit`: Request limit
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset timestamp
\`\`\`

## Architecture Documentation Template

```markdown
# Architecture Documentation

System architecture and design documentation for Project Name.

## Overview

High-level description of the system architecture.

## System Architecture

\`\`\`mermaid
graph TB
    A[Client] --> B[Load Balancer]
    B --> C[Web Server 1]
    B --> D[Web Server 2]
    C --> E[Application Server]
    D --> E
    E --> F[(Database)]
    E --> G[(Cache)]
    E --> H[Message Queue]
    H --> I[Worker]
\`\`\`

## Components

### Frontend

**Technology:** React, TypeScript
**Responsibilities:**
- User interface
- Client-side routing
- State management

### API Gateway

**Technology:** Node.js, Express
**Responsibilities:**
- Request routing
- Authentication
- Rate limiting
- API versioning

### Application Server

**Technology:** Python, FastAPI
**Responsibilities:**
- Business logic
- Data processing
- External API integration

### Database

**Technology:** PostgreSQL
**Responsibilities:**
- Data persistence
- Transactional integrity

### Cache

**Technology:** Redis
**Responsibilities:**
- Session storage
- Query result caching
- Rate limit tracking

### Message Queue

**Technology:** RabbitMQ
**Responsibilities:**
- Asynchronous task processing
- Event distribution

## Data Flow

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant Database
    
    User->>Frontend: Request
    Frontend->>API: API Call
    API->>Database: Query
    Database-->>API: Data
    API-->>Frontend: Response
    Frontend-->>User: Display
\`\`\`

## Deployment

### Infrastructure

- **Cloud Provider:** AWS
- **Container Orchestration:** Kubernetes
- **CI/CD:** GitLab CI/CD

### Environments

- **Development:** dev.example.com
- **Staging:** staging.example.com
- **Production:** example.com

## Security

- TLS/SSL encryption
- OAuth2 authentication
- Role-based access control (RBAC)
- Regular security audits

## Scalability

- Horizontal scaling of web servers
- Database read replicas
- CDN for static assets
- Caching strategy

## Monitoring

- Application metrics: Prometheus
- Logging: ELK Stack
- Tracing: Jaeger
- Alerting: PagerDuty
\`\`\`

## Security Policy Template

```markdown
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x     | :white_check_mark: |
| 1.x     | :x:                |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitLab issues.**

Instead, please report them via email to security@example.com.

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

You should receive a response within 48 hours. We'll keep you updated on the progress.

## Security Update Process

1. Vulnerability reported
2. Confirmed and assessed
3. Fix developed and tested
4. Security advisory published
5. Patch released
6. Public disclosure (after fix available)
\`\`\`

## Code of Conduct Template

```markdown
# Code of Conduct

## Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone.

## Our Standards

**Positive behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Unacceptable behavior:**
- Trolling, insulting/derogatory comments
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

## Enforcement

Project maintainers are responsible for clarifying standards and taking appropriate action.

## Reporting

Report violations to conduct@example.com. All complaints will be reviewed and investigated.

## Attribution

This Code of Conduct is adapted from the Contributor Covenant, version 2.0.
\`\`\`
