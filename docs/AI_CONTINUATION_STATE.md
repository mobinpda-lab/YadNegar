# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `453a77a9e662f705bed8f899a769b425927bebb4`

Main contains one shared Timeline stack with:
- Quick Capture → real JSON persistence → Timeline → View/Edit
- `TimelineItemType` for Note/Event/Call/Idea/Activity
- `SearchTimeline` + Persian/RTL text/type retrieval UI
- `FilterTimelineByDateRange` + Persian/RTL date-range UI
- Vazirmatn typography with optional private licensed IRANSansX
- deduplicated CI triggers
- crash-recoverable JSON writes/recovery

No second Timeline Model / Repository / Storage / App Shell exists.

## Recent Integrated Work
### PR #44 — Typography
Merged.
- open-source Vazirmatn UI + Farsi Digits bundled
- licensed IRANSansX remains optional for private builds
- proprietary IRANSansX binaries are not committed publicly

### PR #45 — CI deduplication
Merged as `aaff41d1e287372e441ea6809bf61d06b49df44c`.
- feature PR quality validation uses `pull_request -> main`
- `push` quality remains on `main`
- duplicate feature push + PR quality runs are avoided

### PR #42 / Issue #41 — Crash-recoverable JSON persistence
Merged safely as `379f58caf34f2206556246beb94e27a2c85ece78` using exact-head lock.

Exact PR head:
`692c8519d6fc22c20671494ea5304f97babe935d`

Pre-merge validation:
- `YadNegar CI` Run `33012747019`: success
- `YadNegar Android Build` Run `33012747020`: success

Post-merge main proof:
- `YadNegar CI` Run `33014440255`: success
- `YadNegar Android Build` Run `33014440247`: success

Issue #41 is completed.

### PR #47 / Issue #46 — Timeline Date-range UI
Merged safely as current main `453a77a9e662f705bed8f899a769b425927bebb4` using expected-head lock.

Exact PR head:
`10f6d1dc0e288f4a46552a54ad7bfa808c9ccd7e`

Pre-merge exact-head validation:
- `YadNegar CI` Run `33014650334`: success
- `YadNegar Android Build` Run `33014650363`: success
- live mergeability immediately before merge: true

Post-merge current-main proof:
- `YadNegar CI` Run `33015057876`: success
- `YadNegar Android Build` Run `33015057863`: success

Integrated behavior:
- existing `FilterTimelineByDateRange` reused
- existing `SearchTimeline` reused
- same production `TimelineRepository` reused
- UI selected end day is inclusive while Application boundary remains end-exclusive
- Text + Type + Date compose without a duplicate query/storage path
- retrieval clear/reset and filtered empty state cover date filtering

Issue #46 is completed.

## Active Product PR — #49 / Issue #48
PR #49: `feat(capture): add optional occurredAt for Event and Activity`  
Branch: `feature/quick-capture-occurred-at`  
Exact head at this snapshot: `20597e134e08dcb4a6b1c910ed8d38cdbd99ee6b`  
Base: current main `453a77a9e662f705bed8f899a769b425927bebb4`  
Live mergeability last verified: true

Fresh audit proved the reusable foundation already existed:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- `QuickCapture.capture(occurredAt: ...)`

Implementation only extends Quick Capture UI/composition:
- optional Persian/RTL date + time for Event/Activity
- Note/Call/Idea keep the fast no-date capture path
- selected date/time can be cleared
- switching to a type without occurredAt support clears hidden draft state
- no Domain/Repository/Storage/Schema/dependency change

Widget coverage includes:
- existing Idea/default Note regression
- Event persisted with occurredAt
- Activity clear-date behavior
- Event → Idea clears occurredAt
- timelineAt resolves to occurredAt for the Event

Exact-head gates at this snapshot:
- `YadNegar CI` Run `33015406333`: success
- `YadNegar Android Build` Run `33015406042`: in progress

Do not merge #49 until Android is success and the live PR head/mergeability are re-read immediately before merge.

## Documentation Reality
Stale PR #43 was closed without merge and superseded by PR #50.

PR #50 is Draft intentionally while #49 is active. Branch:
`docs/current-state-after-reliability`

Final docs must be re-synchronized onto the final main after #49 settles, then exact-head validated before merge.

## Ruleset Reality — Issue #19
Active ruleset `main-protection` id `20952887`:
- requires Pull Requests
- protects deletion and non-fast-forward updates
- currently has no required-status-check rule

Issue #19 remains open. Current connector exposes Ruleset read but no Ruleset write action.

Operational merge contract until that gap is truly fixed:
`Exact current PR head + Green exact-head gates + live mergeability + expected_head_sha merge lock`

Never claim Required Status Check is configured unless a fresh Ruleset read proves it.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- feature-based structure
- Persian RTL-first
- reuse before rebuild
- no duplicate App Shell / Timeline Model / Repository / Storage
- UI consumes application contracts instead of duplicating business/data logic
- JSON persistence is real and replaceable, not fake persistence
- no fake build/test evidence
- independent lanes continue when another lane is blocked

## Next Real Actions
1. Finish exact-head Android validation for PR #49.
2. If both gates are Green, re-read exact head + mergeability and merge with expected-head lock.
3. Validate the new main with real Fast CI + Android proof.
4. Re-sync PR #50 docs to the final main, mark it ready, exact-head validate, and merge safely.
5. Select the next UI/product gap only after a fresh code/issue audit.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
