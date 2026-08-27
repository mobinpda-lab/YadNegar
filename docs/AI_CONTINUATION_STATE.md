# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

Main contains one shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore`

Capabilities:
- Note / Event / Call / Idea / Activity on one TimelineItem
- Persian RTL UI
- centered `بسم الله الرحمن الرحیم` above the YadNegar home title
- crash-recoverable schema-versioned JSON persistence
- Search + Type + Date Range
- occurredAt capture/edit for Event/Activity
- type correction
- safe delete with confirmation
- Undo with conflict/no-overwrite protection
- copy the currently visible Timeline items as readable Persian text
- create/share validated portable JSON backup snapshots
- restore validated snapshots with confirmation, rollback-safe replacement and filter-preserving reload
- Fast CI + Android APK build/verify/upload

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Integrated — PR #69
`feat(ui): add Bismillah to home header`

Exact pre-merge head: `e3d485b5df4686224a2358855a3754707f794a59`
- YadNegar CI `33041625126`: success after same-head rerun of one flaky legacy widget timeout
- YadNegar Android Build `33041625147`: success
- live mergeability: true
- merge used expected-head lock

Merged main: `14bfd37a7304841db74133f5fd6524535350e49a`

Post-main proof:
- YadNegar CI `33041864865`: success
- YadNegar Android Build `33041864841`: success

## Integrated — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Exact final pre-merge head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
- YadNegar CI `33042505480`: success
- YadNegar Android Build `33042505505`: success
- live mergeability: true
- final `pubspec.lock` committed on this exact head
- merge used `expected_head_sha`

Merged main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Backup design:
- concrete `JsonFileTimelineRepository` exposes validated snapshot bytes without changing the Domain repository contract
- existing recovery, parser and serializer are reused
- no second schema, serializer or storage path
- primary valid bytes are not mutated during backup
- empty Timeline still produces a valid schema-versioned backup without creating primary storage
- timestamped snapshot is written in temporary storage and revalidated with the production parser
- Backup action is exposed through a small Presentation Scope
- `share_plus 10.1.4` is exact-pinned for Flutter 3.35

Issue #67 is closed completed.

Post-main proof for `edf0c72...`:
- YadNegar CI `33042973852`: success
- YadNegar Android Build `33042973848`: success
- Android build / verify / artifact upload: success

## Integrated — PR #73 / Issue #70
`feat(restore): validate and restore Timeline snapshots safely`

Exact final pre-merge head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`
- YadNegar CI `33045126480`: success
- YadNegar Android Build `33045126515`: success
- live mergeability: true
- final `pubspec.lock` committed on this exact head
- merge used `expected_head_sha`

Merged main: `78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

Restore design:
- candidate JSON bytes are validated before any primary data change
- blank/invalid UTF-8/malformed JSON/unsupported schema/duplicate IDs are rejected
- production parser and existing `.tmp` / `.bak` staged replacement + rollback path are reused
- no raw overwrite, second serializer or second storage
- file selection stays at the platform/composition edge with exact-pinned `file_picker 8.3.7`
- Persian confirmation and result-specific feedback are provided
- successful restore reuses `TimelineHome._reload()` so active Search/Type/Date state is preserved
- Bismillah, Backup and Export actions remain intact

Issue #70 is closed completed.

Post-main proof for `78b14a8...`:
- YadNegar CI `33045454060`: success
- YadNegar Android Build `33045454024`: success

Restore wave is fully verified on merged main.

## Previously Integrated Product Foundations
- PR #65 / Issue #64 — visible Timeline Export
- PR #63 / Issue #59 — Undo deletion with no-overwrite protection
- PR #61 / Issue #57 — safe Delete
- PR #56 / Issue #55 — edit Timeline item type
- PR #54 / Issue #53 — edit/clear occurredAt
- PR #52 / Issue #51 — display effective Timeline time
- PR #49 / Issue #48 — optional occurredAt in Quick Capture
- PR #47 / Issue #46 — Date Range UI composed with Search/Type
- PR #42 / Issue #41 — crash-recoverable JSON persistence
- PR #45 — CI duplicate-run reduction
- PR #44 — Vazirmatn typography / optional licensed IRANSansX

Do not recreate these foundations.

## Documentation Lane — PR #74
Branch: `docs/current-state-restore-active`

The branch is structurally synchronized onto Restore main `78b14a8...`. Canonical history is retained; the temporary active Restore state file is removed during finalization. Merge sequence:
1. verify live diff is docs-only
2. exact-head Fast CI Green
3. Fresh-read head/mergeability
4. merge with expected-head lock
5. verify resulting docs-only main with Fast CI

## Automation
Issue #62 remains closed/recovered.

Issue #19 remains open. Main ruleset still has no writable Platform-level required status check through connected tooling.

Operational merge contract:
`exact current head + exact-head CI Green + exact-head Android Green for product + live mergeability + expected_head_sha lock + post-main proof`

Historical Green is never reused for a new head.

## Active Product — Issue #75 / PR #76
`feat(reminder): add safe reminder data contract with schema migration`

Fresh audit:
- the comprehensive roadmap defines Wave 6 as Reminder / Backup / Export
- Backup, Export and Restore are now integrated
- main `TimelineItem` has no reminder/scheduled field
- main JSON storage remains schema v1
- no Reminder/Notification implementation exists

Current Slice 1 contract:
- add optional `reminderAt` to the existing shared TimelineItem
- move production JSON writes to schema v2 while continuing to read v1
- v1 read is non-mutating; the next safe write upgrades to v2
- preserve reminderAt through parser/serializer/Backup/Restore/Edit
- keep timeline ordering unchanged
- no new dependency, notification plugin, permission or UI in this slice

Branch: `feature/timeline-reminder-contract`  
Draft PR: #76  
Current recorded head at docs refresh: `b79d2775d59f8212b2a8a754b6a75beb7640157c`

Reminder platform scheduling/UI is a separate follow-up slice after this data contract is exact-head CI + Android verified and merged.

## Parallel Speed Rules
- verified software in hours through coordinated independent lanes
- Product / Automation / Documentation move simultaneously when independent
- blocked runners do not stop independent work
- reuse before rebuild
- no duplicate foundations
- no fake build/test/persistence evidence
- no stale merge evidence
- no stale canonical docs

## Next Actions
1. Finish PR #74 with docs-only exact-head Fast CI and expected-head merge lock.
2. Validate PR #76 on its exact current head with YadNegar CI + Android Build.
3. If Green, Fresh-read mergeability and merge #76 with expected-head lock.
4. Verify post-main, then start Reminder UI/notification scheduling as the next audited slice.
5. Keep Issue #19 open until required status enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
