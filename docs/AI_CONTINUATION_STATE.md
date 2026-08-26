# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `f1b96756c501da517d25c3610341bdc81e2d5fb5`  
Commit: `feat(edit): add Timeline item text edit use case`

Main now contains real integrated pieces for:
- Flutter/Dart + Persian RTL foundation
- single Fast Quality Gate
- shared Timeline Domain
- repository contract + real JSON persistence
- active-lane CI automation
- RTL Timeline UI shell
- Quick Capture application logic
- Load Timeline application logic
- Edit Timeline Item application logic

## Integrated Work
### PR #2 — Foundation
Merged; Issue #4 completed. Exact validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` passed dependency resolution, analyze and tests.

### PR #7 — Fast CI
Merged as `9999e31f7aa2fa4717c5f027319e356ca705bebe`.
Exact head `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`; run `32987365151`: success.
Integrated one Fast Gate with restricted permissions, Flutter cache, concurrency/stale-run cancellation and no placeholder workflows.
Issue #6 remains only for future real Full Build Gate.

### PR #10 — Timeline Domain
Merged as `0610c401eb5a31a68552be047bc3d765696c2f33`.
Exact head `53825cc629fca1285e20c57bfdbc91369eabfb8c`; run `32987199672`: success.
Integrated `TimelineItemType`, `TimelineItem`, `timelineAt` and Domain tests.

### PR #12 — Persistence
Merged as `cc00db09863592b6b3ccb89de05aa1c428dbb5e7` after exact-head successful CI.
Integrated `TimelineRepository` + `JsonFileTimelineRepository`, schema v1, disk persistence, upsert/find/list, duplicate prevention, deterministic newest-first ordering, reload tests and unsupported-schema failure.
JSON remains an offline/testable/replaceable MVP, not the final database declaration.

### PR #14 — CI active-lane coverage
Merged as `bb6f97672e446973df94674f6ae16a8dbfd3d930`.
Exact head `669e11bbcde79bc17dbb4c53e0435eed8a5cd792`; run `32989549391`: success.
Single CI validates Push on main plus `ci/**`, `fix/**`, `feature/**`, `ui/**`, `core/**`, `persistence/**`, `docs/**`, and PRs to main.

### PR #8 — RTL Timeline UI
Merged as `0cb8bbd3a451234d4a1042d194f39f917266ea88`.
Exact head `30c3765231e38146b8b14e03a35e05cc3b91f0c4`; run `32990720534`: success.
Real Job steps Checkout, Flutter setup, Resolve dependencies, Analyze and Test all succeeded.
Integrated `TimelineScreen`, RTL empty state, accessibility contract and stable interaction keys.

### PR #16 — Quick Capture
Merged as `e56c71f39d9af21845e9a8b8e91c9204939479df`.
Exact head `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`; run `32990963329`: success.
Integrated `QuickCapture`, injected clock/id, input normalization, default note type, Repository-only persistence and unit tests.

### PR #21 — Load Timeline
Merged as `c988f746b9cd42e9a3f75f3b7e97469cda62cdcc`.
Exact head `8c84d754c5061641886497a4354b2aa115a4d752`; run `32991379013`: success.
Job `quality` executed Resolve dependencies, Analyze and Test successfully.
Integrated `LoadTimeline`, unmodifiable repository-backed snapshots, optional positive limit and unit tests.
Issue #20 completed.

### PR #18 — Edit Timeline Item
Merged as current main `f1b96756c501da517d25c3610341bdc81e2d5fb5`.
Exact head `91627cae4cdc7e4db2741693419debd081c04a87`; run `32991761859`: success.
Job `quality` executed Resolve dependencies, Analyze and Test successfully.
Integrated `EditTimelineItem` with id/text validation, repository lookup, metadata preservation, upsert and unit tests.
Issue #17 completed.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`.
Documentation/README only. Must remain synchronized and exact-head validated before merge.

### PR #23 — First real Timeline vertical-slice wiring
Branch: `feature/timeline-vertical-slice`  
Exact head: `4e63a58fab55fa99f3a509b642ced9b266a60e08`  
Base was re-triggered against current main `f1b96756...`.
Issue #22 owns this scope.

Implemented on the branch:
- `TimelineScreen` now renders loading/error/real Timeline item list.
- `TimelineHome` coordinates initial load, Quick Capture dialog, capture, reload and render.
- UI depends only on `QuickCapture` and `LoadTimeline`, not `dart:io` or concrete storage.
- vertical-slice widget test injects real `JsonFileTimelineRepository` with a temporary directory.
- test proves UI input → QuickCapture → JSON disk persist → LoadTimeline reload → Timeline render.
- test instantiates a second repository on the same file to prove persisted reload.
- empty capture is rejected with feedback and no persisted item.

Production `main()` is deliberately NOT connected to temp/current-directory storage. Platform-safe production bootstrap is Issue #24.
Merge PR #23 only after exact-current-head CI against the refreshed base is Green.

## Active Issues / Ownership
- Issue #5 → integrated UI foundation; future UI changes must reuse it.
- Issue #6 → future Full Build Gate only.
- Issue #19 → required CI status in main ruleset; connector currently read-only for rulesets.
- Issue #22 → PR #23 vertical-slice wiring only.
- Issue #24 → platform-safe production persistence bootstrap after PR #23.

Completed implementation issues include #4, #9, #11, #13, #15, #17 and #20.

## GitHub Ruleset Reality
Active ruleset:
- id `20952887`
- name `main-protection`
- target main
- enforcement active

It requires Pull Requests and protects deletion/non-fast-forward, but does not yet platform-require `YadNegar CI / quality`.
Issue #19 records the hardening gap. Current connector exposes Ruleset reads only; do not invent a write. Operational rule remains exact-head Green before merge.

## Product Vertical Slice
Target:
`Quick Capture → Persist → Timeline → View/Edit`

Current state:
- Domain: Integrated
- CI: Integrated
- Persistence: Integrated
- UI shell: Integrated
- Quick Capture: Integrated
- Load Timeline: Integrated
- Edit application logic: Integrated
- Capture/Persist/Load/Render wiring: PR #23 active
- Production platform-safe bootstrap: Issue #24 next
- Edit UI: after/parallel to bootstrap on same architecture

## PR #23 Architecture
`TimelineHome` is a presentation coordinator, not a new storage/application foundation.
It reuses:
- `QuickCapture`
- `LoadTimeline`
- `TimelineRepository`
- `JsonFileTimelineRepository` only in end-to-end test injection
- existing `TimelineScreen`

No competing Model/Repository/Storage is allowed.

## Platform Bootstrap Rule
Production must never use `Directory.systemTemp` or `Directory.current` as pretend durable storage.
Issue #24 proposes a platform-safe application documents/support directory (for example via `path_provider`) while keeping plugins out of Domain/UI.
`flutter build` remains invalid to claim until a real Platform project foundation exists.

## Actions Interpretation
- Actions indexing can be delayed.
- zero Runs is neither success nor failure.
- historical run is not current-head evidence.
- workflow `head_sha` is the evidence SHA.
- diagnose only from real Job/Steps.
- merge only exact-current-head Green.

## Validation
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
No CI/build/test success claim without exact-ref evidence.
Add `flutter build` only after real Platform foundation and real build execution.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based structure
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell
- no competing Timeline model
- no competing Repository/Storage foundation
- no duplicate CI path
- no fake persistence/build claims
- no duplicate canonical docs

## Next Real Actions
1. Obtain exact-current-head CI for PR #23 on main `f1b96756...` and inspect Job/Steps.
2. Fix any real PR #23 failure on the same branch; merge only exact-head Green + safe mergeability.
3. Validate merged main.
4. Start Issue #24 production bootstrap from the post-#23 main; use platform-safe storage path and reuse the same repository/application objects.
5. Build View/Edit UI on integrated `EditTimelineItem` without parallel models/storage.
6. Keep PR #3 synchronized and exact-head Green before merge.
7. Apply Issue #19 only when actual Ruleset write capability exists.
8. Create real Platform project foundation before Full Build Gate.

## Continuation Automation
Hourly task is enabled for live audit, coordinated parallel implementation, exact-ref validation, safe integration, documentation synchronization and short Persian owner reporting.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
