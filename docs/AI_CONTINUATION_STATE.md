# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `71d1d993e362be898be955963653eff832a7da0a`

Main provides one shared Timeline stack:
- Quick Capture → real JSON persistence → Timeline → View/Edit
- Note/Event/Call/Idea/Activity on one `TimelineItem`
- Search + Type + Date Range retrieval
- optional Event/Activity occurredAt capture
- Timeline card registration/occurrence time context through `timelineAt`
- Event/Activity edit can replace or clear occurredAt
- Edit can correct Timeline item type through the same `EditTimelineItem`
- crash-recoverable JSON persistence
- Fast CI + Android APK build/verify/upload automation

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Recently Integrated
### PR #54 / Issue #53 — occurredAt Edit
Merged safely as `740c290f8c2c3104dbca6518ee8c3de54b9abc51`.

Pre-merge exact-head:
- CI `33016928847`: success
- Android `33016928837`: success

Post-main:
- CI `33017214825`: success
- Android `33017214826`: success, including APK build + verify + upload

### PR #56 / Issue #55 — Timeline Type Edit
Merged safely as current main `71d1d993e362be898be955963653eff832a7da0a` using expected-head lock.

Exact PR head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`

Pre-merge exact-head:
- CI `33017606387`: success
- Android `33017606312`: success
- live mergeability immediately before merge: true

Post-main:
- CI `33017911498`: success
- Android `33017911496`: success

Integrated behavior:
- same `EditTimelineItem` extended; no parallel edit use case
- type can be corrected among Note/Event/Call/Idea/Activity
- changing Event/Activity to Note/Call/Idea clears hidden occurredAt
- changing to Event/Activity reuses existing occurredAt controls
- no Model/Repository/Storage/Schema/dependency change

Issue #55 is completed.

## Active Product PR — #58 / Issue #57
PR #58: `feat(timeline): delete items with confirmation`  
Branch: `feature/delete-timeline-item`  
Current exact head: `58bce967c3d28fcd70d117ab114ee4d24625166f`  
Base: current main `71d1d993e362be898be955963653eff832a7da0a`

Implementation:
- `deleteById` added to the existing `TimelineRepository`
- `JsonFileTimelineRepository` reuses the same crash-recoverable `_readAll → _writeAll` path
- no schema bump, no second storage, no soft-delete foundation
- small `DeleteTimelineItem` application use case
- production wiring uses the same shared repository
- deletion is exposed inside the existing Edit dialog with explicit Persian confirmation
- successful deletion reloads through the existing Timeline/filter state path
- application, real temp-file persistence, and widget tests added

Validation history:
- previous head `660edf9...`: Android Green, CI failed only because two older test fakes lacked the expanded `deleteById` interface
- CI logs identified exactly `timeline_edit_flow_test.dart` and `timeline_search_flow_test.dart`
- both test fakes have now been updated on current head `58bce967...`
- do not merge until fresh exact-head CI + Android runs exist and both succeed

## Documentation Lane — PR #50
PR #43 is closed stale history.
PR #50 remains the replacement documentation PR and intentionally stays Draft while #58 is active.

This docs branch tracks current main + active product reality. Before docs merge it must be synchronized onto the final product main, freshly audited, exact-head validated, then merged safely.

## Ruleset — Issue #19
Fresh Ruleset audit still shows `main-protection` active with PR/deletion/non-fast-forward rules but no required-status-check rule.

Connector discovery still exposes Ruleset read only; no proven write action exists.

Operational merge contract remains:
`exact current head + Green exact-head CI + Green exact-head Android + live mergeability + expected_head_sha lock + post-main proof`

## Parallel Speed Rules
- verified software in hours through coordinated independent lanes
- implementation, CI automation and docs move in parallel
- a running/failing Build must not stop independent work
- reuse before rebuild
- no duplicate foundations
- no fake test/build/persistence evidence
- no stale merge evidence

## Next Actions
1. Verify fresh exact-head CI + Android for PR #58 head `58bce967...`.
2. If any gate fails, fix only the real failing surface and rerun on the new exact head.
3. If both Green, re-read PR head + mergeability and merge #58 with expected-head lock.
4. Validate resulting main with Fast CI + Android proof.
5. Final-sync PR #50 onto the resulting stable main and merge docs only after exact-head validation.
6. Fresh-audit the next product gap without creating duplicate foundations.
7. Keep #19 open until Ruleset enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
