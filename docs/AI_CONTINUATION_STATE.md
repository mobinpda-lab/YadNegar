# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Main contains one shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup`

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
- create and share a validated portable JSON backup snapshot
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

UI contract:
- Bismillah is centered at the top of the AppBar
- smaller/lighter than the `یادنگار` title
- RTL and Export action remain intact

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
- `TimelineHome` remains untouched
- `share_plus 10.1.4` is exact-pinned for the repository's Flutter 3.35 toolchain
- Backup branch was structurally synchronized with Bismillah main through `529df3fd6656705fab3756a878c45d8ec2ed1bbc`

Issue #67 is closed completed.

Post-main proof for `edf0c72...`:
- YadNegar CI `33042973852`: success
- YadNegar Android Build `33042973848`: in progress in the latest Fresh Audit

Do not call Backup post-main fully verified until Android completes success on this exact main.

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

## Documentation Lane
Branch: `docs/current-state-backup-active`

The branch is structurally synchronized onto merged Backup main `edf0c72...`. Final documentation should retain the full canonical history while updating current-state sections. Before merge:
1. refresh final post-main Android evidence
2. ensure live diff is documentation-only
3. open a small Docs PR
4. require exact-head Fast CI
5. Fresh-read head/mergeability
6. merge with expected-head lock

## Automation
Issue #62 remains closed/recovered.

Issue #19 remains open. Main protection prevents unsafe branch operations, but Platform-level required status checks are still not writable through connected GitHub tooling.

Operational merge contract:
`exact current head + exact-head CI Green + exact-head Android Green for product + live mergeability + expected_head_sha lock + post-main proof`

Historical Green is never reused for a new head.

## Next Product — Issue #70
`feat(backup): restore a validated Timeline snapshot safely`

Fresh audit:
- no independent Restore/Import implementation exists
- no duplicate open Restore issue existed before #70
- Backup #68 intentionally excluded Restore
- production JSON parser/schema validation should be reused before any primary data change
- restore must preserve current data and roll back if final replacement fails
- direct raw file overwrite is prohibited
- platform file-selection boundary should stay outside Domain

No Restore feature branch should start until Backup post-main Fast CI + Android are both proven Green.

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
1. Fresh-read Android post-main run `33042973848` on `edf0c72...`.
2. If Green, mark Backup wave fully verified.
3. Final-refresh and merge the Docs lane with exact-head Fast CI + expected-head lock.
4. Start Issue #70 from the verified main and keep it as a separate validation/rollback slice.
5. Keep Issue #19 open until required status enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
