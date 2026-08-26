# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `006e6aae3d4f4ddab988bb0fd9ce5dd968b10ab2`  
Latest integrated change: Fast CI now validates `platform/**` development branches.

Canonical documentation itself is already integrated on main through merge `1765e66123f18e023b8179839333e328e783361c`.

## Integrated Product Vertical Slice
Target: `Quick Capture → Persist → Timeline → View/Edit`

All target stages are integrated on main:
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

## Recent Integration Evidence
### PR #23 — Capture/Persist/Load/Render
Final exact head `a4bc2ffe6803017bc6d1279e4b63954c372d4d00`; Run `32996798616` success; merged as `329ad83c72dba8bf6e2747db6972ef7b9afcbf69`; Issue #22 completed.

### PR #26 — Production Persistence Bootstrap
Final exact head `84b4a93be3c52e716be7f4399297ec49091630a8`; Run `32997146108` success; merged as `e2564db524bfcec17770adc28704c1925efcefc8`; Issue #24 completed.

Production uses `getApplicationSupportDirectory()` + one shared `JsonFileTimelineRepository`; no temp/current-directory fake durability.

### PR #27 — View/Edit
Final exact head `60a9fe96335fed35e8b2cf4aaadaeed24088a8ea`; Run `32997724347` success; merged as `89c349d304b0f1b1f57e518b7739723e21facc0b`; Issue #25 completed.

### PR #3 — Canonical Documentation
Final docs validation succeeded and PR #3 merged as `1765e66123f18e023b8179839333e328e783361c`.
Canonical operating package, comprehensive docs, continuation state and handoff are therefore on main.

### PR #30 — Platform Fast-CI Coverage
Final exact head `366e1c9be2461e0aa3a7bfbc9be4931a0e1846f3`; Run `32998392710` success; merged as current main `006e6aae3d4f4ddab988bb0fd9ce5dd968b10ab2`.
Existing `YadNegar CI` now includes `platform/**` push validation; no duplicate Fast workflow was created. Issue #29 completed by this PR.

## Android Foundation — Real Evidence Exists
Issue #28 started an independent platform lane: `platform/android-foundation`.

A temporary bootstrap workflow ran in a real Flutter `3.35.0` environment and produced committed Android project files.

Run `32998085012` completed **success** with all real steps successful:
- Checkout
- Flutter setup
- Generate Android foundation
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- APK file verification
- artifact upload
- commit generated platform files

Generated Android foundation commit:
`c23721dc68c622f2fa54d74b477a3b3efe143d3b`.

Real APK proof artifact:
- name: `yadnegar-android-bootstrap-debug`
- artifact id: `9617520192`
- size: `66096367` bytes
- digest: `sha256:5f3481dc4a9ffa756fabd03ff2b49f5874bd1bf8578d291ae2176fb295cf21a3`
- expires: 2026-09-02

This is valid build evidence for the bootstrap run. Android foundation is not considered integrated on main until PR #31 merges.

## PR #31 — Android Foundation + Permanent Build Gate
Active PR: `platform(android): add real Android foundation and APK build gate`.
Current exact head: `e53572b0a4a24d810de22120de88069ba6ee49c9`.

Scope:
- committed Android Flutter project foundation
- `pubspec.lock`
- Flutter-generated project metadata/config where required
- permanent `YadNegar Android Build` workflow
- read-only `contents` permission
- no self-commit/generation behavior in permanent gate
- real `flutter build apk --debug`
- APK existence verification
- APK artifact upload

PR #31 must only merge when both exact-head gates are successful:
1. `YadNegar CI` — dependency resolution / analyze / test
2. `YadNegar Android Build` — real APK build / verify / artifact

At the current audit both workflows have been created for exact head `e53572b0...`; do not claim final PR #31 validation until they complete.

## CI / Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`.

Integrated automation:
- PR validation
- active development branch push validation including `platform/**`
- Flutter cache
- concurrency + stale-run cancellation
- read-only workflow permissions

Android Build Gate candidate is PR #31. It is intentionally separate from the Fast Gate because APK compilation is a slower validation path.

## Ruleset Reality
Active ruleset `main-protection` id `20952887`:
- requires Pull Requests
- protects deletion/non-fast-forward
- does not yet platform-require `YadNegar CI / quality`

Issue #19 owns this gap. Current connector supports Ruleset reads but not mutation; never claim this rule was applied without a real write.

## Important Issues
- #6 — promote proven Android build into the final Full Build Gate policy after PR #31 integration.
- #19 — required CI status check in main Ruleset when actual write capability exists.
- #28 — Android foundation + real APK validation; active through PR #31.
- #29 — platform branch Fast CI coverage; completed through PR #30.

Completed implementation issues include #4, #5, #9, #11, #13, #15, #17, #20, #22, #24, #25 and #29.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-based structure
- Persian RTL-first
- Reuse before rebuild
- no duplicate App Shell / Timeline Model / Repository / Storage
- UI does not directly depend on storage implementation
- platform path plugin stays in composition root
- no fake build/persistence claims
- JSON storage remains a real replaceable MVP
- platform build files must be committed; generated-only CI state is not integration

## Automation Reality Outside GitHub
A separate YadNegar hourly continuation automation exists in the account but is currently disabled. Do not describe it as active.

## Next Real Actions
1. Inspect exact-head `YadNegar CI` and `YadNegar Android Build` for PR #31.
2. If a real failure exists, fix only that lane and revalidate the new exact head.
3. Merge PR #31 only when both gates are Green and mergeability is safe.
4. Validate post-merge main Android build evidence.
5. Update Issue #6 from future-build placeholder to proven Full Build Gate work.
6. Keep docs/handoff synchronized in parallel.
7. Keep Issue #19 open until a real Ruleset write path exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
