# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `0610c401eb5a31a68552be047bc3d765696c2f33`  
Commit: `feat(core): define minimal Timeline Item contract`

Main contains:
- Flutter/Dart foundation
- Persian RTL baseline
- baseline widget test
- consolidated `YadNegar CI`
- shared `TimelineItem` Domain contract

## Integrated Work
### PR #2 — Flutter Foundation
Merged. Issue #4 closed.
Validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be`: `flutter pub get`, `flutter analyze`, `flutter test` successful.

### PR #7 — Fast CI consolidation
Merged as `9999e31f7aa2fa4717c5f027319e356ca705bebe`.
Validated head `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`.
`YadNegar CI` run `32987365151`: success with real Checkout, Flutter setup, dependency resolution, Analyze and Test steps.

Integrated CI:
- one Fast Quality Gate
- `permissions: contents: read`
- concurrency + `cancel-in-progress: true`
- Flutter cache
- old placeholder `test.yml` removed
- old placeholder `build.yml` removed

Issue #6 remains open only for a future real Full Build Gate after a valid Platform build path exists.

### PR #10 — Timeline Domain contract
Merged as current main `0610c401eb5a31a68552be047bc3d765696c2f33`.
Validated head `53825cc629fca1285e20c57bfdbc91369eabfb8c`.
Flutter CI run `32987199672`: `flutter pub get`, `flutter analyze`, `flutter test` successful.

Integrated contract:
- `TimelineItemType`: note/event/call/idea/activity
- `TimelineItem`
- `timelineAt = occurredAt ?? createdAt`
- Domain tests

Issue #9 closed/completed. Do not create a competing Timeline model.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Scope: Documentation/README only.
Must remain synchronized with actual GitHub state and exact CI evidence.

### PR #8 — RTL Timeline UI shell
Branch: `ui/rtl-timeline-shell`  
Current head: `3b7ac04e401bfdc5b88f36eeed614c294a84e6df`

Scope:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- Quick Capture entry contract disabled until persistence integration
- accessibility tooltip for Quick Capture
- widget tests for RTL/empty-state/disabled capture/tooltip

Issue #5 owns this scope. Old Actions failures without runner/steps are not application-failure evidence. Merge only after current exact-head successful `YadNegar CI` evidence and live mergeability.

### PR #12 — JSON Timeline persistence
Branch: `persistence/json-timeline-repository`  
Current head: `0dbe99146be2b33f50ed28d3259bd0f0c5741cc4`
Issue #11 owns this scope.

Implemented:
- Domain `TimelineRepository`
- `JsonFileTimelineRepository`
- real file persistence via `dart:io`
- schema version `1`
- upsert/findById/listNewestFirst
- duplicate prevention by id
- ordering by effective `timelineAt`
- deterministic tie-break
- reload-from-disk tests with temporary directories
- fail-fast unsupported-schema test

No external storage dependency. JSON persistence is an intentionally small, offline, testable and replaceable MVP implementation, not the declared final database.

### PR #14 — CI active-lane push coverage
Branch: `ci/expand-active-branch-gates`  
Current head: `669e11bbcde79bc17dbb4c53e0435eed8a5cd792`
Issue #13 owns this scope.

Purpose: extend the existing single `YadNegar CI` push filters to:
- `core/**`
- `persistence/**`
- `docs/**`
while preserving main/ci/fix/feature/ui paths, pull-request validation, concurrency and stale-run cancellation.

This is an automation extension, not a second CI path. Merge only after exact-head green evidence.

### PR #16 — Quick Capture application use case (stacked)
Branch: `feature/quick-capture-use-case`  
Current head: `2c2f9f433e92ae3c3d275371c8ad5d0264e2fd0`
Current base: `persistence/json-timeline-repository`
Issue #15 owns this scope.

This PR is intentionally stacked on PR #12 because it depends on the new `TimelineRepository` contract. After PR #12 merges, retarget PR #16 to `main`.

Implemented:
- `QuickCapture` application use case
- injected clock and ID generator
- text trimming
- empty-text rejection
- empty-ID rejection
- creation of existing `TimelineItem`
- persistence only through `TimelineRepository`
- unit tests with a recording repository, independent of UI/file system

No duplicate Model/Repository/Storage was created.

## Active Issues / Ownership
- Issue #5 → PR #8 UI only.
- Issue #6 → future Full Build Gate only; Fast Gate integrated.
- Issue #9 → completed by PR #10.
- Issue #11 → PR #12 Persistence only.
- Issue #13 → PR #14 CI push coverage only.
- Issue #15 → PR #16 Quick Capture application logic only.

## Parallel Work Model
Lane A — Core / Persistence / Application  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current coordinated wave:
- Lane A1: PR #12 real JSON persistence.
- Lane A2: PR #16 stacked Quick Capture application logic.
- Lane B: PR #8 RTL Timeline UI.
- Lane C1: PR #14 push-gate automation.
- Lane C2: PR #3 documentation sync.

Dependencies are explicit: PR #16 depends on PR #12; other active scopes remain file-separated.

## Current Actions Reality
Known valid evidence exists for merged PR #7 and #10.
At the latest checks, new exact heads for PR #8, #12, #14 and #16 had not yet appeared as workflow runs. The repository-wide Actions list also had not yet surfaced newer runs after the previously integrated CI activity.

Interpretation rule:
- zero runs is neither success nor failure.
- do not merge without exact-head execution.
- when a run appears, inspect Job/Steps before diagnosing code.
- continue independent implementation/documentation while Actions events are delayed.

## Product Direction
First real vertical slice:
`Quick Capture → Persist → Timeline → View/Edit`

Progress:
- Shared Timeline Domain: integrated.
- Fast CI: integrated.
- Timeline UI shell: PR #8 active.
- Real Persistence: PR #12 active.
- Quick Capture application logic: PR #16 active/stacked.
- Next after integrations: wire UI → QuickCapture → TimelineRepository and render real Timeline data; then add View/Edit on the same contract.

## Persistence Decision
File-backed JSON is the MVP because the repository currently has no external storage package or complete Platform build foundation. It is offline, dependency-free, CI-testable and replaceable behind a Domain port.

A future database decision must be justified by real query volume, indexing, migration, backup/recovery, performance and platform requirements.

## Validation Rule
No report may call CI green without exact-ref evidence.
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Add `flutter build` only when a valid Platform project/build path exists and the build really executes.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first UI
- Reuse before rebuild
- no duplicate App Shell
- no competing Timeline model
- no competing Repository/Storage foundation
- no duplicate CI path
- no fake persistence claims
- no duplicate canonical documentation

## Next Real Actions
1. Poll exact-head Actions for PR #8/#12/#14/#16 in parallel.
2. Fix any real failing step immediately on the same branch.
3. Merge PR #14 when green to make all active lanes validate on push.
4. Merge PR #12 when green, then retarget PR #16 to `main` and revalidate.
5. Merge PR #8 only after current-head green evidence and live mergeability; if main drift causes a real conflict, resolve by synchronizing the same branch rather than creating another App Shell PR.
6. After #8/#12/#16 integration, create the small wiring PR for real Quick Capture → persisted Timeline.
7. Keep PR #3 synchronized with every material merge/evidence change.
8. Add Full Build Gate only when Platform foundation exists.

## Continuation Trigger
`ادامه یادنگار`

Meaning:
`Audit live GitHub → reconcile docs → avoid duplicate work → parallel execute → validate exact refs → merge safe work → continue vertical slice → document → short report`

## Report Style
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
Keep owner-facing reports short, simple and nontechnical.

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
