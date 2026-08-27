# YadNegar — Reminder Active State

Last updated: 2026-08-27

GitHub Reality is the Source of Truth. Fresh-audit exact refs before every status or merge claim.

## Verified main
`fceb383aad507eed354d4b044e3939aacf5328d0`

PR #76 / Issue #75 are completed. Main now contains optional `reminderAt` on the shared TimelineItem and backward-compatible JSON schema v2. Post-main proof on this exact main:
- YadNegar CI `33046893279`: success
- YadNegar Android Build `33046893295`: success, including APK build/verify/upload

## Active Product — Issue #77 / PR #78
Branch: `feature/timeline-reminder-notifications`

Goal: Persian reminder UI + real Android local notifications without a second Reminder repository/storage.

Backbone exact head `0b0a06c4ae12a6be06b5999bfbdd7382385ff653` proved:
- YadNegar CI `33048239297`: success
- YadNegar Android Build `33048239299`: success, including APK build/verify/upload
- Flutter 3.35 resolved `flutter_local_notifications 19.5.0` and `timezone 0.10.1`
- Android uses inexact scheduling, so exact-alarm permission is intentionally not part of MVP
- startup/Restore reconciliation reuses persisted Timeline data; no sidecar Reminder database exists

Current UI head: `8cb11187029d1d08d72fe523fbc3f48353b737ce`
- Persian set/clear Reminder controls are wired into Quick Capture/Edit
- schedule/cancel happens only after durable persistence succeeds
- delete cancels and Undo reschedules
- text edits reschedule to avoid stale notification body
- permission/scheduler failures report Persian feedback without rolling back user data
- focused widget tests cover persistence-first scheduling, clear/cancel, text refresh, permission denial, delete/Undo
- exact-head CI/Android for this UI head are currently running; do not reuse Backbone Green as merge evidence

## Lockfile
`pubspec.lock` is intentionally not guessed. Backbone CI resolved 11 dependency changes. Final lockfile must be generated from the real Flutter 3.35 resolution and committed before final merge; after that all gates rerun on the final head.

## Automation
Issue #19 remains open. The active main ruleset requires PRs and blocks deletion/non-fast-forward changes, but it still has no required-status-check rule and the connected GitHub tool exposes ruleset read only.

## Merge contract
`exact current head + exact-head CI + exact-head Android + live mergeability + expected_head_sha + post-main proof`

## Next
1. Finish UI-head tests.
2. Generate and commit the exact real lockfile.
3. Rerun CI + Android on final head.
4. Merge PR #78 only with exact-head lock.
5. Post-main proof, then structurally refresh canonical docs and remove this temporary active-state file.
