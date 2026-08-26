# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `1b31899d69d3f1fa98520dcc82a9251a7026cc09`  
Latest integrated change: committed Android platform foundation + permanent Android APK Build Gate.

Canonical documentation is integrated through merge `1765e66123f18e023b8179839333e328e783361c`.
Fast CI platform branch coverage is integrated through PR #30 / merge `006e6aae3d4f4ddab988bb0fd9ce5dd968b10ab2`.

## Integrated Product Vertical Slice
Target: `Quick Capture → Persist → Timeline → View/Edit`

All target stages are integrated on main:
- Flutter/Dart Persian RTL foundation
- shared Timeline Domain
- `TimelineRepository` + real JSON persistence
- Quick Capture / Load Timeline / Edit Timeline application logic
- RTL Timeline UI
- Quick Capture UI → persist → reload → render
- production-safe application-support persistence bootstrap
- item tap → edit → persist → reload → refreshed Timeline

## Key Recent Integrations
- PR #23 — Capture/Persist/Load/Render; exact head `a4bc2ffe...`; Run `32996798616` success; merged `329ad83c...`; Issue #22 completed.
- PR #26 — Production Persistence Bootstrap; exact head `84b4a93b...`; Run `32997146108` success; merged `e2564db5...`; Issue #24 completed.
- PR #27 — View/Edit; exact head `60a9fe96...`; Run `32997724347` success; merged `89c349d3...`; Issue #25 completed.
- PR #3 — Canonical docs merged `1765e661...` after exact-head Green CI.
- PR #30 — `platform/**` Fast CI coverage; exact head `366e1c9b...`; Run `32998392710` success; merged `006e6aae...`; Issue #29 completed.

## Android Foundation + Full Build Gate — COMPLETED
Issue #28 Android foundation and Issue #6 Full Build Gate are both completed with real evidence.

Bootstrap proof Run `32998085012` succeeded in Flutter `3.35.0` with Android generation, pub get, analyze, test, `flutter build apk --debug`, APK verification/upload and generated foundation commit `c23721dc68c622f2fa54d74b477a3b3efe143d3b`.

Bootstrap artifact:
- id `9617520192`
- `yadnegar-android-bootstrap-debug`
- digest `sha256:5f3481dc4a9ffa756fabd03ff2b49f5874bd1bf8578d291ae2176fb295cf21a3`

### PR #31 — Permanent Android Build Gate
Final exact head: `e53572b0a4a24d810de22120de88069ba6ee49c9`.

Pre-merge exact-head evidence:
- `YadNegar CI` Run `33000840296`: success
- `YadNegar Android Build` Run `33000840285`: success
- artifact id `9618635116`, `yadnegar-debug-apk`, digest `sha256:3c48a6dac7b24dfe89a8d3aabeedd7e06cd3227d55ba08abbc54e149458a0728`

PR #31 merged as current main `1b31899d69d3f1fa98520dcc82a9251a7026cc09`.
Issue #28 completed.

### Post-Merge Main Proof
Exact main SHA `1b31899d69d3f1fa98520dcc82a9251a7026cc09`:
- `YadNegar CI` Run `33001323525`: success
- `YadNegar Android Build` Run `33001323462`: success
- Build debug APK / Verify / Upload: success
- artifact id `9618821948`
- name `yadnegar-debug-apk`
- size `66096365` bytes
- digest `sha256:6976da5fcdc8958c70d7b9b73df71053c4b47f6b6eb158793751e20754ec4604`
- expires 2026-09-02

Issue #6 closed completed from this exact post-merge evidence.

## Final CI Model
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Full Build Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Both use read-only permissions in permanent validation. Fast feedback remains separate from the slower build path.

## Wave 4 Product Expansion — ACTIVE
Issue #33 / PR #34: `feat(timeline): choose type during Quick Capture`.
Current exact head: `d0d206fd765dc5aa19963a971ac7c1eb4b9830ca`.

Implemented:
- Quick Capture type selector with visible Persian label
- existing `TimelineItemType` reused: note/event/call/idea/activity
- default remains note
- selected type passes to existing `QuickCapture.capture(type: ...)`
- edit dialog uses actual item type label
- widget coverage for Idea capture and Note default

Current validation at last sync:
- `YadNegar CI` Run `33001576158`: success
- `YadNegar Android Build` Run `33001576065`: running; do not merge until exact-head success + artifact + safe mergeability.

## Wave 5 Retrieval Foundation — ACTIVE IN PARALLEL
Issue #35 / PR #36: `feat(search): add Timeline search application foundation`.
Current exact head: `d56df46ce85f2ba7e96d9b98bc9fd53db2d138ca`.

Implemented in independent Application/Test files:
- `SearchTimeline`
- trimmed case-insensitive text query
- optional `TimelineItemType` filter
- combined query + type
- repository order preservation
- unmodifiable results
- independent unit tests

No Search UI, new Model, Repository or Storage was introduced.
Exact-head Fast CI and Android Build are running; merge only after both are Green and live mergeability is safe.

## Documentation Lane
PR #32 `docs: sync Android build and automation evidence` is the active docs synchronization lane.
This update records post-merge Android evidence, Issue #6 completion, PR #34 and PR #36 live state.
Merge only after its own exact-head docs CI is Green and GitHub reality is synchronized one final time.

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
- UI does not directly depend on storage implementation
- platform path plugin stays in composition root
- no fake build/persistence claims
- JSON storage remains a real replaceable MVP
- platform build files are committed and validated

## Automation Reality Outside GitHub
A separate YadNegar hourly continuation automation exists in the account but is currently disabled. Do not describe it as active.

## Next Real Actions
1. Finish exact-head Android Build for PR #34; inspect artifact and merge only if both gates Green + safe mergeability.
2. Finish both gates for PR #36; keep it independent from PR #34 unless main movement requires synchronization.
3. Validate main after each merge with Fast CI + Android Build where triggered.
4. Continue Wave 4 feature expansion and Wave 5 retrieval in non-conflicting lanes.
5. Final-sync/validate/merge docs PR #32.
6. Keep Issue #19 open until real Ruleset write capability exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel lanes, reuse, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
