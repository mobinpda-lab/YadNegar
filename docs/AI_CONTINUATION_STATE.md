# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `369296a0b85862859b75cbbbed401921e7e04cd0`

Integrated on main:
- Persian RTL Flutter foundation
- Timeline Domain / `TimelineItemType`
- `TimelineRepository` + real JSON persistence
- Quick Capture / Load / Edit
- production-safe persistence bootstrap
- `Quick Capture → Persist → Timeline → View/Edit`
- typed Quick Capture
- `SearchTimeline` + RTL Search UI/type filter
- `FilterTimelineByDateRange`
- Android foundation + Fast CI + real APK Build Gate
- Canonical Operation Plan v2.0

No duplicate Model/Repository/Storage/AppShell exists.

## Search — Integrated
PR #36 Search Application merged as `324e20104288949972254b2670ee61e1961b3d7a` after exact-head Fast + Android Green.

PR #38 Search UI final head `7d0228de134f8bac41f63b00f7d4699206d3a913`:
- Fast CI `33003778572`: success
- Android Build `33003778621`: success
- APK artifact `9619820772`
- digest `sha256:b2edbad3173ccee08bfb7c8b3a3586f20634b2e9e1ea17503e8a58183f771d57`
Merged as `feee7e92464df470a4ad14b8a5437bf5a7bc8648`.

## Date-range Retrieval — PR #40 INTEGRATED
Issue #39 / PR #40 completed.
Final fresh head after restack on Search UI main:
`3c162f2c57fe5b1299d14b63d2dd1a8fe538c308`

Exact-head evidence before merge:
- `YadNegar CI` Run `33004335465`: success
- `YadNegar Android Build` Run `33004335450`: success
- APK artifact id `9620025086`
- digest `sha256:eab9b743f6ade550e9723419154d549a61f811b914c429e9adedc625975456b9`

PR #40 was merged concurrently by another GitHub flow after both gates were already Green.
Current main merge SHA:
`369296a0b85862859b75cbbbed401921e7e04cd0`.

Integrated use case:
- `FilterTimelineByDateRange`
- repository-only dependency
- `timelineAt` semantics
- inclusive start / exclusive end
- start-only/end-only
- invalid-range rejection
- preserved ordering / unmodifiable result

## Persistence Reliability — PR #42 ACTIVE
Issue #41 / PR #42:
`feat(persistence): make JSON writes crash-recoverable`

Fresh audit found direct overwrite in `JsonFileTimelineRepository._writeAll`.
Arvin was fresh-searched for a reusable staged/atomic file-write pattern; no relevant implementation was found, so existing YadNegar persistence was extended rather than duplicated.

Current branch:
`persistence/crash-recovery`
Current exact head after restack on latest main:
`f0ac1dd678a327e67961ea7cb63e80e1a50dc675`

Implementation:
- stage encoded payload in `.tmp`
- flush + validate staged JSON before replacement
- preserve previous primary as `.bak`
- restore backup if replacement fails
- recover when only backup remains
- fallback to valid backup if primary is corrupted
- promote valid staged first-write
- discard invalid staged first-write
- best-effort staging cleanup
- existing schema/model/repository contract unchanged
- real temporary-directory tests

Fresh exact-head gates:
- `YadNegar CI` Run `33004964100`
- `YadNegar Android Build` Run `33004964101`

Do not merge until both complete Green, exact-head APK artifact exists and live mergeability is safe.

## CI / Android Reality
Fast Gate: `flutter pub get → flutter analyze → flutter test`
Android Gate: `flutter pub get → flutter build apk --debug → verify APK → upload artifact`

## Ruleset Reality
`main-protection` id `20952887` remains active but has no required status check rule. Issue #19 remains open because the connector exposes Ruleset read but not write. Manual exact-head Green rule remains mandatory.

## Reuse From Arvin
User explicitly allows reuse of Arvin code/patterns where useful. Always fresh-audit first and adapt compatible pieces only; never duplicate YadNegar foundations/contracts blindly.

## Next Real Actions
1. Finish PR #42 exact-head Fast + Android validation and fix any real failure on the same branch.
2. Verify APK artifact + live mergeability and merge with expected-head lock only if safe.
3. Validate new main after merge.
4. Final-sync docs lane and merge only with exact-head docs CI Green.
5. Continue Wave 5 reliability/grouping work independently.
6. Keep Issue #19 open until actual Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
