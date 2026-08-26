# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical project docs > exact CI/workflow evidence > conversation memory`

Before every write, merge, SHA/status claim, or progress claim: fresh-audit GitHub.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `6e379f4de11edfd323f79861b04b16992ee6f614`

Current main has one shared Timeline stack:
- Quick Capture → real JSON persistence → Timeline → View/Edit
- Note/Event/Call/Idea/Activity on one `TimelineItem` model
- Search + Type + Date Range retrieval
- optional Event/Activity `occurredAt` capture
- Timeline cards showing meaningful `timelineAt` context
- crash-recoverable JSON persistence
- Vazirmatn + optional private licensed IRANSansX
- deduplicated Fast CI + Android APK build automation

No second Timeline Model / Repository / Storage / App Shell exists.

## Recent Integrated Waves
### PR #49 / Issue #48 — Event/Activity occurredAt Capture
Merged as `16eb0e041cb6431c83bb9abc844d0291a5bc1cb4` with expected-head lock.

Exact PR head: `20597e134e08dcb4a6b1c910ed8d38cdbd99ee6b`

Pre-merge:
- YadNegar CI `33015406333`: success
- YadNegar Android Build `33015406042`: success

Post-merge main:
- YadNegar CI `33015801059`: success
- YadNegar Android Build `33015801063`: success

Issue #48 completed.

### PR #52 / Issue #51 — Timeline Date/Time Context
Merged as current main `6e379f4de11edfd323f79861b04b16992ee6f614` with expected-head lock.

Exact PR head: `3d082c19200f2b62dd70d382ea885277d17e9337`

Pre-merge:
- YadNegar CI `33016029795`: success
- YadNegar Android Build `33016029822`: success

Post-merge current-main proof:
- YadNegar CI `33016376693`: success
- YadNegar Android Build `33016376667`: success

Integrated behavior:
- Timeline cards reuse `timelineAt`
- items with occurredAt show occurrence context
- items without occurredAt fall back to createdAt registration context
- no Domain/Repository/Storage/dependency change

Issue #51 completed.

## Active Product PR — #54 / Issue #53
PR #54: `feat(edit): update Event and Activity occurredAt`  
Branch: `feature/edit-occurred-at`  
Exact head at this snapshot: `183cddb533b58284c534ad2dacee74b88d6dbaff`  
Base: current main `6e379f4de11edfd323f79861b04b16992ee6f614`

Fresh audit showed the reusable foundation already existed:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- existing `EditTimelineItem`
- existing Timeline occurredAt picker pattern

Implementation scope:
- extend existing `EditTimelineItem`; keep `updateText` compatible
- Event/Activity edit can replace or explicitly clear occurredAt
- Note/Call/Idea keep text-only edit behavior
- clearing occurredAt naturally falls back to createdAt through `timelineAt`
- application + widget regression tests
- no Domain/Repository/Storage/Schema/dependency change

Merge contract for #54:
1. exact-head YadNegar CI success
2. exact-head YadNegar Android Build success
3. live head + mergeability re-read
4. merge with `expected_head_sha`
5. post-merge main proof

## Documentation Reality
Stale PR #43 was closed without merge and superseded by PR #50.

PR #50 branch `docs/current-state-after-reliability` is synchronized onto current main #52 and tracks active PR #54. It intentionally stays Draft while #54 is active, then receives one final sync/update before exact-head validation and safe merge.

## Ruleset Reality — Issue #19
Active main protection still has no required-status-check rule.

Current connector exposes Ruleset read but no proven Ruleset write action. Until real platform enforcement is writable and verified:
`Exact current PR head + Green exact-head gates + live mergeability + expected_head_sha merge lock`

Never claim Required Status Check is configured without a fresh Ruleset read proving it.

## Architecture / Speed Rules
- Flutter / Dart, Persian RTL-first
- reuse before rebuild
- no duplicate App Shell / Timeline Model / Repository / Storage
- UI consumes Application contracts
- real persistence/build/test evidence only
- independent lanes continue when another lane is blocked
- documentation and automation move in parallel with implementation
- produce verified useful software in hours rather than days through coordinated parallel lanes, not by skipping gates

## Next Real Actions
1. Validate PR #54 exact head with Fast CI + Android Build.
2. If Green, live-read head/mergeability and merge with expected-head lock.
3. Validate new main with Fast CI + Android proof.
4. Final-sync PR #50 onto that main, refresh this snapshot and sibling docs, validate and merge docs safely.
5. Fresh-audit the next product gap and start an independent small vertical slice.
6. Keep Issue #19 open until Ruleset write is genuinely possible and proven.

## Trigger
`ادامه یادنگار`

## Owner Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
