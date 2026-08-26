# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `feee7e92464df470a4ad14b8a5437bf5a7bc8648`

Main currently includes:
- Persian RTL Flutter foundation
- shared Timeline Domain / `TimelineItemType`
- `TimelineRepository` + real JSON persistence
- Quick Capture / Load / Edit
- production-safe persistence bootstrap
- `Quick Capture → Persist → Timeline → View/Edit`
- typed Quick Capture
- `SearchTimeline` Application foundation
- RTL Search UI + type filtering
- Android foundation + Fast CI + real APK Build Gate
- Canonical Operation Plan v2.0

No duplicate Model/Repository/Storage/AppShell exists.

## Search Application — PR #36 INTEGRATED
Final exact head: `528c668456e4abf02715bed5325c36b640086bde`
- Fast CI `33003230438`: success
- Android Build `33003230489`: success
- APK artifact `9619570453`
- digest `sha256:4a7f2967dbbfefb3be9a9a66dfb9831d1aa01d6b60db7aefb1d3a9d637e1cec5`
Merged as `324e20104288949972254b2670ee61e1961b3d7a`.

## Search UI — PR #38 INTEGRATED
Issue #37 / PR #38 completed.
Final exact head: `7d0228de134f8bac41f63b00f7d4699206d3a913`

Evidence:
- `YadNegar CI` Run `33003778572`: success
- `YadNegar Android Build` Run `33003778621`: success
- build / verify / upload APK: success
- artifact id `9619820772`
- digest `sha256:b2edbad3173ccee08bfb7c8b3a3586f20634b2e9e1ea17503e8a58183f771d57`

Merged as current verified main:
`feee7e92464df470a4ad14b8a5437bf5a7bc8648`.

Integrated behavior:
- Persian/RTL search field
- optional Timeline type filter
- clear/reset
- distinct no-results state
- active search retained after capture/edit reload
- stale async load protection
- production composition reuses same repository through `SearchTimeline`

## Date-range Retrieval — PR #40 ACTIVE
Issue #39 / PR #40:
`feat(retrieval): add Timeline date-range filter foundation`

After PR #38 merged, #40 was rebuilt directly on fresh main so historical Green is not reused.
Current exact head:
`3c162f2c57fe5b1299d14b63d2dd1a8fe538c308`
Base:
`feee7e92464df470a4ad14b8a5437bf5a7bc8648`

Implemented:
- `FilterTimelineByDateRange`
- repository-only dependency
- uses `TimelineItem.timelineAt`
- start inclusive / end exclusive
- start-only / end-only
- invalid zero/reversed ranges rejected
- repository ordering preserved
- unmodifiable output
- unit tests including `occurredAt` semantics

Fresh exact-head PR gates started:
- `YadNegar CI`
- `YadNegar Android Build`

Do not merge #40 until both fresh gates complete Green, exact-head APK artifact exists, and live mergeability is safe.

## CI / Android Reality
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Issue #6 and #28 completed. Fake build claims prohibited.

## Ruleset Reality
Fresh audit: `main-protection` id `20952887` is active and currently enforces deletion protection, non-fast-forward protection and Pull Request integration only. It still has no required status checks.
Issue #19 remains open. Connector still exposes Ruleset read only, not write.

## Reuse From Arvin
User explicitly allows reuse of code/patterns from Arvin when useful.
Before reuse: fresh-audit Arvin, adapt only compatible pieces, and never duplicate YadNegar Model/Repository/Storage/AppShell/CI foundation.

## Next Real Actions
1. Finish PR #40 fresh exact-head Fast + Android validation.
2. Verify exact-head artifact + live mergeability and merge only if safe.
3. Validate new main after merge.
4. Final-sync docs lane and merge only with exact-head docs CI Green.
5. Continue Wave 5 grouping/reliability work in independent lanes.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
