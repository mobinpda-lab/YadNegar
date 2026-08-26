# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

## Verified Main Snapshot
Repository: `mobinpda-lab/YadNegar`
Default branch: `main`
Verified main SHA before this documentation branch: `08a799c10a313926cb5d0a88a2601d9b4b132745`
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
Existing workflows:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

Both workflows are placeholder workflows using checkout plus an `echo` step.
The latest visible runs on `main` completed successfully, but this proves only that the placeholder workflows executed successfully. It does **not** prove Flutter analyze/test/build because Flutter project files and real validation steps are not present yet.

## Current Documentation Work
Documentation baseline branch:
`docs/yadnegar-documentation-baseline`

Purpose:
- establish one canonical operating reference
- establish current-state continuity
- establish compact AI handoff
- establish technical/product documentation baseline
- update README to point to canonical documents

This branch must be reviewed and validated as documentation-only before merge.

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

Independent lanes should run concurrently when their file and contract boundaries do not overlap.

## Recommended Next Real Development Action
After documentation is reviewed/merged, the nearest verified implementation gap is Flutter Foundation initialization.

Recommended sequence:
1. Audit live `main` again.
2. Create a small Foundation branch.
3. Initialize the minimum valid Flutter project structure without unnecessary feature code.
4. Verify `flutter pub get` and `flutter analyze`.
5. Add the smallest baseline test and run `flutter test`.
6. Only after Foundation is real, replace placeholder CI with real Flutter validation.
7. Then start Core/UI lanes in parallel where dependencies allow.

## Validation Rule
No future report may say Flutter CI is green unless the exact commit has actually run the relevant Flutter validation.

Target chain:
`flutter pub get → flutter analyze → flutter test → flutter build` as applicable.

## Continuation Protocol
The command `ادامه یادنگار` means:
- re-check live GitHub first
- read the canonical operating package and this state file
- compare docs with current repository reality
- identify the nearest real unfinished gap
- continue safely, using parallel independent lanes where possible
- validate and document before reporting completion

## Speed Rule
Useful verified output should be produced in hours rather than days. Speed must come from parallel independent work, small changes, reuse, automation and fast feedback—not from skipping Audit, tests, architecture review or evidence.
