# YadNegar — Live AI Handoff

## قانون اصلی
مرجع عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

GitHub Reality همیشه مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.

## Repository
`mobinpda-lab/YadNegar`
Default branch: `main`
آخرین main تأییدشده: `bb6f97672e446973df94674f6ae16a8dbfd3d930`
Commit: `ci: validate all active lanes on push`

## Integrated روی main
### Foundation — PR #2
Flutter/Dart + Persian RTL baseline + tests. Issue #4 بسته.

### Fast CI — PR #7
Merge: `9999e31f7aa2fa4717c5f027319e356ca705bebe`
Validated head: `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`
Run `32987365151`: success.
Gate: `flutter pub get → flutter analyze → flutter test`.

### Timeline Domain — PR #10
Merge: `0610c401eb5a31a68552be047bc3d765696c2f33`
Validated head: `53825cc629fca1285e20c57bfdbc91369eabfb8c`
Run `32987199672`: success.
Shared contract: `TimelineItem`, types and `timelineAt`.

### Persistence — PR #12
Merge: `cc00db09863592b6b3ccb89de05aa1c428dbb5e7`
Exact-head CI successful.
Integrated `TimelineRepository` + real `JsonFileTimelineRepository`, schema 1, upsert/find/list, ordering, duplicate prevention and reload tests.
JSON is a replaceable offline MVP, not the declared final database.

### CI Automation — PR #14
Merge/current main: `bb6f97672e446973df94674f6ae16a8dbfd3d930`
Validated head: `669e11bbcde79bc17dbb4c53e0435eed8a5cd792`
Run `32989549391`: Resolve dependencies + Analyze + Test success.
Single CI now validates Push on `main`, `ci/**`, `fix/**`, `feature/**`, `ui/**`, `core/**`, `persistence/**`, `docs/**` and PRs to main.

## موج موازی فعال
### PR #8 — UI
Issue #5 → PR #8 only.
Branch: `ui/rtl-timeline-shell`
Head: `30c3765231e38146b8b14e03a35e05cc3b91f0c4`

Implemented:
- TimelineScreen / Persian RTL / empty state
- disabled Quick Capture contract until wiring
- tooltip/accessibility
- stable keys `timeline-empty-state`, `quick-capture-action`
- widget tests

Older head `3b7ac04...` has successful CI, but current `30c3765...` still requires exact-head Green. PR was close/reopened on same branch to emit fresh current-head event.

### PR #16 — Quick Capture
Issue #15 → PR #16 only.
Branch: `feature/quick-capture-use-case`
Head: `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`
Base: main.

Implemented:
- `QuickCapture`
- injected clock/id
- trim + empty validation
- reuse TimelineItem/TimelineRepository
- default type = note
- unit tests independent of UI/file system

Older run on `8067f45...` is Green but not exact-current-head evidence. Current PR was close/reopened to emit a fresh event.

### PR #18 — Edit Timeline Item
Issue #17 → PR #18 only.
Branch: `feature/edit-timeline-item`
Head: `91627cae4cdc7e4db2741693419debd081c04a87`

Implemented:
- `EditTimelineItem`
- validate/normalize id and text
- find existing item
- preserve metadata, replace text
- persist through existing Repository
- unit tests for success and failures

No duplicate model/repository/storage. Current exact-head CI pending registration; same PR was close/reopened to emit event.

### PR #21 — Load Timeline
Issue #20 → PR #21 only.
Branch: `feature/load-timeline`
Head: `8c84d754c5061641886497a4354b2aa115a4d752`

Implemented:
- `LoadTimeline`
- read only through `listNewestFirst`
- unmodifiable snapshot
- optional positive limit
- tests for order/limit/immutability/validation

No UI/storage duplication. Current exact-head CI pending registration.

### PR #3 — Documentation
Canonical docs branch remains active and is synchronized with real merges, PRs, CI evidence and blockers. `docs/**` now gets direct Push CI.

## Ruleset Automation Gap
Issue #19 tracks GitHub hardening.
Active ruleset `main-protection` id `20952887` targets main and prevents deletion/non-fast-forward while requiring PRs.
It does NOT yet require the `YadNegar CI / quality` status check.
Current connector exposes Ruleset read only, so do not claim this rule was changed. Until write support exists, operational policy remains: merge only exact-current-head Green PRs.

## Vertical Slice
Target:
`Quick Capture → Persist → Timeline → View/Edit`

Status:
- Domain: Integrated
- Fast CI: Integrated
- Persistence: Integrated
- CI push automation: Integrated
- UI: PR #8
- Quick Capture: PR #16
- Edit application logic: PR #18
- Load Timeline: PR #21

Nearest integration after Green merges:
`UI action → QuickCapture → TimelineRepository → persisted item → LoadTimeline → render`.
Then View/Edit UI consumes `EditTimelineItem`.

## Actions Rule
GitHub Actions indexing can be delayed.
- zero runs ≠ success/failure
- historical run ≠ current-head evidence
- workflow `head_sha` is the evidence SHA
- diagnose only from real Job/Steps
- merge only exact-current-head Green

## معماری
Reuse before rebuild. No second Foundation/AppShell/Timeline Model/Repository/Storage/CI. UI must not depend directly on `dart:io`. DB later only with justified query/index/migration/recovery/performance needs.

## Validation
`flutter pub get → flutter analyze → flutter test`
`flutter build` only after real Platform foundation.

## ادامه
1. Audit main + PR #3/#8/#16/#18/#21 and exact Actions.
2. Fix real failures on same branch.
3. Merge exact-head Green work with expected head SHA.
4. Sync docs with every material merge/evidence change.
5. After #8/#16/#21, create small wiring PR for real capture → persist → load → render.
6. After #18, connect View/Edit UI.
7. Apply Issue #19 only when actual Ruleset write support is available.
8. Add Full Build Gate only after Platform foundation.

## Automation ادامه
Hourly continuation task is enabled for live audit, parallel implementation, exact-ref validation, safe merge, docs sync and short Persian owner report.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
کوتاه، ساده و غیرفنی.
