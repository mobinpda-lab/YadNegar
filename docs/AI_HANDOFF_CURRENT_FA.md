# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `1b31899d69d3f1fa98520dcc82a9251a7026cc09`

## Product State
Vertical Slice اصلی روی main کامل است:
`Quick Capture → Persist → Timeline → View/Edit`

Main اکنون شامل:
- Flutter/Dart + Persian RTL
- Timeline Domain / Repository / JSON persistence
- QuickCapture / LoadTimeline / EditTimelineItem
- real capture/persist/reload/render
- production-safe app-support persistence
- real item View/Edit
- canonical docs
- Fast CI برای active lanes شامل `platform/**`
- committed Android project foundation
- permanent real APK Build Gate

## Full Build Gate — DONE
PR #31 final head `e53572b0a4a24d810de22120de88069ba6ee49c9`:
- Fast CI Run `33000840296`: success
- Android Build Run `33000840285`: success
- artifact `yadnegar-debug-apk` id `9618635116`

Merged main:
`1b31899d69d3f1fa98520dcc82a9251a7026cc09`

Post-merge exact main proof:
- Fast CI Run `33001323525`: success
- Android Build Run `33001323462`: success
- APK Build / Verify / Upload all success
- artifact id `9618821948`
- size `66096365` bytes
- digest `sha256:6976da5fcdc8958c70d7b9b73df71053c4b47f6b6eb158793751e20754ec4604`

Issue #28 and Issue #6 are completed.

Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`

## Product Lane — PR #34
Issue #33: choose Timeline item type during Quick Capture.
Head: `d0d206fd765dc5aa19963a971ac7c1eb4b9830ca`.

Implemented:
- Persian type selector
- Note/Event/Call/Idea/Activity from existing `TimelineItemType`
- Note remains default
- selected type persists through existing QuickCapture contract
- edit title reflects actual type
- widget tests for Idea + default Note

Validation at this handoff:
- `YadNegar CI` Run `33001576158`: success
- `YadNegar Android Build` Run `33001576065`: running

Do not merge until Android Build is exact-head Green, artifact exists, and live mergeability is safe.

## Retrieval Lane — PR #36
Issue #35: Search/Filter application foundation.
Head: `d56df46ce85f2ba7e96d9b98bc9fd53db2d138ca`.

Independent work:
- SearchTimeline application use case
- text query + optional type filter
- order preservation + unmodifiable snapshot
- unit tests
- no Search UI / DB / Repository / Storage duplication

Both Fast CI and Android Build are running. Keep lane independent from #34; synchronize only if main changes materially before merge.

## Docs Lane — PR #32
Current State + Handoff are synced with:
- Android Full Build proof
- Issue #6 completion
- PR #34 live product expansion
- PR #36 live retrieval foundation

Before merging docs: one final GitHub reality check + exact-head docs CI Green.

## Ruleset
`main-protection` id `20952887` still does not platform-require `YadNegar CI / quality`.
Issue #19 remains open because current connector has no Ruleset write action.

## Continue
1. Check exact-head Android Build/artifact + mergeability for PR #34; merge only fully Green.
2. Check both exact-head gates for PR #36; merge independently when safe.
3. Validate main after integrations.
4. Continue non-conflicting Wave 4 / Wave 5 lanes.
5. Final-sync and merge PR #32.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Automation Reality
Separate hourly YadNegar continuation automation exists but is currently disabled. GitHub CI automation is active.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
