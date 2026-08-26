# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `e2564db524bfcec17770adc28704c1925efcefc8`  
Commit: `platform: bootstrap durable Timeline persistence`

## Integrated Real Software
- Flutter/Dart Persian RTL foundation.
- Single Fast Quality Gate: `flutter pub get → flutter analyze → flutter test`.
- Shared Timeline Domain and `TimelineItem`.
- `TimelineRepository` + real JSON file-backed persistence.
- RTL Timeline UI shell.
- `QuickCapture`, `LoadTimeline`, `EditTimelineItem` application use cases.
- PR #23 merged as `329ad83c72dba8bf6e2747db6972ef7b9afcbf69`: real `Quick Capture → Persist → Load → Render` wiring.
- PR #26 merged as current main `e2564db524bfcec17770adc28704c1925efcefc8`: production bootstrap uses application-support storage and the shared repository.

## PR #23 Evidence
Final exact head: `a4bc2ffe6803017bc6d1279e4b63954c372d4d00`.
Run `32996798616`, job `quality`: Resolve dependencies, Analyze and Test all succeeded.
PR #23 merged with expected-head SHA lock. Issue #22 closed completed.

Historical failures on earlier PR #23 heads were diagnosed from real logs and fixed on the same branch. The final tests avoid `pumpAndSettle`/real-I/O deadlocks and the Quick Capture dialog avoids controller lifecycle races.

## Production Bootstrap — PR #26
Issue #24 → PR #26.
Branch head validated: `84b4a93be3c52e716be7f4399297ec49091630a8`.
Run `32997146108`, job `quality`: Resolve dependencies, Analyze and Test all succeeded.
Merged as `e2564db524bfcec17770adc28704c1925efcefc8`; Issue #24 closed completed.

Production now:
- obtains `getApplicationSupportDirectory()` via `path_provider`.
- creates one `JsonFileTimelineRepository` at `timeline.json` under the application-support directory.
- constructs `QuickCapture` and `LoadTimeline` on that same repository.
- runs `TimelineHome` as the real home.
- does not use system temp/current directory as pretend durable storage.
- keeps plugin/platform path dependency in the composition root, not Domain/UI.

`path_provider` is pinned through `^2.1.5` because the current CI uses Flutter 3.35; newer 2.1.6 raises its minimum to Flutter 3.38/Dart 3.10.

## Active Product PR — #27 View/Edit
Issue #25 → PR #27.
Branch: `feature/timeline-view-edit`.
Current head at this docs update: `8a6656e30a95e8b63889f103f0bf545a4b5caf48`.
Base: current main `e2564db524bfcec17770adc28704c1925efcefc8`.

Implemented:
- Timeline items expose a tap interaction when editing is available.
- RTL edit dialog edits the existing item text.
- save calls existing `EditTimelineItem.updateText`.
- repository metadata preservation remains owned by the existing use case.
- Timeline reloads through existing `LoadTimeline` after edit.
- empty edit is rejected with feedback.
- production composition injects `EditTimelineItem` using the same shared repository.
- widget tests cover edit/save/reload/render and empty-edit feedback.

Merge #27 only after exact-current-head `YadNegar CI` is completed Green and live mergeability is safe.

## Documentation PR — #3
Branch: `docs/yadnegar-documentation-baseline`.
Documentation/README only. Keep this branch synchronized with material implementation/CI/merge changes and merge only after exact-final-head Green CI.

## Issues
Completed implementation issues now include #4, #5, #9, #11, #13, #15, #17, #20, #22 and #24.

Active important issues:
- #6 — future real Full Build Gate only.
- #19 — require `YadNegar CI / quality` in the main Ruleset when actual Ruleset-write capability exists.
- #25 — View/Edit UI, owned by PR #27.

## Ruleset Reality
Ruleset `main-protection` id `20952887` remains active on `refs/heads/main`.
Rules currently prevent deletion/non-fast-forward and require Pull Requests.
It still does not platform-require `YadNegar CI / quality`.
Current connector exposes Ruleset read but no mutation action; do not invent a write.
Operational merge rule remains exact-current-head Green CI before merge.

## Vertical Slice
Target:
`Quick Capture → Persist → Timeline → View/Edit`

State:
- Domain: Integrated
- Repository/Persistence: Integrated
- Fast CI: Integrated
- RTL UI shell: Integrated
- Quick Capture: Integrated
- Load Timeline: Integrated
- Edit application logic: Integrated
- Capture/Persist/Load/Render: Integrated via PR #23
- Production-safe persistence bootstrap: Integrated via PR #26
- View/Edit UI + production edit wiring: PR #27 under validation

## Platform / Full Build
Repository still lacks a real committed Android/iOS/Desktop platform foundation.
Do not claim APK/IPA/Desktop build success yet.
Issue #6 remains for real platform foundation + actual `flutter build` + artifact evidence before any Full Build Gate is introduced.

## Automation Reality
GitHub CI automation is active with branch/PR validation, cache, concurrency and stale-run cancellation.
Main Ruleset required-status automation remains the Issue #19 gap.
A separate YadNegar hourly continuation task exists in the account but is currently disabled; do not describe it as active.

## Next Real Actions
1. Obtain exact-head CI for PR #27; inspect real Job/Steps and fix the same branch if needed.
2. Merge #27 only exact-head Green + safe mergeability, then validate main and Issue #25 closure.
3. Re-sync this docs branch to the post-#27 main and validate/merge PR #3.
4. Create and implement real Android platform foundation from fresh main.
5. Run a real Android build before adding Full Build Gate.
6. Keep Issue #19 open until actual Ruleset write support exists.

## Trigger
`ادامه یادنگار`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, reuse, small integration slices, automation, exact-ref CI and continuous documentation—not by skipping tests or evidence.
