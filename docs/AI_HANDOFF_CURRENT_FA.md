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
- PR #8 UI — merge `0cb8bbd3...`, exact head `30c3765...`, run `32990720534` success.
- PR #16 Quick Capture — merge `e56c71f3...`, exact head `8e3c3d1...`, run `32990963329` success.
- PR #21 Load Timeline — merge `c988f746...`, exact head `8c84d754...`, run `32991379013` success.
- PR #18 Edit Timeline — merge/current main `f1b96756...`, exact head `91627ca...`, run `32991761859` success.

## Current active implementation
### PR #23 — first real capture/persist/load/render wiring
Issue #22 → PR #23 only.
Branch: `feature/timeline-vertical-slice`
Head: `4e63a58fab55fa99f3a509b642ced9b266a60e08`
Base re-triggered against current main `f1b96756...`.

Implemented:
- TimelineScreen renders loading/error/real items.
- TimelineHome coordinates load, Quick Capture dialog, capture, reload and render.
- UI has no direct `dart:io` dependency.
- widget vertical-slice test injects real JsonFileTimelineRepository on temp file.
- test proves UI → capture → disk persist → reload → Timeline render.
- second repository instance reloads same file.
- empty capture gives feedback and does not persist.

Production main is intentionally not wired to temp/current-directory storage. Exact-current-head CI required before merge.

### Issue #24 — production-safe bootstrap next
After PR #23 merge:
- use platform-safe app documents/support location (proposed `path_provider`)
- construct one JsonFileTimelineRepository
- construct QuickCapture + LoadTimeline on same repository
- run TimelineHome in production
- keep plugin out of Domain/UI
- never use system temp/current directory as fake durable production storage

### PR #3 — docs
Canonical docs branch remains active and synchronized. `docs/**` receives Push CI.

### Issue #19 — ruleset hardening
Active ruleset `main-protection` id `20952887` requires PRs but not yet `YadNegar CI / quality` as required status.
Current connector is read-only for Ruleset mutation. Operational rule: exact-current-head Green before merge.

## Vertical Slice status
Target: `Quick Capture → Persist → Timeline → View/Edit`

- Domain: Integrated
- CI: Integrated
- Persistence: Integrated
- UI shell: Integrated
- Quick Capture: Integrated
- Load Timeline: Integrated
- Edit application logic: Integrated
- Capture/Persist/Load/Render wiring: PR #23
- production platform-safe bootstrap: Issue #24 next
- Edit UI: next wave using integrated EditTimelineItem

## Validation
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Evidence only for exact workflow `head_sha`; inspect Job/Steps for failures.
`flutter build` only after real Platform project foundation.

## Architecture
Reuse before rebuild. No second Foundation/AppShell/Timeline Model/Repository/Storage/CI. UI must not directly depend on storage implementation or platform path plugin. DB later only with justified query/index/migration/recovery/performance needs.

## Continue
1. Check exact-head Actions for PR #23; fix same branch if real failure.
2. Merge #23 only exact-head Green + safe mergeability; validate main.
3. Start Issue #24 platform-safe production bootstrap from post-#23 main.
4. Start View/Edit UI using integrated EditTimelineItem in a separate non-conflicting lane.
5. Keep PR #3 synced/Green.
6. Apply Issue #19 only with actual Ruleset write support.
7. Real Platform foundation before Full Build Gate.

## Automation
Hourly continuation task is enabled for live audit, parallel implementation, exact-ref validation, safe merge, docs sync and short Persian reporting.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
