# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Main now includes the completed recurring-reminder product wave on top of the existing Timeline and release-governance foundations.

## Recurring Reminder Wave — Issue #93
The wave was implemented in two reusable slices:
- #94 / PR #96 — recurrence contract + schema-v3 migration
- #95 / PR #97 — Android recurrence scheduling + Persian UX

### PR #96 / Issue #94 — Completed
Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

Integrated:
- `TimelineReminderRecurrence { none, daily, weekly }`
- JSON schema v3
- backward-compatible v1/v2 reads
- no read-time rewrite
- safe-write upgrade through existing tmp/bak recovery
- existing Timeline repository/storage/application path reused

Pre-merge proof:
- Fast CI `33078963061`: success
- Android `33078963046`: success

Post-main proof on `dc58de0e9d4b6aaa90a800a894404e9db86cf4f5`:
- Fast CI `33079988610`: success
- Android `33079988616`: success

### PR #97 / Issue #95 — Completed
Final head:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

Integrated behavior:
- one-shot (`none`) preserved
- daily recurrence at device-local clock time
- weekly recurrence at device-local weekday + clock time
- past recurring anchors advance to the next valid future occurrence
- device IANA timezone resolved before startup/Restore reconciliation
- recurrence fails closed if timezone cannot be resolved
- persisted data is never rolled back because notification scheduling fails
- Persian choices: `بدون تکرار / روزانه / هفتگی`
- recurrence controls appear only when a reminder exists
- persist-first create/edit and delete/Undo cancel/reschedule behavior preserved
- no exact-alarm permission

Pre-merge exact-head proof:
- Fast CI `33080762656`: success
- Android `33080762586`: success

Merged to current main:
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Post-main proof:
- Fast CI `33081668902`: success
- Android `33081668913`: success

## Product / Data Foundation
Main flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3.  
Backward compatibility: v1 + v2 reads remain supported.

No duplicate Timeline model/repository/storage/AppShell/Reminder database/scheduler exists.

## Release Baseline — Stable
Verified chain:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

Release status remains:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

No real tag, GitHub Release, Play Store publish, production keystore or signing secret has been created.

## Automation Gap — Issue #19
Issue #19 remains open.

Live protection requires PR and blocks deletion/non-fast-forward, but required status checks are not Platform-level enforced. Connected tooling still exposes Ruleset read without Ruleset write.

Until real enforcement is writable:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## Active Documentation — PR #98
PR #98 is the final docs-only synchronization for the recurring-reminder wave.

Required final gate:
1. exact current docs head
2. exact-head Fast CI Green
3. live mergeability=true
4. merge with exact `expected_head_sha`
5. post-main Fast CI proof
6. close parent Issue #93 only after that proof

## Next Product Slice — Issue #99
`product: surface reminder status on Timeline cards`

Planned scope is presentation-only reuse of existing `TimelineItem.reminderAt` and recurrence fields:
- no reminder => no reminder summary
- one-shot => date/time summary
- daily => `روزانه` + clock time
- weekly => `هفتگی` + weekday/clock summary
- focused TimelineScreen widget tests

No schema/repository/storage/scheduler/navigation foundation change is planned.

Implementation starts after #93 is fully closed.

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
1. Finish exact-head gate and merge PR #98.
2. Verify PR #98 post-main Fast CI.
3. Close parent Issue #93.
4. Start Issue #99 as a small presentation-only PR from fresh main.
5. Keep Issue #19 open until required-check enforcement is genuinely writable.
6. Production signing and real tag/release/publish remain separate owner/security decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
