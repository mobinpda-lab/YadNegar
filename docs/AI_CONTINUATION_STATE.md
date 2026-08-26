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

## Verified Repository Shape
At the verified main snapshot, the repository root contains only:
- `.github/`
- `README.md`

No Flutter foundation is merged into `main` yet:
- no `pubspec.yaml`
- no `lib/`
- no `test/`

Therefore Flutter/Clean Architecture remains a target on `main`, not a merged implementation state.

## Verified Main CI State
Existing workflows on `main`:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

Both are placeholder workflows using checkout plus `echo`. Their successful runs prove only the placeholder path, not Flutter analyze/test/build.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Status: open / mergeable / non-draft.

Current package includes:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — canonical governance
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md` — comprehensive project reference
- `docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md` — accelerated parallel execution plan
- `docs/AI_CONTINUATION_STATE.md` — current state
- `docs/AI_HANDOFF_CURRENT_FA.md` — compact AI handoff
- `PROJECT_DOCUMENTATION_FA.md` — technical/product detail
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md` — compatibility pointer
- updated `README.md`

The documentation PR is intentionally documentation-only and should remain isolated from application/workflow behavior changes.

### PR #2 — Flutter Foundation
Branch: `feat/foundation-flutter`
Current head: `e614343a80f9c30e7a171ef7aeb1eaebc852a8be`
Status: open / draft / mergeable.

Scope:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`

Verified CI for the exact current head:
- placeholder `Test` workflow: success
- `Flutter CI`: success
- `flutter pub get`: success
- `flutter analyze`: success
- `flutter test`: success

The previous RTL widget test failure was corrected by asserting the effective text direction instead of assuming exactly one `Directionality` widget exists.

Important: this Foundation is real and validated on the PR branch, but it is **not yet merged into `main`**.

### PR #1 — PR/CI path validation
Branch: `docs/parallel-development-status`
Status: open / draft / mergeable.

Purpose was only to exercise the pull-request CI path using a documentation-only change. It is now a likely superseded validation PR and should be evaluated for closure without merge after the canonical documentation and real Flutter CI path are established.

## Active Operational Issues
### Issue #4 — Foundation
`foundation: initialize minimal Flutter project`

Implementation is already active in PR #2. Issue #4 must track PR #2 rather than starting another Foundation implementation.

### Issue #5 — UI / RTL
`ui: define RTL app shell and timeline contract`

Contract/design can progress independently. Implementation should reuse the Foundation from PR #2/main after merge and must not create a competing App Shell foundation.

### Issue #6 — CI / Automation
`ci: replace placeholders with Flutter fast and full gates`

CI design can progress in parallel. Final consolidation should happen after Foundation is on `main`, so the placeholder workflows can be replaced by real Flutter validation without duplicate gates.

## Current Product Direction
YadNegar is intended to be a Persian RTL Flutter application for fast capture and Timeline-oriented review of daily information.

Planned product areas include:
- notes
- events
- calls
- ideas
- daily activities
- timeline
- quick capture
- date/time handling

These are product targets, not claims of completed implementation.

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
1. Validate and merge PR #3 documentation baseline when its exact-head CI is successful.
2. Link Issue #4 to PR #2 and do not create another Foundation branch.
3. Mark PR #2 ready only after confirming exact-head Flutter CI remains green, then merge it safely.
4. Re-evaluate PR #1 as superseded validation work and close it if no unique value remains.
5. After Foundation reaches `main`, execute Issue #6 as a small CI-consolidation PR that removes/replaces placeholder gates rather than adding more parallel workflows.
6. In parallel, advance Issue #5 contract work and then implement it on top of the merged Foundation.
7. Start Timeline Domain/Core as the next independent lane once Foundation boundaries are stable.

## Validation Rule
No report may say Flutter CI is green unless the exact commit has actually run the relevant Flutter validation.

Target chain:
`flutter pub get → flutter analyze → flutter test → flutter build` as applicable.

## Documentation Rule
Documentation is updated in parallel with meaningful implementation work. Decisions, current state and handoff must not remain only in chat.

## Communication Rule
Owner reports should stay compact and non-technical:
`کجا هستیم | چه انجام شد | وضعیت | مانع | قدم بعد`

## Continuation Protocol
The command `ادامه یادنگار` means:
- re-check live GitHub first
- read canonical, comprehensive, current-state and operational-plan documents
- inspect open PRs and issues before creating new work
- compare documents with current repository reality
- identify the nearest real unfinished gap
- continue safely, using parallel independent lanes where possible
- validate exact refs and document before reporting completion

## Speed Rule
Useful verified output should be produced in hours rather than days. Speed must come from parallel independent work, small changes, reuse, automation, stale-CI cancellation and fast feedback—not from skipping Audit, tests, architecture review or evidence.
