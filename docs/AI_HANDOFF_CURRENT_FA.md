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
- typed Quick Capture on shared `TimelineItemType`
- Search + Type retrieval
- Date Range retrieval UI on existing application contract
- Vazirmatn + optional private licensed IRANSansX
- deduplicated feature/main CI triggers
- crash-recoverable JSON persistence in the same repository

## Reliability — #42 Integrated
Issue #41 completed.

Merged main:
`379f58caf34f2206556246beb94e27a2c85ece78`

Pre-merge:
- Fast CI `33012747019`: success
- Android `33012747020`: success

Post-merge:
- Fast CI `33014440255`: success
- Android `33014440247`: success

## Date Range UI — #47 Integrated
Issue #46 completed.

Exact PR head:
`10f6d1dc0e288f4a46552a54ad7bfa808c9ccd7e`

Pre-merge:
- Fast CI `33014650334`: success
- Android `33014650363`: success
- live mergeability: true

Merged as current main:
`453a77a9e662f705bed8f899a769b425927bebb4`

Post-merge current-main proof:
- Fast CI `33015057876`: success
- Android `33015057863`: success

## Active Product — PR #49 / Issue #48
`feat(capture): add optional occurredAt for Event and Activity`

Branch:
`feature/quick-capture-occurred-at`

Exact head at this snapshot:
`20597e134e08dcb4a6b1c910ed8d38cdbd99ee6b`

Foundation is reused, not rebuilt:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- `QuickCapture.capture(occurredAt: ...)`

Added only UI/composition + focused widget tests:
- Event/Activity optional date + time
- clear selected date/time
- hidden occurredAt state cleared when switching to unsupported type
- Note/Call/Idea current fast capture path remains

Current exact-head gates:
- Fast CI `33015406333`: success
- Android `33015406042`: in progress

Do not merge until Android is success and a final live head/mergeability read is safe.

## Docs
Old PR #43 was closed without merge because it was stale.
Replacement PR #50 is Draft while #49 is active.

Branch:
`docs/current-state-after-reliability`

After #49 settles, sync this branch onto final main, refresh the snapshot, mark ready, validate exact head and merge safely.

## Ruleset — #19
`main-protection` still does not contain a required-status-check rule.

Until real Ruleset write capability exists:
`exact-head Green CI/Build + live mergeability + expected-head lock` is mandatory.

## ادامه کار
1. Finish #49 Android exact-head gate.
2. If Green, final-read #49 head/mergeability and merge safely.
3. Validate new main.
4. Final-sync/validate/merge Draft docs PR #50.
5. Fresh-audit the next product gap; do not create duplicate foundations.
6. Keep #19 open until actual platform enforcement is writable and proven.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
