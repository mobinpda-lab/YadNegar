# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge یا اعلام SHA/CI/Mergeability، وضعیت زنده را دوباره Audit کن.

Canonical governance: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
Active plan: `docs/YADNEGAR_OPERATION_PLAN.md`  
Current state: `docs/AI_CONTINUATION_STATE.md`

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `379f58caf34f2206556246beb94e27a2c85ece78`

## Product State
Vertical Slice اصلی واقعی است:
`Quick Capture → Persist → Timeline → View/Edit`

Main همچنین دارد:
- typed Quick Capture روی `TimelineItemType` واحد
- SearchTimeline + RTL Search/Type UI
- Date-range application foundation با start-inclusive / end-exclusive
- Vazirmatn typography + optional private licensed IRANSansX
- deduplicated PR/main CI triggers
- crash-recoverable JSON persistence در همان `JsonFileTimelineRepository`

هیچ Model/Repository/Storage موازی ساخته نشده است.

## Reliability — #42 Integrated
Issue #41 completed و PR #42 با exact-head lock Merge شد.

Main after merge:
`379f58caf34f2206556246beb94e27a2c85ece78`

Pre-merge exact-head proof:
- Fast CI `33012747019`: success
- Android `33012747020`: success

Post-merge proof:
- Fast CI `33014440255`: success
- Android `33014440247`: success

## Date Range UI — PR #47 ACTIVE
Issue #46.  
Branch: `feature/timeline-date-range-ui`  
Exact current head at this snapshot:
`10f6d1dc0e288f4a46552a54ad7bfa808c9ccd7e`

The branch is synchronized to current main and its diff against main is limited to:
- `TimelineHome`
- `TimelineScreen`
- production composition in `main.dart`
- retrieval widget tests

Feature behavior:
- existing `FilterTimelineByDateRange` reused
- same repository reused
- end date selected by user is included by passing next-day exclusive boundary to Application
- Date + Text + Type filters compose
- clear resets retrieval filters
- filtered empty state applies to date-only searches too

Widget tests cover multiple days, inclusive end day, date + text, date + type, clear/reset and date-empty behavior.

Current exact-head gates:
- `YadNegar CI` Run `33014650334`: success
- `YadNegar Android Build` Run `33014650363`: in progress

Do not merge until Android is success, then re-read exact head + live mergeability immediately and merge with expected-head lock.

## Next Product Slice — Issue #48
`feat(capture): expose occurredAt for Event and Activity`

Do not rebuild foundations. Current code already has:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- `QuickCapture.capture(occurredAt: ...)`

Missing gap is only Quick Capture UI/composition. Start implementation only after #47 is settled on main because both touch Timeline UI.

## Docs
PR #43 is stale and must not be merged unchanged.
A clean docs synchronization branch supersedes it and must receive one final refresh after #47 settles.

## Ruleset — #19
`main-protection` is active but still does not contain a required-status-check rule.
Until real Ruleset write capability exists:
`exact-head Green CI/Build + live mergeability + expected-head lock` is the operational safety contract.

## ادامه کار
1. Check PR #47 Android exact-head result.
2. If both exact-head gates Green, re-read head/mergeability and merge safely.
3. Validate new main.
4. Finalize clean docs sync and close stale PR #43 as superseded.
5. Start #48 from new main without duplicate Domain/Application/Storage work.
6. Keep #19 open until real platform enforcement is writable and proven.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
