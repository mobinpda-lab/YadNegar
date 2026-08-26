# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `89c349d304b0f1b1f57e518b7739723e21facc0b`  
Commit: `feat(timeline): add real View/Edit flow`

## Current Product State
Vertical Slice هدف فعلی کامل و روی main یکپارچه است:
`Quick Capture → Persist → Timeline → View/Edit`

روی main اکنون وجود دارد:
- Flutter/Dart + Persian RTL foundation
- single Fast CI
- Timeline Domain
- TimelineRepository + real JSON disk persistence
- QuickCapture
- LoadTimeline
- EditTimelineItem
- Timeline UI
- Quick Capture real persist/reload/render
- production-safe app-support persistence bootstrap
- item tap/edit/persist/reload/render

## Recent Exact Evidence
PR #23 final head `a4bc2ffe...`; run `32996798616` success; merged `329ad83c...`; Issue #22 completed.
PR #26 final head `84b4a93b...`; run `32997146108` success; merged `e2564db5...`; Issue #24 completed.
PR #27 final head `60a9fe96...`; run `32997724347` success; merged/current main `89c349d3...`; Issue #25 completed.

For each run, Resolve dependencies, Analyze and Test succeeded.

## View/Edit Integration Detail
Parallel development initially caused a real merge conflict after production bootstrap merged. The same View/Edit branch was reconciled with fresh main through a real merge commit; no duplicate PR was created. Mergeability was rechecked true before expected-head locked merge.

Production composition now shares the same repository between QuickCapture, LoadTimeline and EditTimelineItem.

## Production Persistence
`main()` uses `getApplicationSupportDirectory()` with compatible `path_provider ^2.1.5` and one `JsonFileTimelineRepository`.
No `Directory.systemTemp` / `Directory.current` fake production persistence.
Platform plugin remains at composition root.

## Docs — PR #3
Canonical docs branch is receiving the final post-View/Edit sync now. Merge only after exact-final-head CI Green and safe mergeability.

## CI / Ruleset
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
GitHub CI automation is active with PR/push validation, cache, concurrency and stale-run cancellation.

Ruleset `main-protection` id `20952887` still lacks platform-required `YadNegar CI / quality`.
Issue #19 remains open. Current connector has no Ruleset write action, so no fake hardening claim.

## Next Platform Wave
Issue #28 owns real Android foundation + APK validation.
Repository still has no committed Android platform project on main, therefore no APK/full build success is claimed yet.

Required sequence:
1. create Android platform foundation in a real Flutter 3.35 environment.
2. commit generated platform files.
3. execute real Android build.
4. verify APK artifact.
5. only then extend Issue #6 to a Full Build Gate.

## Automation Reality
Separate hourly YadNegar continuation automation exists but is currently disabled. GitHub CI automation itself is active.

## Continue
1. Check exact-head CI and mergeability for final docs PR #3; merge if safe.
2. Fresh-audit main after docs merge.
3. Start Issue #28 Android platform lane.
4. Produce real APK evidence before Full Build Gate.
5. Keep Issue #19 blocked only on real Ruleset write capability.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
