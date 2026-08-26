# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
Active operation plan: `docs/YADNEGAR_OPERATION_PLAN.md` v2.0.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `feee7e92464df470a4ad14b8a5437bf5a7bc8648`

## Product State
Vertical Slice اصلی کامل است:
`Quick Capture → Persist → Timeline → View/Edit`

Main additionally contains:
- typed Quick Capture
- `SearchTimeline`
- Persian RTL Search UI + type filter
- production-safe persistence
- Android foundation
- Fast CI + real APK Build Gate

No duplicate Model/Repository/Storage/AppShell exists.

## Search — Integrated
PR #36 Search Application merged as `324e20104288949972254b2670ee61e1961b3d7a` after exact-head Fast + Android Green.

PR #38 Search UI final head:
`7d0228de134f8bac41f63b00f7d4699206d3a913`

Evidence:
- Fast CI `33003778572`: success
- Android Build `33003778621`: success
- APK artifact `9619820772`
- digest `sha256:b2edbad3173ccee08bfb7c8b3a3586f20634b2e9e1ea17503e8a58183f771d57`

PR #38 merged as current verified main:
`feee7e92464df470a4ad14b8a5437bf5a7bc8648`.

## Date-range Retrieval — PR #40 ACTIVE
Issue #39.
Branch: `feature/timeline-date-range`.
Current exact head:
`3c162f2c57fe5b1299d14b63d2dd1a8fe538c308`.

This branch was rebuilt directly on current main after #38; old CI evidence must not be reused.

Implemented:
- `FilterTimelineByDateRange`
- repository-only dependency
- `timelineAt` semantics
- inclusive start / exclusive end
- optional one-sided bounds
- invalid range rejection
- preserved ordering
- unmodifiable output
- focused unit tests

Fresh Fast CI + Android Build are running for the new exact head. Merge only after both Green + exact-head APK artifact + live mergeability safe.

## CI
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`

## Reuse From Arvin
User explicitly allows reuse of Arvin code/patterns where useful.
Always fresh-audit Arvin first and adapt compatible pieces only; never duplicate YadNegar foundations/contracts blindly.

## Ruleset
Fresh audit confirms `main-protection` id `20952887` still has no required status check rule. Issue #19 remains open because connector only exposes Ruleset read.

## Continue
1. Finish PR #40 fresh exact-head Fast + Android validation.
2. Verify APK artifact and live mergeability; merge with expected-head lock only if safe.
3. Validate new main after merge.
4. Final-sync docs and open/merge docs PR only after exact-head docs CI Green.
5. Continue Wave 5 grouping/reliability lanes independently.
6. Keep #19 open until actual Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
