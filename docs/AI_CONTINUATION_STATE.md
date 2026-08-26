# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `369296a0b85862859b75cbbbed401921e7e04cd0`  
Latest integrated product/retrieval change: Timeline date-range application filter through PR #40.

## Integrated Product State
The primary vertical slice remains complete:
`Quick Capture → Persist → Timeline → View/Edit`

Main also contains:
- typed Quick Capture for Note/Event/Call/Idea/Activity
- `SearchTimeline` application foundation from merged PR #36
- Persian/RTL Timeline search + type filters from merged PR #38
- `FilterTimelineByDateRange` application foundation from merged PR #40
- the existing shared Timeline Domain, `TimelineRepository`, JSON persistence, production composition and Android foundation

No duplicate Timeline Model/Repository/Storage/AppShell exists.

## Current Main Milestones
- PR #36 merged: SearchTimeline application foundation.
- PR #38 merged: RTL Timeline search/type-filter UI wired to the existing SearchTimeline contract.
- PR #40 merged: Timeline date-range filter foundation with start-inclusive/end-exclusive semantics.

## Active Persistence Reliability Lane — PR #42
Issue #41 / PR #42: `feat(persistence): make JSON writes crash-recoverable`.

Current exact head:
`f0ac1dd678a327e67961ea7cb63e80e1a50dc675`

Scope is limited to the existing `JsonFileTimelineRepository` and its tests:
- staged `.tmp` write with flush
- staged payload validation
- `.bak` preservation during replacement
- backup restore/fallback paths
- temp promotion for interrupted first write
- staging cleanup
- real temporary-directory tests

Architecture safety:
- schemaVersion remains 1
- existing Timeline model/repository contract unchanged
- no second storage/repository introduced
- no cross-platform atomic-rename claim

Exact-head evidence verified for `f0ac1dd...`:
- `YadNegar CI / quality`: success
- `YadNegar Android Build / android-build`: success

A cancelled duplicate quality run also exists on the same SHA due to workflow concurrency history. Live PR state is `mergeable: true` but `mergeable_state: unstable`; therefore this run did not merge PR #42. Re-check live mergeability before any merge and only merge when current exact-head evidence remains green and mergeability is safely clean.

## CI / Android Contract
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Build Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Never use historical green evidence for a changed head.

## Ruleset Reality
Active `main-protection` ruleset still requires Pull Requests and protects deletion/non-fast-forward, but platform-level required status checks are not yet configured. Issue #19 remains open because current connector capability does not expose Ruleset mutation.

## Documentation Reality
Previous canonical docs on main were stale and still described PR #36/#32 as active. This branch updates the two live AI handoff documents to the actual current GitHub state without altering product code.

## Continuity / Parallelism
This hourly continuation process is additive only:
- never cancel or supersede healthy GitHub Actions, builds, PRs or branch lanes
- if one lane waits, continue independent low-conflict work
- synchronize against fresh main before merge-sensitive actions
- reuse existing foundations and avoid duplicate scopes

## Next Real Actions
1. Re-audit PR #42 exact head, all check-runs and live mergeability; merge only if exact current head stays green and mergeability becomes safely clean.
2. Validate post-merge main after any merge.
3. Wire the already-merged date-range application capability into the next approved retrieval/UI slice without duplicating SearchTimeline or repository logic.
4. Keep these two live handoff docs synchronized with material implementation/CI/merge changes.
5. Keep Issue #19 open until a real Ruleset write path exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
