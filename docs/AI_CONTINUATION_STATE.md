# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `866a61b8ba8d26666d4d0436d36f402478af25b3`  
Latest integrated product change: typed Quick Capture on the existing Timeline contract.

Canonical documentation baseline is integrated through merge `1765e66123f18e023b8179839333e328e783361c`.
Fast CI platform branch coverage is integrated through PR #30 / merge `006e6aae3d4f4ddab988bb0fd9ce5dd968b10ab2`.
Android foundation + permanent Build Gate is integrated through PR #31 / merge `1b31899d69d3f1fa98520dcc82a9251a7026cc09`.

## Integrated Product Vertical Slice
`Quick Capture → Persist → Timeline → View/Edit`

Main contains:
- Flutter/Dart Persian RTL foundation
- shared Timeline Domain
- `TimelineRepository` + real JSON persistence
- Quick Capture / Load Timeline / Edit Timeline application logic
- RTL Timeline UI
- production-safe application-support persistence
- capture → persist → reload → render
- item tap → edit → persist → reload
- typed Quick Capture for Note/Event/Call/Idea/Activity

No second Model/Repository/Storage/AppShell exists.

## Full CI / Android Proof — COMPLETED
Issue #6 and Issue #28 are completed.

Permanent validation model:

Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Build Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

### Android foundation main proof
Main `1b31899d69d3f1fa98520dcc82a9251a7026cc09`:
- Fast CI Run `33001323525`: success
- Android Build Run `33001323462`: success
- artifact id `9618821948`
- digest `sha256:6976da5fcdc8958c70d7b9b73df71053c4b47f6b6eb158793751e20754ec4604`

### Typed Quick Capture — PR #34 INTEGRATED
Final exact head:
`d0d206fd765dc5aa19963a971ac7c1eb4b9830ca`

Pre-merge evidence:
- `YadNegar CI` Run `33001576158`: success
- `YadNegar Android Build` Run `33001576065`: success
- artifact id `9618919403`
- artifact digest `sha256:c6f24249eb4fca9d8bc184ce28059a5c47b0c43628858dad878a9b64aa590dbd`

PR #34 merged as current main:
`866a61b8ba8d26666d4d0436d36f402478af25b3`.
Issue #33 completed through this PR.

Post-merge main evidence on `866a61b8...`:
- Fast CI Run `33002034902`: success
- Android Build Run `33002034898`: success
- artifact id `9619095963`
- size `66098170` bytes
- digest `sha256:468baac70018672d1de564c5d90271cef8bdb4d73d1f042d76728e4825613ae0`
- expires 2026-09-02

## Wave 5 Retrieval Foundation — PR #36 ACTIVE
Issue #35 / PR #36: `feat(search): add Timeline search application foundation`.

Important branch synchronization history:
- PR #36 was initially opened on the pre-#34 main.
- To avoid validating against stale main, its branch was force-synchronized to current main `866a61b8...` and the two independent Search files were reapplied.
- GitHub automatically closed the PR during the brief zero-diff state.
- The same PR #36 was reopened after the Search commits returned; no duplicate PR was created.

Current exact head:
`c5547185b8501f029b70958882b69ddb460b3f31`.

Implemented:
- `SearchTimeline` Application use case
- trimmed case-insensitive query
- optional `TimelineItemType` filter
- combined query + type
- repository order preservation
- unmodifiable result
- independent unit tests

Push Fast CI on exact head:
- Run `33002127769`: success

After PR reopen, exact-head PR gates are running:
- `YadNegar CI` Run `33002697220`
- `YadNegar Android Build` Run `33002697213`

Do not merge #36 until both complete Green, Android artifact exists, and live mergeability remains safe.

## Search UI — STACKED DEVELOPMENT ACTIVE
Issue #37 branch:
`feature/timeline-search-ui`

Base development head is PR #36 exact code, so UI consumes the actual `SearchTimeline` contract instead of duplicating query logic.

Current branch head:
`59a9958a21cb0536a8f39257d7e2e6b374c68150`.

Implemented:
- Persian/RTL Timeline search field
- optional type filter using existing `TimelineItemType`
- clear search/filter action
- distinct no-results state
- stale async load protection with generation token
- search state preserved after capture/edit reload
- production composition injects `SearchTimeline` using the same repository
- widget tests for text search, type filter, clear and empty result

Fast CI Run `33002653180` is currently validating this stacked branch.
No PR to main is opened yet. After PR #36 merges, this branch must be synchronized to the new main, then opened to main so Fast CI + Android Build both validate exact head.

## Documentation Lane — PR #32 ACTIVE
`docs/android-foundation-sync`

This lane now updates:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`

`YADNEGAR_OPERATION_PLAN.md` was promoted from stale Foundation-era v1.1 to v2.0 describing the real current state: Waves 0–3.5 complete, Wave 4 integrated/active, Wave 5 active in parallel, Android Full Build real.

Docs PR #32 remains open until current Product/Retrieval wave reaches a clean synchronization point; exact-head docs CI is required before merge.

## Ruleset Reality
Active ruleset `main-protection` id `20952887`:
- requires Pull Requests
- protects deletion/non-fast-forward
- does not yet platform-require `YadNegar CI / quality`

Issue #19 owns this gap. Current connector supports Ruleset reads but not mutation; never claim a write that did not happen.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-based structure
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell / Timeline Model / Repository / Storage
- query logic belongs in Application, not duplicated in UI
- UI does not directly depend on storage implementation
- platform path plugin stays in composition root
- no fake build/persistence claims
- JSON storage remains a real replaceable MVP
- platform build files are committed and validated

## Automation Reality Outside GitHub
A separate YadNegar hourly continuation automation exists in the account but is currently disabled. Do not describe it as active.

## Next Real Actions
1. Finish PR #36 exact-head Fast CI + Android Build; inspect APK artifact and merge only Green + safe mergeability.
2. Validate Search UI stacked Fast CI; fix real failures on the same branch.
3. After #36 merge, synchronize Search UI to main and open its PR to main for Fast + Android gates.
4. Validate main after each merge.
5. Keep PR #32 synchronized and merge only after exact-head docs CI + live reality match.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
