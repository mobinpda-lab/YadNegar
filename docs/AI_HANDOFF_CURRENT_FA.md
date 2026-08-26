# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
Active operation plan: `docs/YADNEGAR_OPERATION_PLAN.md` v2.0.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `324e20104288949972254b2670ee61e1961b3d7a`

## Product State
Vertical Slice اصلی کامل است:
`Quick Capture → Persist → Timeline → View/Edit`

Main همچنین دارد:
- typed Quick Capture با `TimelineItemType` واحد
- Android foundation واقعی
- Fast CI و Android APK Build Gate واقعی
- `SearchTimeline` Application foundation

هیچ Model/Repository/Storage/AppShell موازی ساخته نشده است.

## Search Application — Integrated
PR #36 / Issue #35 completed.

Final head:
`528c668456e4abf02715bed5325c36b640086bde`

Exact-head evidence:
- Fast CI `33003230438`: success
- Android Build `33003230489`: success
- APK artifact `9619570453`
- digest `sha256:4a7f2967dbbfefb3be9a9a66dfb9831d1aa01d6b60db7aefb1d3a9d637e1cec5`

Merged as main:
`324e20104288949972254b2670ee61e1961b3d7a`.

## Search UI — PR #38 ACTIVE
Issue #37.
Branch: `feature/timeline-search-ui`.
Head: `7d0228de134f8bac41f63b00f7d4699206d3a913`.

Implemented:
- RTL Persian search field
- optional Timeline type filter
- clear/reset
- no-results state
- SearchTimeline injection using the same Repository
- active filter/search preserved after capture/edit reload
- stale async result protection
- widget tests for search/filter/clear/empty

The branch was rebuilt on the integrated SearchTimeline main, so it no longer carries duplicated Search Application commits.

Current exact-head gates:
- `YadNegar CI` Run `33003778572`
- `YadNegar Android Build` Run `33003778621`

Do not merge until both are completed Green, exact-head APK artifact exists, and live mergeability is safe.

## CI
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`

Issue #6 and #28 completed.

## Reuse From Arvin
User has explicitly allowed reuse of Arvin code/patterns when useful.
Before reuse: fresh-audit Arvin and adapt only compatible pieces. Never create duplicate YadNegar Model/Repository/Storage/AppShell/CI foundation merely because Arvin has an implementation.

## Ruleset
`main-protection` id `20952887` still lacks required `YadNegar CI / quality` enforcement.
Issue #19 remains open because current connector has no Ruleset write action.

## Continue
1. Check PR #38 exact-head Fast + Android results.
2. Inspect exact-head APK artifact and live mergeability.
3. Merge #38 only when both gates are Green.
4. Validate new main after merge.
5. Final-sync and validate docs branch `docs/search-retrieval-sync`, then merge it with exact-head docs CI Green.
6. Continue Wave 5 reliability/date/group retrieval lanes independently.
7. Keep #19 open until actual Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
