# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green is never evidence for a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Verified main SHA: `59eea7a8451e646145d027629f07a110e50ffbf2`

This main includes merged PR #81: `release: add deterministic Android release-candidate artifact gate`.

Exact PR #81 final head:
`b0e3bf3e2846eb22ed8ae71d7676a2ae8fb9d024`

Pre-merge exact-head proof:
- YadNegar CI / `quality` run `33051771284`: success
- YadNegar Android Build / `android-build` run `33051771332`: success

Post-main proof on `59eea7a8451e646145d027629f07a110e50ffbf2`:
- YadNegar CI / `quality` run `33066010366`: success
- YadNegar Android Build / `android-build` run `33066010346`: success
- debug APK gate: success
- release-mode candidate APK gate: success

Release candidate evidence includes non-empty APK verification plus SHA-256 and byte-size output. Current Android `release` buildType still uses the debug signing config, so this artifact is **not production-signed** and is not Play-Store-ready.

## Verified Product Baseline
Main keeps one shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore → Reminder scheduling`

Current verified capabilities include:
- Note / Event / Call / Idea / Activity on one `TimelineItem`
- Persian RTL UI
- crash-recoverable schema-versioned JSON persistence
- Search + Type + Date Range
- optional `occurredAt`
- safe Delete + Undo
- visible Timeline export
- validated Backup + safe Restore
- schema-v2 optional `reminderAt` with backward-compatible v1 reads
- Persian Reminder UX
- Android local notifications
- startup / post-Restore Reminder reconciliation
- Fast CI
- Android debug APK artifact
- Android release-mode candidate artifact + reproducibility evidence

No duplicate Timeline model/repository/storage/AppShell/Reminder database exists.

## Completed Foundations — Do Not Recreate
- PR #81 / Issue #80 — release-candidate artifact gate
- PR #78 / Issue #77 — Persian Reminder UI + local notifications
- PR #76 / Issue #75 — schema-v2 Reminder contract
- PR #73 / Issue #70 — validated Restore
- PR #68 / Issue #67 — portable Backup
- PR #65 / Issue #64 — visible Timeline Export
- PR #63 / Issue #59 — Undo
- PR #61 / Issue #57 — safe Delete
- PR #56 / Issue #55 — edit Type
- PR #54 / Issue #53 — edit/clear occurredAt
- PR #52 / Issue #51 — Timeline date context
- PR #49 / Issue #48 — Quick Capture occurredAt
- PR #47 / Issue #46 — Date Range UI
- PR #42 / Issue #41 — crash-recoverable persistence
- PR #45 — CI duplicate-run reduction
- PR #44 — typography

## Active Release Lane — Issue #82 / PR #83
Roadmap Wave 7 remains:
`E2E + build + artifact + smoke + recovery`

Issue #82 / PR #83:
`release: prove Android emulator smoke and storage recovery`

Branch:
`release/android-emulator-smoke-recovery`

Current exact head:
`1ffe17bd45b7dbaae5e75ab730fe21579b3267f7`

Current exact-head runs:
- YadNegar CI run `33067893613`
- YadNegar Android Build run `33067893659`

At the time of this documentation update both are active and **must not be reported as Green until a fresh read confirms completion**.

PR #83 scope:
- reuse the existing Android workflow; no duplicate workflow
- consume the exact current-run debug APK
- boot Android emulator
- install and launch `com.mobinpda.lab.yadnegar/.MainActivity`
- seed a valid schema-v2 `timeline.json` through Android `run-as`
- force-stop the app
- simulate missing-primary + valid `.bak` recovery state
- relaunch and prove the production repository startup path restores primary storage
- preserve the seeded Timeline marker
- prove `.bak` / `.tmp` staging cleanup
- upload logcat, activity/storage and screenshot evidence
- fail on YadNegar crash-buffer evidence

CI safety:
Release branches are intentionally not added to Android `push` triggers, so PR validation stays on `pull_request` and does not reintroduce the duplicate push/PR pattern addressed by PR #45.

## Automation Gap
Issue #19 remains open.

Live repository Ruleset `main-protection` currently protects `main` from deletion/non-fast-forward and requires PRs, but required status checks are still not configured at the platform Ruleset level. Connected tooling currently exposes Ruleset read but not Ruleset write.

Until that changes, operational merge safety remains:
`exact current head + exact-head quality Green + exact-head android-build Green for Product/Release + relevant job/artifact Green + live mergeability + expected_head_sha + post-main proof`

Do not claim platform enforcement that is not actually configured.

## Parallel Speed Rules
- Product / Release / CI-Automation / Docs move simultaneously when independent
- blocked runners do not stop independent work
- reuse before rebuild
- small reversible PRs
- no fake evidence
- no stale merge evidence
- no duplicate foundation/workflow/storage
- documentation moves with implementation

## Next Actions
1. Fresh-read PR #83 exact head and both workflow runs.
2. Require `quality`, `android-build`, and `android-smoke-recovery` success on the same head.
3. Inspect smoke evidence if the emulator job fails; fix only the smallest real cause.
4. When all exact-head gates are Green, fresh-read PR mergeability and merge only with `expected_head_sha=1ffe17bd45b7dbaae5e75ab730fe21579b3267f7` if the head has not moved.
5. Verify resulting `main` checks and smoke/recovery proof after merge.
6. Close Issue #82 through PR #83 integration and refresh canonical docs.
7. Keep Issue #19 open until Ruleset required-status enforcement is genuinely writable and verified.
8. Production signing/release governance remains a separate security-sensitive slice after a fresh signing audit.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
