# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

## Verified Main Snapshot
Repository: `mobinpda-lab/YadNegar`
Default branch: `main`
Verified main SHA before the current documentation branch: `08a799c10a313926cb5d0a88a2601d9b4b132745`
Commit message: `ci: add initial build workflow skeleton`
Commit date: 2026-08-17

At that verified `main` snapshot, repository root contains only:
- `.github/`
- `README.md`

No Flutter foundation is merged into `main` yet:
- no `pubspec.yaml`
- no `lib/`
- no `test/`

Therefore Flutter/Clean Architecture remains a target on `main` until PR #2 is merged.

## Verified Main CI State
Existing workflows on `main`:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

Both are placeholder workflows using checkout plus `echo`. Their successful runs prove only the placeholder path, not Flutter analyze/test/build.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Status: open / mergeable / non-draft.

Active documentation package:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — canonical governance
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md` — comprehensive project reference
- `docs/YADNEGAR_OPERATION_PLAN.md` — active accelerated operational plan
- `docs/AI_CONTINUATION_STATE.md` — current state
- `docs/AI_HANDOFF_CURRENT_FA.md` — compact AI handoff
- `PROJECT_DOCUMENTATION_FA.md` — technical/product detail
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md` — compatibility pointer
- `docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md` — historical/compatibility pointer only
- updated `README.md`

PR #3 must remain Documentation/README-only.

### PR #2 — Flutter Foundation
Branch: `feat/foundation-flutter`
Current validated head: `e614343a80f9c30e7a171ef7aeb1eaebc852a8be`
Status: open / draft / mergeable.

Scope:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`

Exact-head evidence:
- placeholder `Test`: success
- `Flutter CI`: success
- `flutter pub get`: success
- `flutter analyze`: success
- `flutter test`: success

The previous RTL test failure was fixed by testing the effective text direction rather than counting `Directionality` widgets.

Important: Foundation is real and validated on the PR branch, but it is not `main` reality until merge.

### PR #1 — historical CI-path validation
State: closed / not merged.

Its purpose was only to exercise the early pull-request CI path. It is superseded by PR #3 documentation and PR #2 real Flutter validation and is no longer an active workstream.

## Active Operational Issues
### Issue #4 — Foundation integration
Tracks the existing PR #2. Do not create another Foundation implementation for the same scope.

### Issue #5 — UI / RTL
Defines RTL App Shell / Timeline contract work. Contract/design can progress in parallel; implementation must reuse the merged Foundation.

### Issue #6 — CI / Automation
Defines consolidation of real Flutter CI and removal of placeholder ambiguity. Final workflow integration depends on Foundation reaching `main`.

## Current Product Direction
YadNegar is intended to be a Persian RTL Flutter application for fast capture and Timeline-oriented review of daily information.

Planned product areas:
- notes
- events
- calls
- ideas
- daily activities
- timeline
- quick capture
- date/time handling

These are targets, not claims of completed implementation.

## Architecture Rules
- Flutter / Dart target
- Clean Architecture target
- Feature-Based Architecture target
- Persian RTL-first UI
- Domain should avoid unnecessary infrastructure dependencies
- shared Foundation must be stabilized before dependent features
- existing implementation must always be audited before extension or replacement
- no competing model/repository/storage foundation without architectural justification

## Parallel Work Model
Three lanes are active by policy:
- Lane A — Core / Domain / Foundation
- Lane B — UI / Feature
- Lane C — CI / Automation / Documentation

PR #2 and PR #3 are valid parallel workstreams because their file scopes do not overlap. Issue #5 and Issue #6 may continue on non-conflicting contract/design work while PR #2 is integrated.

## Recommended Next Real Actions
1. Verify exact-head CI for PR #3 and merge the documentation baseline when successful.
2. Keep Issue #4 attached to PR #2; do not duplicate Foundation work.
3. Mark PR #2 ready only after re-confirming exact-head Flutter CI is green, then integrate it safely.
4. After Foundation reaches `main`, execute Issue #6 as a small CI-consolidation change that replaces/removes placeholder gates instead of adding duplicate workflows.
5. In parallel, advance Issue #5 contract work and then implementation on the merged Foundation.
6. Start Timeline Domain/Core as the next independent lane once Foundation boundaries are stable.

## Validation Rule
No report may say Flutter CI is green unless the exact commit has actually run the relevant Flutter validation.

Target chain:
`flutter pub get → flutter analyze → flutter test → flutter build` as applicable.

## Documentation Rule
Documentation is updated in parallel with meaningful implementation work. Decisions, current state and handoff must not remain only in chat.

## Communication Rule
Owner reports stay compact and non-technical:
`کجا هستیم | چه انجام شد | وضعیت | مانع | قدم بعد`

## Continuation Protocol
The command `ادامه یادنگار` means:
- re-check live GitHub first
- read canonical, comprehensive, current-state and active operational-plan documents
- inspect open PRs and issues before creating new work
- compare documents with current repository reality
- identify the nearest real unfinished gap
- continue safely, using parallel independent lanes where possible
- validate exact refs and document before reporting completion

## Speed Rule
Useful verified output should be produced in hours rather than days. Speed comes from parallel independent work, small changes, reuse, automation, stale-CI cancellation and fast feedback—not from skipping Audit, tests, architecture review or evidence.
