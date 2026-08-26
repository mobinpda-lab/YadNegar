# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
Active operation plan: `docs/YADNEGAR_OPERATION_PLAN.md` v2.0.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `866a61b8ba8d26666d4d0436d36f402478af25b3`

## Product State
Vertical Slice اصلی کامل است:
`Quick Capture → Persist → Timeline → View/Edit`

Main additionally has typed Quick Capture:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت

همه از `TimelineItemType` واحد استفاده می‌کنند؛ هیچ Model/Repository/Storage موازی ساخته نشده است.

## CI / Android — Fully Proven
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`

Issue #6 و #28 completed هستند.

Main `1b31899d...` Full Build proof:
- Fast `33001323525`: success
- Android `33001323462`: success
- APK artifact `9618821948`

## Typed Quick Capture — Integrated
PR #34 final head `d0d206fd765dc5aa19963a971ac7c1eb4b9830ca`:
- Fast `33001576158`: success
- Android `33001576065`: success
- artifact `9618919403`

Merged as current main:
`866a61b8ba8d26666d4d0436d36f402478af25b3`.
Issue #33 completed.

Post-merge main:
- Fast `33002034902`: success
- Android `33002034898`: success
- APK artifact `9619095963`
- digest `sha256:468baac70018672d1de564c5d90271cef8bdb4d73d1f042d76728e4825613ae0`

## PR #36 — Search Application Foundation
Issue #35.
Current head:
`c5547185b8501f029b70958882b69ddb460b3f31`.

Implemented:
- SearchTimeline
- text query
- optional Timeline type filter
- combined query/type
- repository order preservation
- immutable result
- unit tests

Branch was deliberately synchronized to current main after #34. GitHub auto-closed the zero-diff PR during reset; the same #36 was reopened after Search commits were reapplied. Do not create a duplicate PR.

Current evidence:
- push Fast CI `33002127769`: success
- reopened PR Fast `33002697220`: running
- reopened PR Android `33002697213`: running

Merge only after both exact-head gates are success + APK artifact + live mergeability true.

## Search UI — Stacked Branch
Issue #37.
Branch: `feature/timeline-search-ui`.
Current head:
`59a9958a21cb0536a8f39257d7e2e6b374c68150`.

Already implemented in parallel:
- RTL Persian search field
- Timeline type filter
- clear/reset
- no-results state
- SearchTimeline injection in production
- current filter retained on reload after capture/edit
- async stale-result protection
- widget tests for search/filter/clear/empty

Fast CI Run `33002653180` is validating the branch.
This is intentionally not yet a PR to main because it depends on PR #36. After #36 merges, synchronize this branch to main and open a main PR so Fast CI + Android Build both execute.

## Docs — PR #32
Docs branch is actively synchronized in parallel and now includes:
- Full Build proof
- typed capture integration
- PR #36 state
- Search UI stacked state
- Operation Plan v2.0

Before docs merge: final live audit + exact-head docs CI Green.

## Ruleset
`main-protection` id `20952887` still does not platform-require `YadNegar CI / quality`.
Issue #19 remains open because current connector has no Ruleset write action.

## Continue
1. Check #36 Fast + Android exact-head results; merge only both Green + artifact + safe mergeability.
2. Check stacked Search UI Fast CI; fix any real failure same branch.
3. After #36 merge, rebase/synchronize Search UI to main without duplicating work, open PR, require Fast + Android Green.
4. Validate main after merge.
5. Final-sync/validate/merge docs #32.
6. Keep #19 open until actual Ruleset write capability exists.

## Automation Reality
GitHub CI automation is active. Separate hourly YadNegar continuation automation exists but is currently disabled.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
