# Project Governance

## Overview

The eBPF for Windows Sample Program project aims to provide clear, educational examples of eBPF programming on Windows. This document outlines the governance structure, roles, and processes for contributing to and maintaining this project.

## Roles and Personnel

The project uses the following roles, listed in order of increasing permission:

### Contributor

The ability to read, clone, and contribute issues or pull requests is open to the public.

**Personnel:** Anyone

**Minimum Requirements:** None

**Responsibilities:** None required, but contributors are encouraged to:
- Report bugs and suggest improvements
- Submit pull requests for new sample programs or fixes
- Participate in community discussions

### Collaborator

A collaborator is a contributor who can have issues and pull request review requests assigned to them in GitHub.

**Personnel:** TBD based on project growth

**Minimum Requirements:**
- Has submitted at least one merged pull request
- Has demonstrated understanding of eBPF concepts and Windows development
- Is approved by existing maintainers

**Responsibilities:**
- Review pull requests from other contributors
- Help triage and respond to issues
- Contribute new sample programs or improvements

### Maintainer

A maintainer can merge pull requests and has write access to the repository.

**Personnel:** @Alan-Jowett (initial maintainer)

**Minimum Requirements:**
- Has acted as a collaborator for at least 1 month
- Has submitted multiple pull requests across different areas
- Has demonstrated good judgment in code reviews
- Understands the educational goals of the project
- Is approved by existing maintainers

**Responsibilities:**
- Review and merge pull requests
- Manage project milestones and releases
- Maintain coding standards and project quality
- Guide project direction and priorities
- Mentor new contributors

### Project Admin

An admin has full access to all GitHub settings and can manage roles and permissions.

**Personnel:** @Alan-Jowett (initial admin)

**Minimum Requirements:**
- Has acted as a maintainer
- Understands GitHub administration
- Is committed to the long-term success of the project

**Responsibilities:**
- Manage GitHub repository settings
- Assign and revoke roles
- Resolve disputes among maintainers
- Ensure project governance is followed

## Project Goals and Scope

### Primary Goals

1. **Educational Value**: Provide clear, well-documented examples of eBPF programming on Windows
2. **Quality**: Maintain high standards for code quality, documentation, and testing
3. **Accessibility**: Make eBPF development approachable for developers new to the technology
4. **Compatibility**: Ensure samples work with current eBPF for Windows releases

### Sample Program Criteria

Sample programs included in this repository should:

- Demonstrate specific eBPF concepts or use cases
- Include comprehensive documentation and comments
- Follow the project's coding standards
- Include test cases or validation steps
- Be educational rather than production-focused
- Work with the current eBPF for Windows release

### Out of Scope

This repository is not intended for:
- Production-ready eBPF applications
- Complex multi-component solutions
- Platform-specific optimizations that obscure educational value
- Experimental or unstable eBPF features

## Issue Management

### Issue Types

- **Bug**: Problems with existing sample programs
- **Enhancement**: Improvements to existing samples
- **New Sample**: Proposals for new sample programs
- **Documentation**: Updates to documentation or comments
- **Question**: General questions about eBPF or the samples

### Issue Triage

Issues are triaged based on:

1. **Impact**: How many users are affected
2. **Educational Value**: How much the issue affects learning
3. **Complexity**: How difficult the issue is to resolve
4. **Alignment**: How well the issue aligns with project goals

### Priority Labels

- **P1 - Critical**: Blocking issues that prevent samples from working
- **P2 - High**: Important improvements or widely-requested features
- **P3 - Medium**: Nice-to-have improvements
- **P4 - Low**: Minor issues or far-future enhancements

## Pull Request Process

### Review Requirements

All pull requests require:
- At least one maintainer approval
- Passing automated checks (if configured)
- Resolution of all review comments
- Up-to-date branch with main

### Review Criteria

Reviewers should check for:
- **Correctness**: Code works as intended
- **Educational Value**: Code teaches eBPF concepts effectively
- **Documentation**: Adequate comments and documentation
- **Code Style**: Follows project conventions
- **Testing**: Includes appropriate tests or validation
- **Security**: No security vulnerabilities or bad practices

### Merge Process

1. Maintainers review pull requests in order of submission
2. Priority is given to bug fixes over new features
3. Educational improvements take precedence over performance optimizations
4. Maintainers may request changes or additional documentation
5. Once approved, maintainers merge using squash and merge

## Release Process

### Versioning

The project uses semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes to sample structure or major overhauls
- **MINOR**: New sample programs or significant enhancements
- **PATCH**: Bug fixes and minor improvements

### Release Schedule

- Releases are made as needed, typically when significant new content is added
- Bug fix releases may be made more frequently
- Release notes document all changes and new samples

### Release Checklist

Before each release:
- [ ] All samples build successfully
- [ ] Documentation is up to date
- [ ] CHANGELOG.md is updated
- [ ] Version numbers are updated
- [ ] Compatibility with current eBPF for Windows is verified

## Code of Conduct Enforcement

The project follows the Microsoft Open Source Code of Conduct. Violations should be reported to [opencode@microsoft.com](mailto:opencode@microsoft.com).

Maintainers may:
- Issue warnings for minor violations
- Temporarily restrict access for repeated violations
- Permanently ban users for severe violations

## Decision Making

### Consensus Building

For significant decisions:
1. Create an issue describing the proposal
2. Allow time for community input
3. Seek consensus among maintainers
4. Document the decision and rationale

### Voting

If consensus cannot be reached:
- Each maintainer gets one vote
- Decisions require a simple majority
- The project admin can break ties

### Appeal Process

Contributors may appeal decisions by:
1. Creating an issue explaining their concerns
2. Requesting reconsideration from maintainers
3. Escalating to the project admin if needed

## Communication

### Channels

- **GitHub Issues**: Bug reports, feature requests, questions
- **GitHub Discussions**: General discussion and announcements
- **Pull Request Comments**: Code review and technical discussion

### Community Guidelines

- Be respectful and professional
- Focus on technical merit and educational value
- Provide constructive feedback
- Help newcomers learn and contribute

## Governance Changes

This governance document may be updated as the project evolves:

1. Proposed changes should be discussed in a GitHub issue
2. Changes require consensus among maintainers
3. Significant changes may require community input
4. All changes should be documented with rationale

## Contact

For questions about governance or to report issues:
- Create a GitHub issue
- Contact maintainers directly
- Email [opencode@microsoft.com](mailto:opencode@microsoft.com) for code of conduct issues

## Acknowledgments

This governance model is adapted from the [eBPF for Windows project](https://github.com/microsoft/ebpf-for-windows) and other successful open source projects.