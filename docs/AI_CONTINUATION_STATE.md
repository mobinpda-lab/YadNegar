# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `bb6f97672e446973df94674f6ae16a8dbfd3d930`  
Commit: `ci: validate all active lanes on push`

Main now contains real integrated foundations for:
- Flutter/Dart + Persian RTL baseline
- consolidated Fast Quality Gate
- shared `TimelineItem` Domain contract
- `TimelineRepository`
- real JSON file-backed persistence
- CI push coverage for active development lanes

## Integrated Work
### PR #2 — Flutter Foundation
Merged; Issue #4 closed. Exact validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` passed dependency resolution, analyze and tests.

### PR #7 — Fast CI consolidation
Merged as `9999e31f7aa2fa4717c5f027319e356ca705bebe`.
Exact validated head `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7` passed `YadNegar CI` run `32987365151` with real Checkout, Flutter setup, dependency resolution, Analyze and Test steps.

Integrated CI characteristics:
- one Fast Quality Gate
- `permissions: contents: read`
- concurrency + `cancel-in-progress: true`
- Flutter cache
- old placeholder `test.yml` and `build.yml` removed

Issue #6 remains open only for a future real Full Build Gate after a valid Platform build path exists.

### PR #10 — Timeline Domain contract
Merged as `0610c401eb5a31a68552be047bc3d765696c2f33`.
Exact validated head `53825cc629fca1285e20c57bfdbc91369eabfb8c` passed Flutter CI run `32987199672`.

Integrated contract:
- `TimelineItemType`: note/event/call/idea/activity
- `TimelineItem`
- `timelineAt = occurredAt ?? createdAt`
- Domain tests

Issue #9 closed/completed. Do not create a competing Timeline model.

### PR #12 — Real Timeline persistence
Merged as `cc00db09863592b6b3ccb89de05aa1c428dbb5e7` after exact-head successful `YadNegar CI` evidence.
Issue #11 closed by integration.

Integrated persistence:
- Domain `TimelineRepository`
- `JsonFileTimelineRepository`
- real disk persistence via `dart:io`
- schema version `1`
- `upsert`, `findById`, `listNewestFirst`
- duplicate prevention by id
- deterministic ordering by effective `timelineAt`
- reload-from-disk tests using temporary directories
- fail-fast for unsupported schema versions

No external storage dependency was added. JSON persistence is the first offline, testable, replaceable implementation—not the declared final database.

### PR #14 — Active-lane CI push coverage
Merged as current main `bb6f97672e446973df94674f6ae16a8dbfd3d930`.
Exact head `669e11bbcde79bc17dbb4c53e0435eed8a5cd792` passed `YadNegar CI` run `32989549391` with Resolve dependencies, Analyze and Test all successful.
Issue #13 should remain closed/completed for this scope.

The single workflow now validates Push branches including:
- `main`
- `ci/**`
- `fix/**`
- `feature/**`
- `ui/**`
- `core/**`
- `persistence/**`
- `docs/**`

Pull-request validation against `main` remains enabled. No parallel CI path was created.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Scope: Documentation/README only.
This branch must remain synchronized with actual GitHub implementation and exact CI evidence.

### PR #8 — RTL Timeline UI shell
Branch: `ui/rtl-timeline-shell`  
Current exact head: `30c3765231e38146b8b14e03a35e05cc3b91f0c4`
Live state at last audit: open, non-draft, mergeable.
Issue #5 owns this UI scope.

Implemented:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- disabled Quick Capture contract until wiring is integrated
- Quick Capture tooltip/accessibility contract
- stable keys `timeline-empty-state` and `quick-capture-action` for reliable tests/wiring
- widget tests for RTL, empty state, interaction surface and disabled state

The latest stable-key commits intentionally emitted fresh Push/PR events after CI lane expansion. At the latest exact-head lookup, no workflow run was yet registered for `30c3765...`; zero Run is neither success nor failure. Merge only after exact-head real Green evidence.

### PR #16 — Quick Capture application use case
Branch: `feature/quick-capture-use-case`  
Current exact head: `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`
Current base: `main`.
Issue #15 owns this scope.

PR #12 is already integrated, so PR #16 is no longer stacked on an unmerged dependency.

Implemented:
- `QuickCapture` application use case
- injected clock and ID generator
- trim input text
- reject empty text
- reject empty generated id
- reuse existing `TimelineItem`
- write only through `TimelineRepository`
- default Quick Capture type to `TimelineItemType.note` for the fastest capture path
- unit tests with a recording repository, independent of UI and file system

The latest default-note commits intentionally emitted fresh Push/PR events. At the latest exact-head lookup, no workflow run was yet registered for `8e3c3d1...`; zero Run is neither success nor failure. Merge only after exact-head real Green evidence and live mergeability.

## Active Issues / Ownership
- Issue #5 → PR #8 UI only.
- Issue #6 → future Full Build Gate only; Fast Gate already integrated.
- Issue #9 → completed by PR #10.
- Issue #11 → completed by merged PR #12.
- Issue #13 → completed by merged PR #14.
- Issue #15 → PR #16 Quick Capture application logic only.

## Parallel Work Model
Lane A — Core / Persistence / Application  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current coordinated wave:
- Lane A: PR #16 Quick Capture application logic.
- Lane B: PR #8 RTL Timeline UI shell.
- Lane C: PR #3 documentation synchronization; CI automation is integrated on main.

## Product Direction
First real vertical slice:
`Quick Capture → Persist → Timeline → View/Edit`

Progress:
- Shared Timeline Domain: integrated.
- Fast CI: integrated.
- Real Persistence: integrated.
- Active-lane CI automation: integrated.
- Timeline UI shell: PR #8 active.
- Quick Capture application logic: PR #16 active.

Nearest next integration after #8/#16:
`UI action → QuickCapture → TimelineRepository → persisted item → Timeline reload/render`.
Then add `View/Edit` on the same shared contract.

## Persistence Decision
File-backed JSON remains the MVP implementation because it is offline, dependency-free, testable in CI and replaceable behind the Domain repository port.

A future database decision must be justified by real query volume, indexing, migration, backup/recovery, export, performance and platform requirements. Do not create a competing storage foundation now.

## Validation Rule
No report may call CI green without exact-ref evidence.
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Add `flutter build` only when a valid Platform project/build path exists and the build really executes.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first UI
- Reuse before rebuild
- no duplicate App Shell
- no competing Timeline model
- no competing Repository/Storage foundation
- no duplicate CI path
- no fake persistence claims
- no duplicate canonical documentation

## Next Real Actions
1. Fresh-check exact-head Actions for PR #8 `30c3765...` and PR #16 `8e3c3d1...` in parallel.
2. Inspect real Job/Steps before diagnosing any failure.
3. Merge each only after exact-head Green evidence and live safe mergeability.
4. Keep PR #3 synchronized; docs branch now receives Push CI directly because PR #14 is integrated.
5. After #8/#16 integration, create one small wiring PR for `Quick Capture → Persist → real Timeline render` without adding another Model/Repository/Storage layer.
6. Follow with View/Edit in the same vertical-slice architecture.
7. Add Full Build Gate only when Platform foundation exists and real build execution is possible.

## Continuation Automation
An hourly task is enabled to fresh-audit live GitHub and continue real YadNegar production with the same rules: parallel execution, exact-ref validation, safe integration, documentation synchronization and short nontechnical reporting.

## Continuation Trigger
`ادامه یادنگار`

Meaning:
`Audit live GitHub → reconcile docs → avoid duplicate work → parallel execute → validate exact refs → merge safe work → continue vertical slice → document → short report`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
Keep owner-facing reports short, simple and nontechnical.

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
