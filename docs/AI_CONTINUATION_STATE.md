# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `e56c71f39d9af21845e9a8b8e91c9204939479df`  
Commit: `feat(capture): add Quick Capture use case`

Main now contains real integrated foundations and product pieces for:
- Flutter/Dart + Persian RTL baseline
- consolidated Fast Quality Gate
- shared `TimelineItem` Domain contract
- `TimelineRepository`
- real JSON file-backed persistence
- active-lane CI push coverage
- RTL Timeline UI shell
- Quick Capture application logic

## Integrated Work
### PR #2 — Flutter Foundation
Merged; Issue #4 closed. Exact validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` passed dependency resolution, analyze and tests.

### PR #7 — Fast CI consolidation
Merged as `9999e31f7aa2fa4717c5f027319e356ca705bebe`.
Exact validated head `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7` passed `YadNegar CI` run `32987365151` with real Checkout, Flutter setup, dependency resolution, Analyze and Test.

Integrated CI:
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

Issue #9 completed. No competing Timeline model.

### PR #12 — Real Timeline persistence
Merged as `cc00db09863592b6b3ccb89de05aa1c428dbb5e7` after exact-head successful `YadNegar CI` evidence.
Issue #11 completed.

Integrated persistence:
- `TimelineRepository`
- `JsonFileTimelineRepository`
- real disk persistence via `dart:io`
- schema version `1`
- `upsert`, `findById`, `listNewestFirst`
- duplicate prevention by id
- deterministic ordering by effective `timelineAt`
- reload-from-disk tests
- fail-fast for unsupported schema versions

JSON is the first offline, testable, replaceable implementation—not the declared final database.

### PR #14 — Active-lane CI push coverage
Merged as `bb6f97672e446973df94674f6ae16a8dbfd3d930`.
Exact head `669e11bbcde79bc17dbb4c53e0435eed8a5cd792` passed `YadNegar CI` run `32989549391`; Resolve dependencies, Analyze and Test all succeeded.
Issue #13 completed.

The single workflow validates Push branches:
- `main`
- `ci/**`
- `fix/**`
- `feature/**`
- `ui/**`
- `core/**`
- `persistence/**`
- `docs/**`

Pull-request validation against `main` remains enabled. No parallel CI path exists.

### PR #8 — RTL Timeline UI shell
Merged as `0cb8bbd3a451234d4a1042d194f39f917266ea88`.
Exact validated head: `30c3765231e38146b8b14e03a35e05cc3b91f0c4`.
`YadNegar CI` run `32990720534`: success.
Job `quality` executed successfully:
- Checkout
- Set up Flutter
- Resolve dependencies
- Analyze
- Test

Integrated UI:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- disabled Quick Capture interaction contract pending real wiring
- tooltip/accessibility contract
- stable keys `timeline-empty-state` and `quick-capture-action`
- widget tests

Issue #5 remains the UI/vertical-slice owner; do not create another App Shell or Timeline UI foundation.

### PR #16 — Quick Capture application use case
Merged as current main `e56c71f39d9af21845e9a8b8e91c9204939479df`.
Exact validated head: `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`.
`YadNegar CI` run `32990963329`: success.
Job `quality` executed successfully with Resolve dependencies, Analyze and Test.
Issue #15 completed through merge.

Integrated application logic:
- `QuickCapture`
- injected clock and ID generator
- trim input
- reject empty text/id
- reuse `TimelineItem`
- persist only through `TimelineRepository`
- default capture type = `note`
- unit tests independent of UI/file system

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`.
Documentation/README only. Must remain synchronized with real GitHub state and exact CI evidence.

### PR #18 — Timeline text edit application use case
Branch: `feature/edit-timeline-item`  
Exact head: `91627cae4cdc7e4db2741693419debd081c04a87`  
Base was re-triggered against current main `e56c71f...`.
Issue #17 owns this scope.

Implemented:
- `EditTimelineItem`
- normalize/validate id and text
- lookup through `TimelineRepository.findById`
- preserve id/type/createdAt/occurredAt
- persist edited item through existing `upsert`
- unit tests for success and invalid/missing cases

No UI, Model, Repository or Storage duplication. Merge only after exact-current-head Green against the refreshed base.

### PR #21 — Load Timeline application use case
Branch: `feature/load-timeline`  
Exact head: `8c84d754c5061641886497a4354b2aa115a4d752`  
Base was re-triggered against current main `e56c71f...`.
Issue #20 owns this scope.

Implemented:
- `LoadTimeline`
- read only through `TimelineRepository.listNewestFirst`
- unmodifiable snapshot for UI
- optional positive `limit`
- validation before repository access
- unit tests for order, limit, immutability and invalid limit

A branch-creation run may show the old base SHA and is not evidence for this code head. Merge only after workflow `head_sha` exactly equals `8c84d754...` and the job is Green.

## Active Issues / Ownership
- Issue #5 → integrated UI shell + next UI wiring on existing architecture.
- Issue #6 → future Full Build Gate only.
- Issue #9 → completed by PR #10.
- Issue #11 → completed by PR #12.
- Issue #13 → completed by PR #14.
- Issue #15 → completed by PR #16.
- Issue #17 → PR #18 Edit application logic.
- Issue #20 → PR #21 Load Timeline application logic.
- Issue #19 → GitHub ruleset hardening; current connector exposes Ruleset read only.

## GitHub Ruleset Reality
Active ruleset:
- id `20952887`
- `main-protection`
- target `refs/heads/main`
- enforcement active

It prevents deletion/non-fast-forward and requires Pull Requests, but does not yet require `YadNegar CI / quality` as a platform-enforced status check.
Issue #19 records the desired hardening. Do not invent a Ruleset write. Until actual write capability exists, merge only exact-current-head Green PRs operationally.

## Parallel Work Model
Lane A — Core / Persistence / Application  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current coordinated wave:
- Lane A1: PR #18 Edit application logic.
- Lane A2: PR #21 Load Timeline application logic.
- Lane B: integrated UI shell; next wiring starts only after current application contracts land.
- Lane C: PR #3 documentation sync + Issue #19 ruleset hardening gap.

## Product Direction
First real vertical slice:
`Quick Capture → Persist → Timeline → View/Edit`

Progress:
- Domain: integrated.
- Fast CI: integrated.
- Real Persistence: integrated.
- CI automation: integrated.
- Timeline UI shell: integrated.
- Quick Capture application logic: integrated.
- Edit application logic: PR #18 active.
- Load Timeline application logic: PR #21 active.

Nearest real integration after #18/#21:
`Quick Capture UI → QuickCapture → TimelineRepository → persisted item → LoadTimeline → Timeline render`.
Then View/Edit UI consumes `EditTimelineItem`.

## Actions Interpretation Rule
- GitHub Actions indexing can be delayed.
- zero Runs is neither success nor failure.
- historical branch run is not current-head evidence.
- workflow `head_sha` is the evidence SHA; embedded PR metadata may already show a newer base/head.
- diagnose only from real Job/Steps.
- merge only exact-current-head Green.

## Validation Rule
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
No CI/build/test claim without exact-ref evidence.
Add `flutter build` only when a valid Platform project/build path exists and the build actually executes.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell
- no competing Timeline model
- no competing Repository/Storage foundation
- no duplicate CI path
- no fake persistence/build claims
- no duplicate canonical documentation

## Next Real Actions
1. Fresh-check exact-current-head Actions for PR #18 and PR #21.
2. Fix any real failing Job/Step on the same branch.
3. Merge each only after exact-head Green and live safe mergeability.
4. Fresh-check main CI after each integration.
5. Keep PR #3 synchronized and validate its exact current docs head.
6. Once LoadTimeline is integrated, create one small wiring PR for real `Quick Capture → Persist → Load → Render`, reusing integrated UI and repository contracts.
7. Connect View/Edit UI to `EditTimelineItem` after PR #18 integration.
8. Apply Issue #19 only when actual Ruleset write support exists and exact check name is verified.
9. Add Full Build Gate only after Platform foundation.

## Continuation Automation
An hourly task is enabled for fresh live audit, coordinated parallel implementation, exact-ref validation, safe integration, documentation sync and short Persian owner reporting.

## Continuation Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
Keep owner-facing reports short, simple and nontechnical.

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
