# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
Active operation plan: `docs/YADNEGAR_OPERATION_PLAN.md` v2.0.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `369296a0b85862859b75cbbbed401921e7e04cd0`

## Product State
Vertical Slice اصلی کامل است:
`Quick Capture → Persist → Timeline → View/Edit`

Main additionally contains:
- Quick Capture تایپ‌دار برای Note/Event/Call/Idea/Activity
- `SearchTimeline` از PR #36
- UI جستجوی فارسی/RTL و فیلتر نوع از PR #38
- `FilterTimelineByDateRange` از PR #40
- همان Timeline Domain / TimelineRepository / JSON persistence / App Shell / Android foundation قبلی

هیچ Model/Repository/Storage/App Shell موازی ساخته نشده است.

## Latest Integrated Retrieval Work
PR #36: Search application foundation — merged.  
PR #38: RTL search/type-filter UI — merged.  
PR #40: Timeline date-range filter foundation — merged as current main.

## Active PR #42 — Persistence Reliability
Issue #41.
Branch: `persistence/crash-recovery`.
Current exact head:
`f0ac1dd678a327e67961ea7cb63e80e1a50dc675`

Implemented on the existing JSON repository only:
- staged `.tmp` write + flush
- staged payload validation
- `.bak` preservation
- restore/fallback recovery paths
- valid temp promotion for first-write interruption
- cleanup staging files
- real temporary-directory tests

Exact-head CI evidence verified:
- Fast `quality`: success
- Android `android-build`: success

There is also an older cancelled duplicate `quality` check on the same SHA from concurrency behavior. GitHub currently reports `mergeable: true` but `mergeable_state: unstable`; do not merge until a fresh audit shows the exact current head still green and mergeability safely clean.

## CI / Android Contract
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`

Historical green evidence is invalid after any head change.

## Documentation Lane
The previous main docs were materially stale: they still described PR #36 and docs PR #32 as active even though #32/#36/#38/#40 had already merged. `docs/live-state-sync-20260826` exists only to synchronize these two canonical live handoff files with current GitHub reality.

## Ruleset
`main-protection` still does not platform-require `YadNegar CI / quality`.
Issue #19 remains open because the current connector exposes Ruleset reads but no mutation action.

## Continuity Rule
This continuation process is additive and must not interfere with healthy workflows, builds, PRs or lanes. Waiting/failure in one lane must not stop unrelated healthy work.

## Continue
1. Fresh-audit main, PR #42 exact head, check-runs and mergeability.
2. Merge #42 only when exact-current-head gates remain green and mergeability is safely clean.
3. Validate post-merge main.
4. Continue the next approved retrieval/UI slice by wiring the already-merged date-range application capability without duplicating SearchTimeline, repository or storage logic.
5. Keep `AI_CONTINUATION_STATE.md` and this handoff synchronized after material implementation/CI/merge changes.
6. Keep #19 open until actual Ruleset write capability exists.

## Automation Reality
GitHub CI automation is active. The hourly YadNegar continuation process is also active and must remain additive/non-interfering.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
