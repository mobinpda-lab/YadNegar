# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `dcdefb3155322b5d49972b196786e569bc541267`

Main has one shared Timeline stack:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo`

Capabilities:
- Note / Event / Call / Idea / Activity on one `TimelineItem`
- Persian RTL UI
- crash-recoverable schema-versioned JSON persistence
- Search + Type + Date Range
- occurredAt capture/edit for Event/Activity
- item type correction
- safe delete with Persian confirmation
- Undo after delete with conflict/no-overwrite protection
- Fast CI + Android APK build/verify/upload

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Integrated — PR #61 / Issue #57
Safe delete merged as `509817c344d014579e28f62d64ff8465b722f3b9`.

Exact pre-merge head `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`:
- CI `33020857429`: success
- Android `33020857455`: success
- live mergeability clean
- merge used expected-head lock

Post-main on `509817c...`:
- CI `33023724452`: success
- Android `33023724492`: success, including APK build/verify/upload

## Integrated — PR #63 / Issue #59
Undo deletion merged as current main `dcdefb3155322b5d49972b196786e569bc541267`.

Exact pre-merge head `373a1b8cf18016d27e01297abc70ff6034ef6d2c`:
- CI `33023943769`: success
- Android `33023943767`: success
- live mergeability: true / clean
- merge used `expected_head_sha=373a1b8...`

Post-main on `dcdefb3...`:
- CI `33024326747`: success
- Android `33024326787`: success
- Android build + verify + artifact upload: success

Integrated Undo behavior:
- small `RestoreTimelineItem` uses existing `findById + upsert`
- restores original id/type/text/createdAt/occurredAt from memory
- refuses restore if the id has already been reused, preventing overwrite of newer data
- Search/Type/Date state survives delete and Undo reload
- no Repository contract / schema / storage / tombstone / soft-delete foundation change

Issue #59 is closed completed.

## Automation
### Issue #62 — recovered / closed
Delayed PR merge-ref/workflow registration was investigated without bypassing gates.
PR #63 proved normal synchronize registration again on one exact head with both workflows and no carrier churn. Issue #62 is closed completed.

### Issue #19 — still open
Live `main-protection` Ruleset requires PR and blocks deletion/non-fast-forward, but has no required-status-check rule. Connected GitHub tooling still exposes Ruleset read only.

Operational merge contract remains:
`exact current head + Green exact-head CI + Green exact-head Android + live mergeability + expected_head_sha lock + post-main proof`

## Documentation — PR #50
PR #50 is the final documentation reconciliation lane.

Structural sync is complete: its branch contains current verified main `dcdefb3...` as a parent, so product code is not stale.
Live diff against main is exactly four documentation files:
- `README.md`
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`

Before docs merge, require exact-head `YadNegar CI` success and live mergeability + expected-head lock. Android is not expected for this docs-only diff because Android workflow path filters exclude README/docs.

## Next Product — Issue #64
`feat(export): copy Timeline export to clipboard`

Fresh Wave 6 audit:
- Comprehensive plan defines Wave 6 as Reminder / Backup / Export.
- no existing code for reminder/backup/export was found.
- current dependencies are Flutter + path_provider only.
- Reminder would introduce permission/scheduling and likely data-contract work.
- smallest low-risk vertical slice is user-facing Export using existing repository data and Flutter Clipboard, with no dependency/schema/storage changes.

Issue #64 is open. Product branch starts only after final docs synchronization.

## Parallel Speed Rules
- verified software in hours through coordinated independent lanes
- product, CI/automation and docs move simultaneously
- blocked runners do not stop independent work
- reuse before rebuild
- no duplicate foundations
- no fake build/test/persistence evidence
- no stale merge evidence

## Next Actions
1. Get exact-head Fast CI for final PR #50 docs head.
2. If Green, re-read live head/mergeability and merge #50 with expected-head lock.
3. Start Issue #64 from the verified resulting main.
4. Keep Issue #19 open until required status enforcement is genuinely writable and verified.
5. Reopen #62 only if workflow-registration symptoms recur.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
