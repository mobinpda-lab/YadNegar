# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `006e6aae3d4f4ddab988bb0fd9ce5dd968b10ab2`

## Current Product State
Vertical Slice اصلی کامل و روی main یکپارچه است:
`Quick Capture → Persist → Timeline → View/Edit`

روی main وجود دارد:
- Flutter/Dart + Persian RTL foundation
- unified Fast CI
- Timeline Domain
- TimelineRepository + real JSON disk persistence
- QuickCapture / LoadTimeline / EditTimelineItem
- Timeline UI
- Quick Capture real persist/reload/render
- production-safe application-support persistence bootstrap
- item tap/edit/persist/reload/render
- canonical project documentation
- Fast CI push coverage برای `platform/**`

## Recent Exact Evidence
- PR #23 head `a4bc2ffe...`; run `32996798616` success; merged `329ad83c...`.
- PR #26 head `84b4a93b...`; run `32997146108` success; merged `e2564db5...`.
- PR #27 head `60a9fe96...`; run `32997724347` success; merged `89c349d3...`.
- PR #3 canonical docs merged `1765e661...` after exact-head Green CI.
- PR #30 head `366e1c9b...`; run `32998392710` success; merged/current main `006e6aae...`; `platform/**` is now in existing Fast Gate.

## Android — Real Build Evidence
Issue #28 owns Android platform foundation.

Bootstrap run `32998085012` completed success in real Flutter `3.35.0` environment:
Generate Android → pub get → Analyze → Test → `flutter build apk --debug` → Verify APK → Upload Artifact → Commit platform files.

Committed generated platform head:
`c23721dc68c622f2fa54d74b477a3b3efe143d3b`.

Proof artifact:
- `yadnegar-android-bootstrap-debug`
- id `9617520192`
- 66,096,367 bytes
- digest `sha256:5f3481dc4a9ffa756fabd03ff2b49f5874bd1bf8578d291ae2176fb295cf21a3`
- expires 2026-09-02

This proves Android can build and produce a real APK. It does not mean Android foundation is integrated on main until PR #31 merges.

## PR #31 — Current Critical Lane
`platform(android): add real Android foundation and APK build gate`

Head: `e53572b0a4a24d810de22120de88069ba6ee49c9`.

It contains:
- committed Android project foundation
- `pubspec.lock`
- permanent `YadNegar Android Build` workflow
- read-only permissions
- no generator/self-commit behavior
- real APK build + verification + artifact upload

Required before merge:
1. exact-head `YadNegar CI` Green
2. exact-head `YadNegar Android Build` Green
3. safe live mergeability

At current handoff both exact-head workflows exist and were still awaiting completion. Inspect live jobs before any merge.

## CI / Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`.

Fast CI now validates platform branches too. Android Build is intentionally a separate slower gate.

## Ruleset
`main-protection` id `20952887` still does not require `YadNegar CI / quality` at platform level.
Issue #19 remains open because current connector exposes no Ruleset write action.

## Next
1. Inspect both PR #31 exact-head workflows.
2. Fix only real failures; otherwise Merge with expected-head SHA lock.
3. Validate post-merge main and APK build.
4. Advance Issue #6 into the proven Full Build Gate phase.
5. Keep this handoff + continuation state synchronized in parallel.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Automation Reality
Separate hourly YadNegar continuation automation exists but is currently disabled. GitHub CI automation is active.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
