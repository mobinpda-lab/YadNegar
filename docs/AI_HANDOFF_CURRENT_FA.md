# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `f1b96756c501da517d25c3610341bdc81e2d5fb5`  
Commit: `feat(edit): add Timeline item text edit use case`

## Integrated real software
- PR #2 Foundation — Flutter/Dart, Persian RTL baseline, tests.
- PR #7 Fast CI — merge `9999e31...`, run `32987365151` success.
- PR #10 Domain — merge `0610c401...`, run `32987199672` success.
- PR #12 Persistence — merge `cc00db09...`, exact-head CI success; `TimelineRepository` + real JSON disk storage.
- PR #14 CI Automation — merge `bb6f976...`, run `32989549391` success; active lane Push coverage.
- PR #8 UI — merge `0cb8bbd3...`, exact head `30c3765...`, run `32990720534` success; stale Issue #5 was later closed as completed.
- PR #16 Quick Capture — merge `e56c71f3...`, exact head `8e3c3d1...`, run `32990963329` success.
- PR #21 Load Timeline — merge `c988f746...`, exact head `8c84d754...`, run `32991379013` success.
- PR #18 Edit Timeline — merge/current main `f1b96756...`, exact head `91627ca...`, run `32991761859` success.

## Current active implementation
### PR #23 — capture/persist/load/render wiring
Issue #22 → PR #23 only.
Branch: `feature/timeline-vertical-slice`
Current head: `116606586870f0869a9c2278c16838e6c40c2c50`
Base: current main `f1b96756...`.

Implemented:
- TimelineScreen renders loading/error/empty/real items.
- TimelineHome coordinates load, Quick Capture dialog, capture, reload and render.
- UI has no direct `dart:io` dependency.
- vertical-slice widget test injects real JsonFileTimelineRepository on temp file.
- test verifies UI → capture → disk persist → reload → Timeline render.
- second repository instance reloads the same file.
- empty capture gives feedback and does not persist.

### Real failure and same-branch fix
Historical exact head `4e63a58...` had real CI failure in run `32993286618`.
The `quality` job showed dependency resolution and Analyze success, then Test failure.
The real log showed both vertical-slice tests timing out on initial `pumpAndSettle` while real asynchronous file I/O and an indeterminate loading animation were active.

Same branch was fixed with commit/head:
`116606586870f0869a9c2278c16838e6c40c2c50`
`test(timeline): synchronize widget test with real file IO`

Current exact-head CI run at this handoff update:
`32996282933` — `YadNegar CI` — in progress/pending final conclusion.
Do not merge until exact-head Green + live safe mergeability.

### Issue #24 — production-safe bootstrap next
After PR #23 merge:
- use platform-safe app documents/support location, proposed `path_provider`
- construct one JsonFileTimelineRepository
- construct QuickCapture + LoadTimeline on the same repository
- run TimelineHome in production
- keep plugin out of Domain/UI
- never use system temp/current directory as fake durable production storage

### Issue #25 — View/Edit UI next
New live Issue #25 owns:
`Timeline item tap → edit text → EditTimelineItem → repository upsert → LoadTimeline → refreshed UI`
No duplicate Model/Repository/Storage. Start implementation from fresh post-#23 main.

### PR #3 — docs
Canonical docs branch remains active and is being synchronized in parallel. Validate the exact final docs head before merge.

### Issue #19 — ruleset hardening
Active ruleset `main-protection` id `20952887` requires PRs and prevents deletion/non-fast-forward, but still does not require `YadNegar CI / quality` as a platform status check.
Current connector exposes Ruleset read but no Ruleset write action. Operational rule remains exact-current-head Green before merge.

## Vertical Slice status
Target: `Quick Capture → Persist → Timeline → View/Edit`

- Domain: Integrated
- CI: Integrated
- Persistence: Integrated
- UI shell: Integrated
- Quick Capture: Integrated
- Load Timeline: Integrated
- Edit application logic: Integrated
- Capture/Persist/Load/Render wiring: PR #23, same-branch CI fix under validation
- production platform-safe bootstrap: Issue #24 next
- View/Edit UI: Issue #25 next

## Validation
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Evidence only for exact workflow `head_sha`; inspect Job/Steps/logs for failures.
`flutter build` only after real Platform project foundation and actual successful build execution.

## Architecture
Reuse before rebuild. No second Foundation/AppShell/Timeline Model/Repository/Storage/CI. UI must not directly depend on storage implementation or platform path plugin. DB later only with justified query/index/migration/recovery/performance needs.

## Automation reality
A YadNegar hourly continuation task exists but is currently disabled. Do not claim hourly execution is active unless a fresh automation audit shows it enabled.
GitHub CI automation itself is active.

## Continue
1. Check exact-head run `32996282933` for PR #23.
2. If Green, verify PR head/mergeability and merge with expected-head SHA lock.
3. Validate new main and Issue #22 closure.
4. Start Issue #24 bootstrap from post-#23 main.
5. Start Issue #25 View/Edit UI in a separate coordinated lane.
6. Keep PR #3 synced and exact-head Green before merge.
7. Keep Issue #19 open until actual Ruleset write support exists.
8. Create real Platform foundation before Full Build Gate.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
