# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `89c349d304b0f1b1f57e518b7739723e21facc0b`  
Commit: `feat(timeline): add real View/Edit flow`

## Integrated Product Vertical Slice
Target: `Quick Capture → Persist → Timeline → View/Edit`

All current target stages are integrated on main:
- Flutter/Dart Persian RTL foundation
- shared Timeline Domain
- `TimelineRepository` + real JSON file persistence
- Quick Capture application logic
- Load Timeline application logic
- Edit Timeline Item application logic
- RTL Timeline UI
- Quick Capture UI → persist → reload → render
- production-safe application-support persistence bootstrap
- item tap → edit → persist → reload → refreshed Timeline

## Key Integration Evidence
### PR #23 — Capture/Persist/Load/Render
Final exact head: `a4bc2ffe6803017bc6d1279e4b63954c372d4d00`.
Run `32996798616`: Resolve dependencies, Analyze, Test all success.
Merged as `329ad83c72dba8bf6e2747db6972ef7b9afcbf69`.
Issue #22 closed completed.

### PR #26 — Production Persistence Bootstrap
Final exact head: `84b4a93be3c52e716be7f4399297ec49091630a8`.
Run `32997146108`: Resolve dependencies, Analyze, Test all success.
Merged as `e2564db524bfcec17770adc28704c1925efcefc8`.
Issue #24 closed completed.

Production startup now obtains the application-support directory with `path_provider`, creates one shared `JsonFileTimelineRepository`, and injects application use cases over the same repository. No temp/current-directory fake durability is used.

### PR #27 — View/Edit
Initial branch work was developed in parallel with PR #26. After #26 merged, GitHub correctly reported a merge conflict on the View/Edit lane. The branch was synchronized with current main using a real merge commit instead of creating a duplicate PR.

Final exact head: `60a9fe96335fed35e8b2cf4aaadaeed24088a8ea`.
Run `32997724347`: exact-head `YadNegar CI` completed success; Resolve dependencies, Analyze and Test succeeded.
Live mergeability was rechecked as true.
PR #27 was merged with expected-head SHA lock as current main `89c349d304b0f1b1f57e518b7739723e21facc0b`.
Issue #25 closed completed.

Integrated View/Edit behavior:
- Timeline item tap enabled when edit use case is available.
- Persian/RTL edit dialog.
- edits call existing `EditTimelineItem.updateText` only.
- metadata preservation remains inside the existing application use case.
- reload uses existing `LoadTimeline`.
- empty edit feedback.
- production composition injects `EditTimelineItem` over the same shared repository.
- widget coverage for edit/save/reload/render and empty edit.

## CI / Automation
Unified `YadNegar CI` remains the Fast Gate:
`flutter pub get → flutter analyze → flutter test`.

Automation already integrated:
- PR validation
- active development-branch push validation
- Flutter cache
- concurrency
- stale-run cancellation
- read-only workflow permissions

Ruleset gap remains:
- `main-protection` id `20952887` is active.
- requires Pull Requests and protects deletion/non-fast-forward.
- does NOT yet platform-require `YadNegar CI / quality`.
- Issue #19 owns this gap.
- current connector supports Ruleset read but not Ruleset mutation; do not invent a write.

## Documentation
PR #3 `docs: establish YadNegar canonical project documentation` remains the canonical docs integration lane until merged.
This file and `docs/AI_HANDOFF_CURRENT_FA.md` must reflect current main before PR #3 final validation/merge.

## Current Open Product/Platform Direction
Issue #28: `platform: add real Android project foundation and APK validation`.

Objective:
- commit a real Android Flutter runner/project foundation.
- then execute an actual Android APK build.
- verify an APK artifact exists.
- only after that extend Issue #6 into a real Full Build Gate.

No APK/full-build success has been claimed yet because the repository still does not have a committed Android platform foundation on main.

## Important Issues
- #6 — Full Build Gate after real platform foundation/build evidence.
- #19 — required CI status check in main Ruleset when write capability exists.
- #28 — real Android platform foundation + APK validation.

Completed implementation issues include #4, #5, #9, #11, #13, #15, #17, #20, #22, #24 and #25.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-based structure
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell
- no duplicate Timeline model
- no duplicate Repository/Storage foundation
- UI does not directly depend on storage implementation
- platform path plugin stays in composition root
- no fake build/persistence claims
- JSON storage remains a real replaceable MVP, not a declaration of final database technology

## Automation Reality Outside GitHub
A separate YadNegar hourly continuation automation exists in the account but is currently disabled. Do not describe it as active.

## Next Real Actions
1. Exact-head validate this final docs sync and merge PR #3 if mergeability is safe.
2. Fresh-audit main after docs integration.
3. Start Issue #28 from fresh main in an independent platform lane.
4. Generate/commit Android foundation using a real Flutter 3.35 environment.
5. Run actual `flutter build apk` and verify artifact before claiming build success.
6. Only then implement the Full Build Gate from Issue #6.
7. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
