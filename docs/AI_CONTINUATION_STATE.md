# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `9e31b6e4db22ca5d9a34231eb4205f01027d0655`

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
- copy visible Timeline items as readable Persian text
- create and share a validated portable JSON backup snapshot
- Fast CI + Android APK build/verify/upload

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Integrated — PR #69
`feat(ui): add Bismillah to home header`

Exact pre-merge head: `e3d485b5df4686224a2358855a3754707f794a59`
- CI `33041625126`: success after same-head rerun of one flaky legacy widget timeout
- Android `33041625147`: success
- live mergeability: true
- expected-head merge lock used

Merged main: `14bfd37a7304841db74133f5fd6524535350e49a`
Post-main CI `33041864865`: success  
Post-main Android `33041864841`: success

## Integrated — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Exact final pre-merge head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
- CI `33042505480`: success
- Android `33042505505`: success
- final lockfile on exact head
- live mergeability: true
- expected-head merge lock used

Merged main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`
Post-main CI `33042973852`: success  
Post-main Android `33042973848`: success, including APK build/verify/upload.

Backup reuses production recovery/parser/serializer, creates no second schema/storage, supports empty Timeline backup, and exact-pins `share_plus 10.1.4` for Flutter 3.35.
Issue #67 is closed completed.

## Integrated — PR #72
`docs: reconcile Backup, Bismillah and Restore next state`

Exact head: `9689dd3f48097fa74e0fc7f1d669232d39d4afe7`
- docs-only diff across the three canonical documents
- exact-head Fast CI `33043437075`: success
- live mergeability true
- merged with expected-head lock

Current main after Docs merge: `9e31b6e4db22ca5d9a34231eb4205f01027d0655`
Post-main Fast CI `33044169143`: success.

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

## Active Product — PR #73 / Issue #70
`feat(restore): validate and restore Timeline snapshots safely`

Branch: `feature/timeline-restore-import`
Current exact head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`
Status: Draft until final exact-head CI + Android proof.

Implemented:
- strict UTF-8 + JSON/schema validation before primary storage changes
- typed unsupported-schema and duplicate-id rejection
- invalid/blank/malformed/duplicate backup leaves primary bytes unchanged
- existing production parser reused through `_decodeItems`
- existing `_writeAll` staged `.tmp` / `.bak` replacement and rollback reused
- no `TimelineRepository` Domain contract change
- no second parser/serializer/storage
- platform file selection remains in composition edge
- exact-pinned `file_picker 8.3.7`
- Persian confirmation before replacement
- Persian success / invalid / unsupported / duplicate / failure feedback
- successful Restore calls existing `TimelineHome._reload()` and preserves active Search/Type/Date state
- Bismillah, Backup and Export actions remain intact

Tests:
- real-file valid restore
- malformed JSON rejection with unchanged primary
- unsupported schema rejection with unchanged primary
- duplicate ID rejection with unchanged primary
- blank/invalid UTF-8 rejection
- widget confirmation cancel
- successful reload while active search remains applied
- unsupported-version Persian feedback

Dependency proof:
- pre-lock head `f04419ee...` CI `33044782989`: success
- Analyze clean; 93 tests passed
- Flutter 3.35 resolution added `file_picker 8.3.7` and `flutter_plugin_android_lifecycle 2.0.34`
- final lockfile committed on current head `fa8cfb284...`

Final exact-head gates now required on `fa8cfb284...`:
- YadNegar CI `33045126480`: active at last refresh
- YadNegar Android Build `33045126515`: active at last refresh

Do not merge using pre-lock Green evidence.

## Active Documentation Lane
Branch: `docs/current-state-restore-active`

This lane tracks PR #73 in parallel without blocking Product. Keep it unmerged while Product is active. After Product merge/post-main proof:
1. structurally sync onto resulting main
2. refresh exact final evidence
3. ensure docs-only diff
4. exact-head Fast CI
5. live mergeability + expected-head lock
6. post-main Fast CI

## Automation
Issue #62 remains closed/recovered.
Issue #19 remains open: Platform-level required status checks are not currently writable/proven through connected tooling.

Operational merge contract:
`exact current head + exact-head CI Green + exact-head Android Green for product + live mergeability + expected_head_sha lock + post-main proof`

Historical Green is never reused for a new head.

## Parallel Speed Rules
- verified software in hours through coordinated independent lanes
- Product / Automation / Documentation move simultaneously when independent
- blocked runners do not stop independent work
- reuse before rebuild
- batch related changes to avoid unnecessary duplicate CI runs
- no fake build/test/persistence evidence
- no stale merge evidence
- no stale canonical docs

## Next Actions
1. Fresh-read CI + Android on final PR #73 head `fa8cfb284...`.
2. Fix only evidence-backed failures if any.
3. Green → Ready → Fresh head/mergeability → expected-head merge.
4. Verify resulting main with CI + Android and confirm Issue #70 closure.
5. Final-sync this Docs lane and merge with docs-only Fast CI.
6. Fresh-audit the next real product gap; keep #19 open until enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
