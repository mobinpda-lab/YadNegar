# ASF Autonomous Code Worker Runtime

This document records the operational contract for the YadNegar autonomous Code Worker.

## Lifecycle

Issue intake → exact-main lease → bounded AI patch generation → structural patch validation → `git apply --check` → bounded test/self-fix loop → issue-scoped branch commit → Draft PR → CI → Production Orchestrator.

## Safety gates

- The worker validates the leased `main` SHA before execution.
- Work is restricted to one open GitHub Issue and an issue-scoped branch.
- Secret-like files and credential material are excluded from repository context and patch targets.
- AI output is bounded by file/context/diff/time limits.
- Patch application is checked before mutation.
- Test repair is bounded to three attempts.
- Provider, lease, validation, and test failures fail closed.
- Merge/promotion remains owned by the canonical Production Orchestrator.

## Evidence

Successful execution must leave a commit, issue/PR trace, CI evidence, and exact-head promotion evidence. A worker success without a traceable PR is not considered production completion.

## Documentation law

Meaningful factory behavior changes must update operational documentation in the same change set. This file is the compact runtime contract and evidence reference for the autonomous worker implementation.
