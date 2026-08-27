# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `dc58de0e9d4b6aaa90a800a894404e9db86cf4f5`

Main includes the completed non-mutating Release Governance chain plus the recurring-reminder data foundation.

## Release Baseline — Stable
Verified chain:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

Current release status remains:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

No real tag, GitHub Release, Play Store publish, production keystore or signing secret has been created by this chain.

## Recurring Reminder Wave — Issue #93
Parent issue:
`#93 product: add safe recurring reminders on the existing Timeline`

The wave is split into two small reusable slices:
- #94 / PR #96 — recurrence contract + schema-v3 migration
- #95 / PR #97 — Android recurrence scheduling + Persian UX

### Completed Foundation — PR #96 / Issue #94
Final exact PR head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

Integrated behavior:
- `TimelineReminderRecurrence { none, daily, weekly }` on the existing Timeline item
- recurrence defaults/normalizes to `none` without a reminder
- QuickCapture/Edit persistence contract extended
- JSON schema v3
- backward-compatible v1/v2 reads
- no read-time rewrite
- next safe write upgrades old data through the existing tmp/bak recovery path
- focused migration/application tests
- no new Reminder database/repository/storage/scheduler/UI foundation

Pre-merge exact-head proof:
- Fast CI `33078963061`: success
- Android `33078963046`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

Merged with exact expected-head lock to current main `dc58de0e...`.

Post-main proof:
- Fast CI `33079988610`: success
- Android `33079988616`: fully Green on fresh read
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

Issue #94 is expected to be closed/completed by the merged PR.

### Active Scheduler + UX — PR #97 / Issue #95
Branch:
`product/recurring-reminder-scheduler-ux`

Exact current head at this documentation revision:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

Fresh compare against integrated main proves the product scope is limited to:
- existing Android local reminder scheduler
- existing Quick Capture/Edit reminder controls
- app timezone initialization
- one timezone dependency
- existing reminder-flow tests

Implemented behavior:
- one-shot (`none`) behavior preserved
- daily recurrence at device-local clock time
- weekly recurrence at device-local weekday + clock time
- recurring anchors that are already past advance to the next future occurrence
- device IANA timezone is resolved before startup/Restore reconciliation
- recurrence fails closed if local timezone cannot be resolved
- persisted data remains intact if scheduling fails
- Persian options: `بدون تکرار / روزانه / هفتگی`
- recurrence selector only appears when a reminder exists
- persist-first create/edit behavior preserved
- clearing a reminder clears recurrence
- delete/Undo retains cancel/reschedule behavior
- no exact-alarm permission

Exact-head validation:
- Fast CI `33080762656`: success
- Android `33080762586`: active at this documentation revision

Do not report PR #97 Android/release gates Green until a fresh read proves completion.

## Product / Data Foundation
One shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3.  
Backward compatibility: v1 + v2 reads remain supported.

No duplicate Timeline model/repository/storage/AppShell/Reminder database exists.

## Automation Gap — Issue #19
Issue #19 remains open.

Live Ruleset requires PR and blocks deletion/non-fast-forward, but required status checks are not Platform-level enforced. Connected tooling still exposes Ruleset read without Ruleset write.

Until real enforcement is writable:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## Parallel Speed Rules
- Product / Release / Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- stacked preparation requires fresh compare proving isolated scope
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Fresh-read PR #97 Android chain on head `79bc8d84...`.
2. If Green, fresh-read PR #97 head + mergeability and merge only with exact `expected_head_sha`.
3. Verify #97 post-main Fast CI + Android/relevant gates.
4. Final-refresh recurring-reminder docs from the actual post-main outcome.
5. Close parent #93 only after product + post-main + docs are complete.
6. Keep #19 open until required-check enforcement is genuinely writable.
7. Production signing and real tag/release/publish remain separate owner/security decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
