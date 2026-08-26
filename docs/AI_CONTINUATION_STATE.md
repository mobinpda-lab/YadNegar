# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `379f58caf34f2206556246beb94e27a2c85ece78`

Current main includes the shared Timeline vertical slice, typed Quick Capture, Search + Type retrieval UI/application, date-range application foundation, Vazirmatn typography with optional private licensed IRANSansX, deduplicated CI triggers, and crash-recoverable JSON persistence.

No second Timeline Model / Repository / Storage / App Shell exists.

## Recent Integrated Work
### PR #44 — Typography
Merged.
- bundled open-source Vazirmatn UI + Farsi Digits
- private licensed IRANSansX remains optional for private builds
- proprietary IRANSansX binaries are not committed to the public repository

### PR #45 — CI deduplication
Merged as `aaff41d1e287372e441ea6809bf61d06b49df44c`.
- `push` quality trigger is limited to `main`
- feature PRs validate through `pull_request -> main`
- prevents duplicate push/PR quality runs for the same feature SHA

### PR #42 / Issue #41 — Crash-recoverable JSON persistence
Merged safely as current main `379f58caf34f2206556246beb94e27a2c85ece78` using exact-head lock.

Exact PR head before merge:
`692c8519d6fc22c20671494ea5304f97babe935d`

Exact-head validation:
- `YadNegar CI` Run `33012747019`: success
- `YadNegar Android Build` Run `33012747020`: success

Post-merge main proof on `379f58c...`:
- `YadNegar CI` Run `33014440255`: success
- `YadNegar Android Build` Run `33014440247`: success

Issue #41 is closed.

Persistence now uses the existing JSON repository with staged `.tmp`, `.bak`, validation/recovery, flush, restore-on-replacement-failure and real temporary-directory tests. Schema/model/repository contracts were not duplicated.

## Active Product PR — #47 Date-range UI
PR #47: `feat(retrieval): add Timeline date-range filters`  
Issue: #46  
Branch: `feature/timeline-date-range-ui`  
Current exact head: `10f6d1dc0e288f4a46552a54ad7bfa808c9ccd7e`  
Base: current main `379f58caf34f2206556246beb94e27a2c85ece78`  
Live mergeability last verified: true

Implementation:
- reuses existing `FilterTimelineByDateRange`
- reuses existing `SearchTimeline`
- reuses the same production `TimelineRepository`
- Persian/RTL date-range control
- UI selected end day is inclusive while application boundary remains end-exclusive
- Text + Type + Date compose without a second query/storage path
- clear/reset covers all retrieval filters

Widget coverage includes:
- date-only filtering across multiple days
- selected end-day inclusion
- date + text
- date + type
- clear/reset
- date-only empty-result state
- existing search/type regression tests

Exact-head validation at this snapshot:
- `YadNegar CI` Run `33014650334`: success
- `YadNegar Android Build` Run `33014650363`: in progress

Do not merge #47 until Android Build on the same exact head is success and live head/mergeability are re-read immediately before merge.

## Next Verified Product Gap — Issue #48
Issue #48: `feat(capture): expose occurredAt for Event and Activity`.

Fresh code audit proves the foundation already exists:
- `TimelineItem` has `DateTime? occurredAt`
- `timelineAt => occurredAt ?? createdAt`
- `QuickCapture.capture(...)` already accepts optional `occurredAt`

The missing piece is UI composition: Quick Capture currently captures text + type only. After #47 is integrated, expose optional date/time for Event/Activity without creating a new model, repository, storage path, or capture use case.

## Documentation Reality
PR #43 is stale and must not be merged as-is. It describes old main/PR states.

A clean documentation synchronization branch now supersedes that stale snapshot. Final docs must be re-synced once #47 reaches its terminal merged/not-merged state.

## Ruleset Reality — Issue #19
Active ruleset `main-protection` id `20952887`:
- requires Pull Requests
- protects deletion and non-fast-forward updates
- currently has no required-status-check rule

Issue #19 remains open. Current connector exposes Ruleset read but not a Ruleset write action.

Operational merge contract until that gap is truly fixed:
`Exact current PR head + Green exact-head gates + live mergeability + expected_head_sha merge lock`

Never claim Required Status Check is configured unless a fresh Ruleset read proves it.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-based structure
- Persian RTL-first
- reuse before rebuild
- no duplicate App Shell / Timeline Model / Repository / Storage
- UI consumes application contracts instead of duplicating query/data logic
- JSON persistence is a real replaceable MVP, not fake persistence
- no fake build/test evidence
- independent lanes continue when another lane is blocked

## Next Real Actions
1. Finish exact-head Android validation for PR #47.
2. Re-read PR #47 head + mergeability and merge only if both exact-head gates are Green.
3. Validate new main with real CI/Android evidence.
4. Close/supersede stale docs PR #43 and merge a clean docs synchronization after exact-head validation.
5. Start Issue #48 from the new main; reuse existing `occurredAt` contracts.
6. Keep Issue #19 open until a real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
