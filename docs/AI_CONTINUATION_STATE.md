# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

This file is the operational continuation snapshot for moving work between ChatGPT sessions. Always fresh-audit GitHub before any write or merge.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `0610c401eb5a31a68552be047bc3d765696c2f33`  
Commit: `feat(core): define minimal Timeline Item contract`

Main now contains:
- Flutter/Dart foundation
- Persian RTL shell baseline
- baseline widget test
- consolidated `YadNegar CI`
- shared `TimelineItem` Domain contract

## Integrated Work
### PR #2 — Flutter Foundation
Merged. Issue #4 closed.
Validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` had successful `flutter pub get`, `flutter analyze`, `flutter test`.

### PR #7 — CI consolidation
Merged to main as:
`9999e31f7aa2fa4717c5f027319e356ca705bebe`

Exact validated PR head:
`a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`

`YadNegar CI` run `32987365151`: success.
Job `quality` executed successfully:
- Checkout
- Flutter setup
- dependency resolution
- analyze
- test

Main CI result:
- one Fast Quality Gate
- `permissions: contents: read`
- concurrency + `cancel-in-progress: true`
- Flutter cache
- explicit diagnostic step names
- old placeholder `test.yml` removed
- old placeholder `build.yml` removed

Issue #6 remains open only for a future real Full Build Gate after a valid Platform build path exists.

### PR #10 — Timeline Domain contract
Merged to main as current SHA:
`0610c401eb5a31a68552be047bc3d765696c2f33`

Exact validated head:
`53825cc629fca1285e20c57bfdbc91369eabfb8c`

Flutter CI run `32987199672`: success.
Executed successfully:
- `flutter pub get`
- `flutter analyze`
- `flutter test`

Integrated contract:
- `TimelineItemType`: note/event/call/idea/activity
- `TimelineItem`
- `timelineAt = occurredAt ?? createdAt`
- Domain tests

Issue #9 is closed/completed. Do not create a competing Timeline model for this scope.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Scope: Documentation/README only.
This PR must remain synchronized with actual GitHub state and exact CI evidence.

### PR #8 — RTL Timeline UI shell
Branch: `ui/rtl-timeline-shell`  
Current head: `3b7ac04e401bfdc5b88f36eeed614c294a84e6df`

Current scope:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- Quick Capture entry contract disabled until persistence is integrated
- accessibility tooltip for Quick Capture
- widget tests for RTL/empty-state/disabled capture/tooltip

Latest commits:
- `0497ab530f7b12a4e940c3e14a1308303accaf53` — accessibility tooltip
- `3b7ac04e401bfdc5b88f36eeed614c294a84e6df` — accessibility contract test

Old failed Actions runs without executed steps/runner are not application-failure evidence. Merge only after the current exact head gets real successful `YadNegar CI` evidence.

Issue #5 owns this scope. Do not create another App Shell/Timeline UI foundation.

### PR #12 — JSON Timeline persistence
Branch: `persistence/json-timeline-repository`  
Current head: `0dbe99146be2b33f50ed28d3259bd0f0c5741cc4`

Issue #11 owns this scope.

Implemented:
- Domain `TimelineRepository`
- `JsonFileTimelineRepository`
- real file persistence with `dart:io`
- schema version `1`
- `upsert`
- `findById`
- `listNewestFirst`
- duplicate prevention by id
- ordering by effective `timelineAt`
- deterministic tie-break
- reload-from-disk tests using temporary directories
- fail-fast for unsupported schema versions

No external storage dependency was added. JSON file persistence is an intentionally small, offline, testable and replaceable MVP implementation—not the declared final database.

Out of scope for PR #12:
- SQLite/Isar/Hive final choice
- encryption
- backup/export
- search/indexing
- reminders
- Platform build setup

Merge only after exact-head `YadNegar CI` runs `flutter pub get → flutter analyze → flutter test` successfully.

## Active Issues / Ownership
- Issue #5 → PR #8 UI only.
- Issue #6 → Full Build Gate future scope; Fast Gate already integrated through PR #7.
- Issue #9 → completed by merged PR #10.
- Issue #11 → PR #12 persistence only.

## Parallel Work Model
Lane A — Core / Persistence  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current real parallel wave:
- Lane A: PR #12 real JSON persistence.
- Lane B: PR #8 RTL Timeline UI.
- Lane C: consolidated CI already integrated + PR #3 documentation sync.

File boundaries are intentionally non-overlapping so one lane does not stop the others.

## Product Direction
YadNegar is a Persian RTL, Timeline-oriented, capture-first application.

First real vertical slice:
`Quick Capture → Persist → Timeline → View/Edit`

Progress toward it:
- Shared Timeline Domain: integrated.
- Fast CI: integrated.
- Timeline UI shell: PR #8 active.
- Real Persistence: PR #12 active.
- Next connection: Quick Capture must write through `TimelineRepository` and Timeline must read real data.

## Persistence Decision
The repository currently has no external storage package or complete Platform build foundation. For the first vertical slice, file-backed JSON is being used because it is:
- offline
- dependency-free
- testable in CI
- replaceable behind a Domain port
- sufficient for the first save/list/view/edit loop

This does not prevent a later migration to a database. A future database decision must be justified by real query volume, migration, backup/recovery, indexing, performance and platform requirements.

## Validation Rule
No report may call CI green without exact-ref evidence.

Current Fast Gate:
`flutter pub get → flutter analyze → flutter test`

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
1. Fresh-check exact-head Actions for PR #8 and PR #12 in parallel.
2. Fix any real failing step immediately; do not guess from run-level status alone.
3. Merge each PR only after exact-head successful analyze/test evidence and live mergeability check.
4. After persistence/UI integration, create the next small vertical-slice PR connecting Quick Capture → Repository → real Timeline data.
5. Keep PR #3 synchronized with every material merge/evidence change.
6. Add Full Build Gate only when a real Platform build foundation exists.

## Documentation Rule
Meaningful implementation, CI evidence, current-state documentation and handoff move together. Conversation memory is never the only operational record.

## Continuation Trigger
`ادامه یادنگار`

Meaning:
`Audit live GitHub → reconcile docs → inspect active PRs/issues → choose nearest real gaps → parallelize non-conflicting work → execute → validate exact refs → document → report briefly`

## Report Style
Owner-facing report:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Keep it short, simple and nontechnical. Clearly distinguish Actual, Plan and Blocked work.

## Speed Rule
Produce verified useful software in hours rather than days through coordinated parallel work, small PRs, automation, reuse and fast feedback—not by skipping tests, evidence or safe integration.
