# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge یا اعلام SHA/CI/Mergeability، وضعیت زنده را دوباره Audit کن.

Canonical governance: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
Active plan: `docs/YADNEGAR_OPERATION_PLAN.md`  
Current state: `docs/AI_CONTINUATION_STATE.md`

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `453a77a9e662f705bed8f899a769b425927bebb4`

## Product State
Vertical Slice اصلی واقعی است:
`Quick Capture → Persist → Timeline → View/Edit`

Main additionally has:
- typed Quick Capture on the shared `TimelineItemType`
- `SearchTimeline` + RTL text/type retrieval UI
- `FilterTimelineByDateRange` + RTL date-range UI
- Vazirmatn typography + optional private licensed IRANSansX
- deduplicated feature/main CI triggers
- crash-recoverable JSON persistence in the same `JsonFileTimelineRepository`

هیچ Model/Repository/Storage موازی ساخته نشده است.

## Reliability — #42 Integrated
Issue #41 completed and PR #42 merged with exact-head lock.

Merged main:
`379f58caf34f2206556246beb94e27a2c85ece78`

Pre-merge exact-head proof:
- Fast CI `33012747019`: success
- Android `33012747020`: success

Post-merge proof:
- Fast CI `33014440255`: success
- Android `33014440247`: success

## Date Range UI — #47 Integrated
Issue #46 completed.  
PR exact head before merge:
`10f6d1dc0e288f4a46552a54ad7bfa808c9ccd7e`

Pre-merge exact-head gates:
- `YadNegar CI` Run `33014650334`: success
- `YadNegar Android Build` Run `33014650363`: success
- live mergeability: true

Merged safely as current main:
`453a77a9e662f705bed8f899a769b425927bebb4`

Integrated behavior:
- existing `FilterTimelineByDateRange` reused
- same `TimelineRepository` reused
- UI end date included via next-day exclusive Application boundary
- Date + Text + Type compose
- clear/reset and filtered empty state cover date filtering
- widget tests cover multiple days, inclusive end date and retrieval combinations

Post-merge current-main gates at this snapshot:
- Fast CI `33015057876`: running
- Android `33015057863`: running

Fresh-check these runs before claiming post-merge Green.

## Next Product Slice — Issue #48
`feat(capture): expose occurredAt for Event and Activity`

Do not rebuild foundations. Current code already has:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- `QuickCapture.capture(occurredAt: ...)`

Missing gap is only Quick Capture UI/composition. Implement optional date/time for Event/Activity from current main after docs sync; reuse the existing contracts.

## Docs
PR #43 is stale and must not be merged unchanged.

Replacement branch:
`docs/current-state-after-reliability`

It is synchronized onto current main and records #42/#47 reality plus #48 next work. Open/validate the replacement PR, then close #43 as superseded.

## Ruleset — #19
`main-protection` is active but still does not contain a required-status-check rule.

Until real Ruleset write capability exists:
`exact-head Green CI/Build + live mergeability + expected-head lock` is the operational safety contract.

## ادامه کار
1. Finish current-main post-merge Fast + Android validation.
2. Open the clean docs replacement PR from `docs/current-state-after-reliability`.
3. Close stale #43 as superseded; merge docs only after exact-head validation.
4. Start #48 from current main without duplicate Domain/Application/Storage work.
5. Keep #19 open until actual platform enforcement is writable and proven.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
