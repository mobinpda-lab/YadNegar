# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `740c290f8c2c3104dbca6518ee8c3de54b9abc51`

Main currently provides one shared Timeline stack:
- Quick Capture → real JSON persistence → Timeline → View/Edit
- Note/Event/Call/Idea/Activity on one `TimelineItem`
- Search + Type + Date Range retrieval
- optional Event/Activity occurredAt capture
- Timeline card registration/occurrence time context through `timelineAt`
- Event/Activity edit can replace or clear occurredAt through the existing Edit use case
- crash-recoverable JSON persistence
- Fast CI + Android APK build/verify/upload automation

No duplicate Timeline Model / Repository / Storage / App Shell exists.

## Recently Integrated
### PR #52 / Issue #51
Timeline date/time card context integrated as `6e379f4de11edfd323f79861b04b16992ee6f614`.

Pre-merge:
- CI `33016029795`: success
- Android `33016029822`: success

Post-merge:
- CI `33016376693`: success
- Android `33016376667`: success

### PR #54 / Issue #53
Event/Activity occurredAt editing integrated as current main `740c290f8c2c3104dbca6518ee8c3de54b9abc51` using expected-head lock.

Exact PR head: `183cddb533b58284c534ad2dacee74b88d6dbaff`

Pre-merge:
- CI `33016928847`: success
- Android `33016928837`: success
- live mergeability before merge: true

Post-merge current-main proof at this snapshot:
- CI `33017214825`: success
- Android `33017214826`: in progress

Integrated behavior:
- same `EditTimelineItem` extended; `updateText` remains compatible
- Event/Activity can replace or explicitly clear occurredAt
- Note/Call/Idea remain text-only for this wave
- no Domain/Repository/Storage/Schema/dependency change

Issue #53 is completed.

## Active Product PR — #56 / Issue #55
PR #56: `feat(edit): allow Timeline item type changes`  
Branch: `feature/edit-item-type`  
Current exact head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`  
Base: current main `740c290f8c2c3104dbca6518ee8c3de54b9abc51`

Scope:
- extend the same Edit use case with optional type replacement
- Edit dialog can correct Note/Event/Call/Idea/Activity type
- switching Event/Activity to a non-occurredAt type clears hidden occurredAt
- switching to Event/Activity keeps the existing occurredAt controls available
- application/widget regression tests
- no Model/Repository/Storage/Schema/dependency change

Automation note at this snapshot:
- PR is open
- no check runs were yet registered for the latest head after the initial opened/synchronize events
- do not treat it as Green until exact-head CI + Android runs actually exist and succeed

## Documentation Lane — PR #50
Stale PR #43 was closed without merge.
PR #50 is the replacement documentation PR.

Branch `docs/current-state-after-reliability` is synchronized onto current main `740c290...` and tracks active #56. It stays Draft while product work is moving so it does not merge stale.

## Ruleset — Issue #19
Fresh Ruleset audit still shows `main-protection` active for main with deletion/non-fast-forward/PR rules, but no required-status-check rule.

Fresh connector discovery still exposes Ruleset read only; no proven write action exists.

Operational merge contract remains:
`exact current head + Green exact-head CI + Green exact-head Android + live mergeability + expected_head_sha lock + post-main proof`

## Parallel Speed Rules
- produce verified software in hours through coordinated independent lanes
- implementation, CI automation and docs move in parallel
- a running Build must not block independent work
- reuse before rebuild
- no duplicate foundations
- no fake test/build/persistence evidence
- no stale merge evidence

## Next Actions
1. Finish post-main Android proof for #54.
2. Ensure #56 receives real exact-head CI + Android runs; investigate/trigger safely if they remain absent.
3. Merge #56 only after both gates are Green plus live head/mergeability read and expected-head lock.
4. Validate resulting main.
5. Final-sync/refresh PR #50 and safely merge documentation when product snapshot is stable.
6. Continue fresh gap audit in a non-conflicting lane.
7. Keep #19 open until Ruleset enforcement is genuinely writable and verified.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
