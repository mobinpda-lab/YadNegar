# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `453a77a9e662f705bed8f899a769b425927bebb4`

Current main contains one shared Timeline stack with:
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
- feature PR quality runs use `pull_request -> main`
- branch `push` quality trigger is no longer duplicated for feature work
- `push` remains for `main`

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

Feature behavior:
- reuses existing `FilterTimelineByDateRange`
- reuses existing `SearchTimeline`
- reuses the same production `TimelineRepository`
- UI selected end day is inclusive while application boundary remains end-exclusive
- Text + Type + Date filters compose without a duplicate query/storage path
- clear/reset covers all retrieval filters
- filtered empty-result state covers date-only filtering

Widget coverage includes multi-day filtering, selected end-day inclusion, date + text, date + type, clear/reset, date-only empty state, and existing search/type regression behavior.

Issue #46 is completed.

Post-merge validation on current main:
- `YadNegar CI` Run `33015057876`: running at this snapshot
- `YadNegar Android Build` Run `33015057863`: running at this snapshot

Do not convert these post-merge runs to `success` in documentation until a fresh read confirms completion.

## Next Verified Product Gap — Issue #48
Issue #48: `feat(capture): expose occurredAt for Event and Activity`.

Fresh code audit proves the reusable foundation already exists:
- `TimelineItem` has `DateTime? occurredAt`
- `timelineAt => occurredAt ?? createdAt`
- `QuickCapture.capture(...)` already accepts optional `occurredAt`

The remaining gap is UI/composition only: Quick Capture currently captures text + type and does not expose the existing occurredAt capability.

Next slice should add optional Persian/RTL date/time selection for Event/Activity and pass it to the existing `QuickCapture` use case. Do not create another Timeline model, capture use case, repository, storage path, or schema solely for this feature.

## Documentation Reality
PR #43 is stale and must not be merged as-is. It describes old main and old product/PR states.

Branch `docs/current-state-after-reliability` is the clean replacement and is synchronized to current main. It must be exact-head validated before merge; once the replacement PR exists, close #43 as superseded.

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
- UI consumes application contracts instead of duplicating query/data logic
- JSON persistence is real and replaceable, not fake persistence
- no fake build/test evidence
- independent lanes continue when another lane is blocked

## Next Real Actions
1. Finish post-merge CI + Android validation on current main `453a77a...`.
2. Finalize and open the clean documentation synchronization PR; close stale #43 as superseded.
3. Exact-head validate and safely merge the docs PR.
4. Start Issue #48 from current main and reuse existing `occurredAt` contracts.
5. Keep Issue #19 open until a real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
