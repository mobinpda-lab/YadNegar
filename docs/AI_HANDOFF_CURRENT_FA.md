# YadNegar — Live AI Handoff

## قانون اصلی
مرجع عملیات پروژه: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
GitHub Reality همیشه مقدم است؛ قبل از هر Write/Merge وضعیت زنده را Audit کن.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
آخرین main تأییدشده: `e56c71f39d9af21845e9a8b8e91c9204939479df`  
Commit: `feat(capture): add Quick Capture use case`

## Integrated روی main
- PR #2 Foundation — Flutter/Dart + Persian RTL baseline + tests.
- PR #7 Fast CI — merge `9999e31...`; validated run `32987365151` success.
- PR #10 Timeline Domain — merge `0610c401...`; run `32987199672` success.
- PR #12 Persistence — merge `cc00db09...`; exact-head CI success; `TimelineRepository` + real JSON disk persistence.
- PR #14 CI Automation — merge `bb6f976...`; run `32989549391` success; Push CI covers active lane prefixes.
- PR #8 UI — merge `0cb8bbd3a451234d4a1042d194f39f917266ea88`; exact head `30c3765231e38146b8b14e03a35e05cc3b91f0c4`; run `32990720534` success with Resolve/Analyze/Test.
- PR #16 Quick Capture — merge/current main `e56c71f39d9af21845e9a8b8e91c9204939479df`; exact head `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`; run `32990963329` success with Resolve/Analyze/Test.

## Product pieces now real
- `TimelineItem` shared Domain model
- `TimelineRepository`
- `JsonFileTimelineRepository`
- RTL `TimelineScreen`
- stable UI keys + accessibility contract
- `QuickCapture` application use case with default note capture

## Active parallel wave
### PR #18 — Edit Timeline Item
Issue #17 → PR #18 only.
Branch `feature/edit-timeline-item`, head `91627cae4cdc7e4db2741693419debd081c04a87`, re-triggered against current main `e56c71f...`.
Owns `EditTimelineItem` + unit tests. No UI/model/repository/storage duplication.
Merge only after exact-current-head Green.

### PR #21 — Load Timeline
Issue #20 → PR #21 only.
Branch `feature/load-timeline`, head `8c84d754c5061641886497a4354b2aa115a4d752`, re-triggered against current main `e56c71f...`.
Owns `LoadTimeline`, unmodifiable newest-first snapshot, optional limit and unit tests.
Ignore branch-creation run whose workflow `head_sha` is old base; exact code head must be Green.

### PR #3 — Documentation
Canonical docs branch is active and synced with implementation/CI/merge changes. `docs/**` gets Push CI.

### Issue #19 — Ruleset hardening
Active `main-protection` ruleset id `20952887` requires PRs and prevents deletion/non-fast-forward but does not yet require `YadNegar CI / quality` status.
Current connector supports Ruleset read only. Do not claim mutation. Operationally merge only exact-current-head Green work.

## Vertical Slice
Target: `Quick Capture → Persist → Timeline → View/Edit`

Status:
- Domain: Integrated
- CI: Integrated
- Persistence: Integrated
- UI shell: Integrated
- Quick Capture logic: Integrated
- Edit logic: PR #18
- Load Timeline: PR #21

Nearest next step after #18/#21:
`Quick Capture UI → QuickCapture → TimelineRepository → persisted item → LoadTimeline → Timeline render`.
Then connect View/Edit UI to `EditTimelineItem`.

## Validation
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Evidence only for exact workflow `head_sha`.
Historical run or zero runs is not current evidence.
`flutter build` only after real Platform foundation.

## معماری
Reuse before rebuild. No second Foundation/AppShell/Timeline Model/Repository/Storage/CI. UI must not depend directly on `dart:io`. DB later only if real query/index/migration/recovery/performance needs justify it.

## ادامه
1. Audit PR #18/#21 exact Actions against main `e56c71f...`.
2. Fix real failing Job/Step on same branch.
3. Merge exact-head Green work with expected head SHA.
4. Validate main after integration.
5. Keep PR #3 synced and Green.
6. Create one small wiring PR for capture → persist → load → render.
7. Add View/Edit UI using integrated `EditTimelineItem`.
8. Apply Issue #19 only with real Ruleset write capability.
9. Full Build Gate only after Platform foundation.

## Automation ادامه
Hourly continuation task is enabled for live audit, parallel implementation, exact-ref validation, safe merge, docs sync and short Persian reporting.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
