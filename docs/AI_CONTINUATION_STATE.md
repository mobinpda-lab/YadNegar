# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `f1b96756c501da517d25c3610341bdc81e2d5fb5`  
Commit: `feat(edit): add Timeline item text edit use case`

Main contains:
- Flutter/Dart + Persian RTL foundation
- single Fast Quality Gate
- shared Timeline Domain
- `TimelineRepository` + real JSON file persistence
- active-lane CI automation
- RTL Timeline UI shell
- Quick Capture application logic
- Load Timeline application logic
- Edit Timeline Item application logic

## Integrated Work
- PR #2 Foundation — merged; Issue #4 completed.
- PR #7 Fast CI — merged `9999e31f7aa2fa4717c5f027319e356ca705bebe`; exact head `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`; run `32987365151` success.
- PR #10 Timeline Domain — merged `0610c401eb5a31a68552be047bc3d765696c2f33`; run `32987199672` success.
- PR #12 Persistence — merged `cc00db09863592b6b3ccb89de05aa1c428dbb5e7`; exact-head CI success.
- PR #14 CI active-lane coverage — merged `bb6f97672e446973df94674f6ae16a8dbfd3d930`; run `32989549391` success.
- PR #8 RTL Timeline UI — merged `0cb8bbd3a451234d4a1042d194f39f917266ea88`; exact head `30c3765231e38146b8b14e03a35e05cc3b91f0c4`; run `32990720534` success. Issue #5 was verified stale-open and closed as completed on 2026-08-26.
- PR #16 Quick Capture — merged `e56c71f39d9af21845e9a8b8e91c9204939479df`; exact head `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`; run `32990963329` success.
- PR #21 Load Timeline — merged `c988f746b9cd42e9a3f75f3b7e97469cda62cdcc`; exact head `8c84d754c5061641886497a4354b2aa115a4d752`; run `32991379013` success.
- PR #18 Edit Timeline Item — merged/current main `f1b96756c501da517d25c3610341bdc81e2d5fb5`; exact head `91627cae4cdc7e4db2741693419debd081c04a87`; run `32991761859` success.

## Active Pull Requests
### PR #23 — First real Timeline vertical-slice wiring
Branch: `feature/timeline-vertical-slice`  
Current exact head: `116606586870f0869a9c2278c16838e6c40c2c50`  
Base: `main` at `f1b96756c501da517d25c3610341bdc81e2d5fb5`  
Issue #22 owns this scope.

Implemented:
- `TimelineScreen` renders loading/error/empty/real Timeline items.
- `TimelineHome` coordinates initial load, Quick Capture dialog, capture, reload and render.
- UI depends on application objects, not `dart:io` or concrete storage.
- vertical-slice widget tests inject real `JsonFileTimelineRepository` with a temporary directory.
- persistence is verified by reload through a second repository instance.
- empty capture is rejected with feedback and no persisted item.

### PR #23 Current CI Evidence
Historical exact head `4e63a58fab55fa99f3a509b642ced9b266a60e08` had real failing runs, including run `32993286618`.
Job `quality` evidence:
- Resolve dependencies: success
- Analyze: success
- Test: failure

Failure was diagnosed from the real job log, not inferred: both vertical-slice widget tests timed out on initial `pumpAndSettle` while the widget used real asynchronous file I/O and an indeterminate loading indicator.

Fix committed on the same branch:
`116606586870f0869a9c2278c16838e6c40c2c50` — `test(timeline): synchronize widget test with real file IO`

The tests now use a bounded pump helper that advances widget time while explicitly yielding to real asynchronous I/O instead of treating an indeterminate progress animation as a settled frame tree.

Current exact-head run at the time of this documentation update:
- run `32996282933`
- workflow `YadNegar CI`
- status: in progress/pending final conclusion

Do not merge until this exact head is completed Green and live mergeability is safe.

### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`.
Documentation/README only. Keep synchronized with implementation/CI reality and validate the exact final docs head before merge.

## Active Issues / Ownership
- Issue #6 → future real Full Build Gate only.
- Issue #19 → add `YadNegar CI / quality` to the main Ruleset when actual Ruleset write capability is available.
- Issue #22 → PR #23 vertical-slice wiring.
- Issue #24 → platform-safe production persistence bootstrap after PR #23.
- Issue #25 → View/Edit UI using integrated `EditTimelineItem`, to start from fresh post-#23 main.

Completed implementation issues include #4, #5, #9, #11, #13, #15, #17 and #20.

## GitHub Ruleset Reality
Active ruleset:
- id `20952887`
- name `main-protection`
- target `refs/heads/main`
- enforcement active

Current rules:
- prevent deletion
- prevent non-fast-forward
- require Pull Request

There is still no required-status-check rule for `YadNegar CI / quality` at platform level. Issue #19 remains valid. Current GitHub connector exposes Ruleset reads but no Ruleset mutation tool, so do not claim this hardening is applied.

Operational merge rule remains: exact-current-head Green CI before merge.

## Product Vertical Slice
Target:
`Quick Capture → Persist → Timeline → View/Edit`

Current state:
- Domain: Integrated
- Fast CI: Integrated
- Persistence: Integrated
- UI shell: Integrated
- Quick Capture: Integrated
- Load Timeline: Integrated
- Edit application logic: Integrated
- Capture/Persist/Load/Render wiring: PR #23 active with exact-head fix under CI
- Production platform-safe bootstrap: Issue #24 next
- View/Edit UI: Issue #25 next

## Platform Bootstrap Rule
Production must never use `Directory.systemTemp` or `Directory.current` as pretend durable storage.
Issue #24 proposes a platform-safe application documents/support directory (for example via `path_provider`) while keeping plugins out of Domain/UI.
`flutter build` remains invalid to claim until a real Platform project foundation exists and the build command actually runs successfully.

## Actions Interpretation
- zero Runs is neither success nor failure.
- historical success/failure is not current-head evidence.
- workflow `head_sha` must match the current PR head.
- diagnose failures only from real Job/Steps/logs.
- merge only exact-current-head Green.

## Validation
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Add `flutter build` only after real Platform foundation and real build execution.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based structure
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell
- no competing Timeline model
- no competing Repository/Storage foundation
- no duplicate CI path
- no fake persistence/build claims
- no duplicate canonical docs

## Automation Reality
A YadNegar hourly continuation task exists in the account but is currently disabled. Do not describe automated hourly execution as active unless a live automation audit shows it enabled.
GitHub-side CI automation remains active as documented above.

## Next Real Actions
1. Re-check exact-head run `32996282933` for PR #23 and inspect Job/Steps.
2. If Green, re-check live PR head + mergeability and merge #23 using expected-head SHA lock.
3. Validate the new main and Issue #22 closure.
4. Start Issue #24 production-safe bootstrap from fresh post-#23 main.
5. Start Issue #25 View/Edit UI from fresh post-#23 main in a separate lane.
6. Keep PR #3 synchronized and exact-head Green before merge.
7. Apply Issue #19 only when actual Ruleset write support exists.
8. Create real Platform project foundation before Full Build Gate.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
