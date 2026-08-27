# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

Main contains the completed recurring-reminder foundation plus direct reminder-status presentation on Timeline cards.

## Completed Recurring Reminder Wave — Issue #93
- #94 / PR #96 — recurrence contract + JSON schema v3 migration
- #95 / PR #97 — device-local daily/weekly Android scheduling + Persian UX
- #98 — final recurring-reminder documentation synchronization
- Parent #93 — closed/completed

Key safety remains:
- one Timeline model/repository/storage path
- one Reminder scheduler path
- backward-compatible v1/v2 reads with current schema v3
- persist-first mutations
- recurrence fails closed if timezone cannot be resolved
- no exact-alarm permission

## Timeline Reminder Status — Issue #99 / PR #100
Final product head:
`32fd20609daa8d6fea74c325fecb14e096c0106d`

Merged with exact expected-head lock to current main:
`8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

Fresh product compare was limited to:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_status_test.dart`

Integrated behavior:
- no reminder => no reminder row
- one-shot => reminder date/time
- daily => Persian `روزانه` + clock time
- weekly => Persian `هفتگی` + Persian weekday + clock time
- existing item type + Timeline timestamp stay visible

Exact-head pre-merge proof:
- Fast CI `33086840280`: success
- Android `33086840284`: success
  - Build/Candidate: success
  - emulator Smoke/Recovery: success
  - Release Readiness: success
  - deterministic Release Draft: success
  - Approval/Rollback evidence: success

Post-main proof on exact main `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`:
- Fast CI `33087745543`: success
- Android `33087745462`: success
  - Build/Candidate: success
  - emulator Smoke/Recovery: success
  - Release Readiness: success
  - deterministic Release Draft: success
  - Approval/Rollback evidence: success

Issue #99 closes only after this documentation synchronization is integrated and verified.

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

Live protection requires PR and blocks deletion/non-fast-forward, but required status checks are not Platform-level enforced. Connected tooling exposes Ruleset read without Ruleset write.

Until real enforcement is writable:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## Active Documentation
Branch: `docs/timeline-reminder-status-live`

Purpose: synchronize the four live/canonical project documents with the completed #99 / PR #100 outcome and exact post-main evidence.

Docs-only merge contract:
1. exact current docs head
2. exact-head Fast CI Green
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI proof
6. close #99 only after that proof

## Maximum Parallel Rules
- Product / Release / Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- stacked preparation requires fresh compare proving isolated scope
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Integrate this docs synchronization with exact-head evidence.
2. Verify docs post-main Fast CI.
3. Close Issue #99 as completed.
4. Fresh-audit existing Timeline filter architecture and open the next small reuse-first product slice only if scope is isolated.
5. Keep Issue #19 open until required-check enforcement is genuinely writable.
6. Production signing and real tag/release/publish remain separate Owner/Security decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
