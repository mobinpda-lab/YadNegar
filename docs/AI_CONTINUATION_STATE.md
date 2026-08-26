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

Main contains real integrated foundations for:
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

Issue #9 closed/completed. Do not create a competing Timeline model.

### PR #12 — Real Timeline persistence
Merged as `cc00db09863592b6b3ccb89de05aa1c428dbb5e7` after exact-head successful `YadNegar CI` evidence.
Issue #11 completed by integration.

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
Exact head `669e11bbcde79bc17dbb4c53e0435eed8a5cd792` passed `YadNegar CI` run `32989549391`; Resolve dependencies, Analyze and Test all executed successfully.
Issue #13 completed by integration.

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
Must remain synchronized with actual GitHub state and exact CI evidence.

### PR #8 — RTL Timeline UI shell
Branch: `ui/rtl-timeline-shell`  
Current exact head: `30c3765231e38146b8b14e03a35e05cc3b91f0c4`
Issue #5 owns this UI scope.

Implemented:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- disabled Quick Capture contract until wiring is integrated
- tooltip/accessibility contract
- stable keys `timeline-empty-state` and `quick-capture-action`
- widget tests for RTL, empty state, interaction surface and disabled state

PR #8 was closed/reopened on the same branch to emit a fresh current-head pull_request event against main `bb6f976...`. Branch history contains successful CI for older head `3b7ac04...`, but that is not valid evidence for current head `30c3765...`. Merge only after exact-current-head Green.

### PR #16 — Quick Capture application use case
Branch: `feature/quick-capture-use-case`  
Current exact head: `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`
Base: `main` at latest reopen event.
Issue #15 owns this scope.

Implemented:
- `QuickCapture` application use case
- injected clock and ID generator
- trim input text
- reject empty text
- reject empty generated id
- reuse existing `TimelineItem`
- write only through `TimelineRepository`
- default capture type to `TimelineItemType.note`
- unit tests independent of UI/file system

Branch history includes a successful run for older head `8067f45...` and a cancelled stale run for `2c2f9f...`. These are not exact-current-head evidence for `8e3c3d1...`. PR #16 was closed/reopened on the same branch to emit a fresh current-head event. Merge only after exact-current-head Green.

### PR #18 — Timeline text edit application use case
Branch: `feature/edit-timeline-item`  
Current exact head: `91627cae4cdc7e4db2741693419debd081c04a87`
Base: `main`.
Issue #17 owns this scope.

Implemented:
- `EditTimelineItem`
- normalize/validate id and text
- lookup via `TimelineRepository.findById`
- preserve id/type/createdAt/occurredAt
- persist edited item only via `TimelineRepository.upsert`
- unit tests for successful edit, invalid id/text and missing item

No UI, Model, Repository or Storage duplication. PR was closed/reopened on the same branch to emit a current-head event. Exact-head CI was not yet registered at the latest branch lookup; zero Run is neither success nor failure.

### PR #21 — Load Timeline application use case
Branch: `feature/load-timeline`  
Current exact head: `8c84d754c5061641886497a4354b2aa115a4d752`
Base: `main`.
Issue #20 owns this scope.

Implemented:
- `LoadTimeline`
- reads only through `TimelineRepository.listNewestFirst`
- returns an unmodifiable snapshot for UI consumption
- optional positive `limit`
- rejects zero/negative limit before repository access
- unit tests for order preservation, limit, immutability and invalid limit

No UI, search/filter, pagination optimization, Model, Repository or Storage duplication. Exact-head CI was not yet registered at the latest branch lookup; zero Run is neither success nor failure.

## Active Issues / Ownership
- Issue #5 → PR #8 UI only.
- Issue #6 → future Full Build Gate only; Fast Gate integrated.
- Issue #9 → completed by PR #10.
- Issue #11 → completed by PR #12.
- Issue #13 → completed by PR #14.
- Issue #15 → PR #16 Quick Capture application logic.
- Issue #17 → PR #18 Edit application logic.
- Issue #20 → PR #21 Load Timeline application logic.
- Issue #19 → GitHub ruleset hardening; no implementation PR because current connector exposes Ruleset read only.

## GitHub Ruleset Reality
Active repository ruleset:
- id: `20952887`
- name: `main-protection`
- target: `refs/heads/main`
- enforcement: active

Verified rules currently prevent deletion/non-fast-forward and require Pull Requests. The ruleset currently has no required status-check rule, so `YadNegar CI` is not yet platform-enforced as a merge requirement.

Issue #19 records the desired hardening: require the verified `YadNegar CI / quality` check before merge. Do not invent a Ruleset mutation: the current connector only supports ruleset reads. Until write support exists, project automation must continue enforcing exact-head Green before every merge operationally.

## Parallel Work Model
Lane A — Core / Persistence / Application  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current coordinated wave:
- Lane A1: PR #16 Quick Capture application logic.
- Lane A2: PR #18 Edit application logic.
- Lane A3: PR #21 Load Timeline application logic.
- Lane B: PR #8 RTL Timeline UI shell.
- Lane C: PR #3 documentation sync + Issue #19 ruleset hardening gap.

These scopes are intentionally file-separated and reuse the same Domain/Repository contracts.

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
- Edit application logic: PR #18 active.
- Load Timeline application logic: PR #21 active.

Nearest integration after these lanes are validated:
`UI action → QuickCapture → TimelineRepository → persisted item → LoadTimeline → Timeline render`.
Then connect View/Edit UI to `EditTimelineItem` on the same shared contracts.

## Persistence Decision
File-backed JSON remains the MVP implementation because it is offline, dependency-free, CI-testable and replaceable behind the Domain repository port.

A future database decision must be justified by real query volume, indexing, migration, backup/recovery, export, performance and platform requirements. Do not create a competing storage foundation now.

## Actions Interpretation Rule
GitHub Actions events have appeared with noticeable indexing delay.
- zero Runs is neither success nor failure.
- a historical branch run is not evidence for a newer head.
- the workflow run's own `head_sha` is the evidence SHA; an embedded PR object may already show a newer PR head and must not be mistaken for the run head.
- diagnose failures only from real Job/Steps.
- merge only exact-current-head Green work.

## Validation Rule
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
No report may call CI Green without exact-ref evidence.
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
1. Fresh-check exact-current-head Actions for PR #8/#16/#18/#21 in parallel.
2. Inspect Job/Steps before diagnosing any failure; fix real failing code on the same branch.
3. Merge each only after exact-head Green and live safe mergeability.
4. Keep PR #3 synchronized and validate its exact current head through the new `docs/**` push coverage.
5. After #8/#16/#21 integration, create one small wiring PR for `Quick Capture → Persist → Load Timeline → real Timeline render` without another Model/Repository/Storage layer.
6. After #18 integration, connect View/Edit UI to the edit use case.
7. Apply Issue #19 ruleset hardening only when an actual Ruleset write capability is available and the exact check name has been verified.
8. Add Full Build Gate only when Platform foundation exists.

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
