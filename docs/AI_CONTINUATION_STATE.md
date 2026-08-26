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

No Flutter foundation was present at repository root at that snapshot:
- no `pubspec.yaml`
- no `lib/`
- no `test/`

Therefore Flutter/Clean Architecture is currently a target, not a verified implementation state.

## Verified CI State
Existing workflows on `main`:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

Both workflows are placeholder workflows using checkout plus an `echo` step.
The latest visible runs on `main` completed successfully, but this proves only that the placeholder workflows executed successfully. It does **not** prove Flutter analyze/test/build because Flutter project files and real validation steps are not present yet.

## Current Documentation Work
Documentation branch:
`docs/yadnegar-documentation-baseline`

Open pull request:
`#3 — docs: establish YadNegar canonical project documentation`

Current documentation package includes:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — canonical governance
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md` — comprehensive project reference
- `docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md` — accelerated parallel execution plan
- `docs/AI_CONTINUATION_STATE.md` — current state
- `docs/AI_HANDOFF_CURRENT_FA.md` — compact AI handoff
- `PROJECT_DOCUMENTATION_FA.md` — technical/product detail
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md` — compatibility pointer
- updated `README.md`

The documentation PR is intentionally documentation-only and should remain isolated from application/workflow behavior changes.

## Active Operational Workstreams
Three real GitHub Issues now define the first parallel wave:

### Issue #4 — Foundation
`foundation: initialize minimal Flutter project`
Critical path for real implementation.

### Issue #5 — UI / RTL
`ui: define RTL app shell and timeline contract`
Contract/design can progress in parallel; implementation depends on the Flutter foundation.

### Issue #6 — CI / Automation
`ci: replace placeholders with Flutter fast and full gates`
Workflow design can progress in parallel; valid Flutter execution depends on the Flutter foundation.

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

Independent lanes should run concurrently when their file and contract boundaries do not overlap. A blocked lane must not block unrelated work.

## Recommended Next Real Development Action
After documentation PR #3 is reviewed/merged, the nearest verified implementation gap is Issue #4: Flutter Foundation initialization.

At the same time:
- Issue #5 may proceed on UI/RTL contract work that does not require Flutter implementation files.
- Issue #6 may proceed on CI design/preparation, but real Flutter workflow validation must wait for Foundation.

Recommended sequence:
1. Re-audit live `main` immediately before starting development.
2. Start Issue #4 from current `main` in a small Foundation branch.
3. In parallel, prepare non-conflicting Issue #5 and #6 workstreams.
4. Validate Foundation with `flutter pub get → flutter analyze → flutter test`.
5. Replace placeholder CI only when the Foundation is real.
6. Begin Timeline Domain / RTL App Shell / Fast Lane CI as the next coordinated parallel wave.

## Validation Rule
No future report may say Flutter CI is green unless the exact commit has actually run the relevant Flutter validation.

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
- compare docs with current repository reality
- identify the nearest real unfinished gap
- continue safely, using parallel independent lanes where possible
- validate and document before reporting completion

## Speed Rule
Useful verified output should be produced in hours rather than days. Speed must come from parallel independent work, small changes, reuse, automation, stale-CI cancellation and fast feedback—not from skipping Audit, tests, architecture review or evidence.
