# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `71d1d993e362be898be955963653eff832a7da0a`

Main has one shared Timeline stack:
- Quick Capture → real JSON persistence → Timeline → View/Edit
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- optional Event/Activity occurredAt capture
- card registration/occurrence time through `timelineAt`
- edit/clear occurredAt
- edit Timeline item type via the same `EditTimelineItem`
- crash-recoverable JSON persistence
- Fast CI + Android APK build/verify/upload

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Recently Integrated
### PR #56 / Issue #55 — Timeline Type Edit
Merged safely as current main `71d1d993e362be898be955963653eff832a7da0a` using expected-head lock.

Exact PR head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`
- pre-merge CI `33017606387`: success
- pre-merge Android `33017606312`: success
- live mergeability before merge: true
- post-main CI `33017911498`: success
- post-main Android `33017911496`: success

## Active Product — PR #61 / Issue #57
PR #61: `feat(timeline): delete items with confirmation`  
Branch: `feature/delete-timeline-item-final`  
Current exact head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`  
Base: current main `71d1d993e362be898be955963653eff832a7da0a`

Final product behavior:
- `deleteById` added to the existing `TimelineRepository`
- `JsonFileTimelineRepository` reuses the existing crash-safe `_readAll → _writeAll` path
- no schema bump, no second storage, no soft-delete foundation
- small `DeleteTimelineItem` application use case
- production wiring uses the shared repository
- delete is inside the existing Edit dialog with explicit Persian confirmation
- successful delete reloads through the existing Search/Type/Date state path

Coverage:
- application delete normalization/success/missing/invalid-id
- real temp-file persistent delete + no stale `.tmp`/`.bak`
- deleted id absent after repository reload
- missing-id delete does not stage a write
- widget confirmation/cancel/success
- combined proof that Search + Type + Date state survives delete reload
- all legacy repository test doubles satisfy the expanded contract

## Validation History / Automation Incident
PR #58 originally carried the slice. CI found exactly two old test doubles missing `deleteById`; both were fixed. Later exact-head Fast CI and Android were Green on an intermediate head, but a final filter-state regression test changed the head, so that evidence became historical only.

PR #60 then carried the exact final tree for fresh validation, but raw GitHub PR API remained `mergeable_state: unknown` and no new `pull_request` workflow run registered.

PR #61 carries the same reviewed final tree squashed directly onto current main as a clean commit history. A normal Contents API test commit was added to stimulate a fresh synchronize event. Historical Green remains invalid for the new head.

Do not merge #61 until current exact-head `YadNegar CI` and `YadNegar Android Build` both succeed and live mergeability is true.

## Automation — Issue #62
Issue #62 tracks delayed PR merge-ref/workflow registration.
Fresh evidence:
- workflow definitions on main are valid and target PRs to main
- Actions is globally active; docs PR #50 received a successful PR CI run in the same period
- affected delete carriers intermittently remain `mergeable_state: unknown` without exact-head workflow registration
- no workflow-dispatch action is exposed by the current GitHub connector

Gate must not be bypassed. No local/fake evidence substitutes for GitHub exact-head gates.

## Next Product — Issue #59
`feat(timeline): allow undo after item deletion`

Fresh audit found no duplicate Undo path. Planned implementation reuses existing `upsert(...)` to restore the just-deleted in-memory item through a Persian Snackbar action. No soft-delete/tombstone/new storage/schema foundation.

Do not create the #59 product branch until #61 settles on verified main.

## Documentation Lane — PR #50
PR #50 remains Draft while product state is moving. It is updated in parallel, but before merge its branch must be structurally synchronized onto final main, freshly audited and exact-head validated.

## Ruleset — Issue #19
`main-protection` remains active with PR/deletion/non-fast-forward rules but no required-status-check rule. Current connector exposes Ruleset read only.

Operational merge contract:
`exact current head + Green exact-head CI + Green exact-head Android + live mergeability + expected_head_sha lock + post-main proof`

## Parallel Speed Rules
- verified useful software in hours through coordinated independent lanes
- implementation, CI/automation and docs move simultaneously
- one blocked lane does not stop independent work
- reuse before rebuild
- no duplicate foundations
- no fake build/test/persistence evidence
- no stale merge evidence

## Next Actions
1. Fresh-read exact-head workflow registration and mergeability for PR #61 head `b10f3d2...`.
2. If GitHub registers gates, inspect exact-head CI + Android and fix only real failures.
3. Merge only after both Green + live mergeability true, using expected-head lock.
4. Validate resulting main with push CI + Android proof.
5. Start Issue #59 from that verified main while final-syncing PR #50.
6. Keep #62 open until PR workflow registration is reproducibly healthy.
7. Keep #19 open until required-status enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
