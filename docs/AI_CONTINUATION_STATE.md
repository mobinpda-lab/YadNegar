# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `324e20104288949972254b2670ee61e1961b3d7a`

Integrated on main:
- Persian RTL Flutter foundation
- shared Timeline Domain / `TimelineItemType`
- `TimelineRepository` + real JSON persistence
- Quick Capture / Load / Edit
- production-safe application-support persistence
- complete `Quick Capture → Persist → Timeline → View/Edit`
- typed Quick Capture for Note/Event/Call/Idea/Activity
- Android foundation + permanent Fast CI + real Android APK Build Gate
- `SearchTimeline` Application foundation
- Canonical Operation Plan v2.0

No duplicate Model/Repository/Storage/AppShell exists.

## Search Application — PR #36 INTEGRATED
Issue #35 / PR #36 is completed.

Final synchronized exact head:
`528c668456e4abf02715bed5325c36b640086bde`

Pre-merge exact-head evidence:
- `YadNegar CI` Run `33003230438`: success
- `YadNegar Android Build` Run `33003230489`: success
- Android build/verify/upload steps: success
- APK artifact id `9619570453`
- artifact digest `sha256:4a7f2967dbbfefb3be9a9a66dfb9831d1aa01d6b60db7aefb1d3a9d637e1cec5`

PR #36 merged as main:
`324e20104288949972254b2670ee61e1961b3d7a`.

`SearchTimeline` provides:
- trimmed case-insensitive text query
- optional `TimelineItemType` filter
- combined query + type
- repository order preservation
- unmodifiable result
- independent unit tests

## Search UI — PR #38 ACTIVE
Issue #37 / PR #38:
`feat(search): add RTL Timeline search and type filters`

Branch:
`feature/timeline-search-ui`

Current exact head:
`7d0228de134f8bac41f63b00f7d4699206d3a913`

This branch was rebuilt directly on integrated SearchTimeline main, so the PR diff contains only UI/composition/test changes.

Implemented:
- Persian/RTL Timeline search field
- optional Timeline type filter
- clear query/filter
- distinct no-results state
- active search retained after capture/edit reload
- stale async load protection with generation token
- production composition injects `SearchTimeline` using the same repository
- widget tests for text search, type filter, clear and empty result

PR #38 exact-head gates started:
- `YadNegar CI` Run `33003778572`
- `YadNegar Android Build` Run `33003778621`

Merge only after both are completed success, APK artifact exists for exact head, and live mergeability remains safe.

## CI / Android Reality
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Issue #6 and #28 are completed. Fake build claims are prohibited.

## Ruleset Reality
`main-protection` id `20952887` still does not platform-require `YadNegar CI / quality`.
Issue #19 remains open because current connector exposes Ruleset read but not write. Manual project rule remains: never merge without exact-head Green CI evidence.

## Reuse From Arvin
User explicitly allows reuse of code/patterns from the Arvin project when useful.
Rule: fresh-audit Arvin before reuse, adapt to YadNegar contracts, and never import duplicate foundations/models/repositories/storage/CI architecture blindly.

## Next Real Actions
1. Finish PR #38 exact-head Fast CI + Android Build.
2. Verify exact-head APK artifact and live mergeability; merge #38 only if both gates are Green.
3. Validate new main after merge.
4. Final-sync this docs lane with #38 result and merge docs only with exact-head docs CI Green.
5. Continue Wave 5 reliability/date/group retrieval work in independent lanes.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
