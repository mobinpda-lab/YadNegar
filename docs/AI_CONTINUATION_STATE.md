# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

This file is the operational continuation snapshot for moving work between ChatGPT sessions. It is not a substitute for a fresh live GitHub audit.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `c632570a8d09fffecc3ae27e9747f417888b9c5f`  
Commit: `feat(foundation): establish real Flutter RTL foundation`

PR #2 was merged on 2026-08-26. Issue #4 is closed as completed. Flutter Foundation is real `main` state and no duplicate Foundation should be created.

Verified Foundation on `main` includes:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`
- minimal Persian RTL app shell
- baseline widget test

PR #2 exact head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` had successful `flutter pub get`, `flutter analyze` and `flutter test` before merge.

## Current CI Reality
After Foundation merged, `main` temporarily contains three workflows:
- `.github/workflows/flutter-ci.yml` — real Flutter validation
- `.github/workflows/test.yml` — old placeholder
- `.github/workflows/build.yml` — old placeholder

For main SHA `c632570...` the observed workflow state included:
- Flutter CI run `32984360283`: completed / failure
- Test run `32984476621`: completed / startup_failure
- Build run `32984471010`: queued at the observed snapshot

The failed/queued jobs did not provide usable step/log evidence. These statuses are not proof of an application-code regression.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
State at latest live audit: open, non-draft, mergeable.
Scope remains documentation/README only: canonical operating package, comprehensive project document, active operation plan, current state, AI handoff, technical/product documentation and README map.

### PR #7 — CI consolidation
Branch: `ci/consolidate-flutter-gates`  
Current head: `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`  
State at latest live audit: open, non-draft, mergeable.

Scope:
- make `flutter-ci.yml` the single Fast Quality Gate
- `permissions: contents: read`
- branch/PR concurrency with `cancel-in-progress: true`
- Flutter cache
- explicit diagnostic step names
- `flutter pub get → flutter analyze → flutter test`
- remove placeholder `test.yml`
- remove placeholder `build.yml`

PR #7 was closed/reopened once and then received a fresh diagnostic commit to emit a new synchronize event. At the latest live audit, exact-head workflow lookup for `a6d81645...` still returned zero runs. Do not merge without exact-head evidence.

### PR #8 — RTL Timeline shell
Branch: `ui/rtl-timeline-shell`  
Head: `5e459940fedf8a5b83cb9708396ca6ea7ca0a989`  
State at latest live audit: open, non-draft, mergeable.

Scope:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- Quick Capture entry contract disabled until persistence exists
- widget test for RTL/empty-state/disabled capture

Exact-head Actions now show two failed runs:
- Flutter CI run `32986361005`: completed / failure
- old Test run `32986016461`: completed / failure

Important evidence detail for Flutter CI run `32986361005`: the returned job `98233297567` still reports `status: queued`, no runner, `conclusion: null`, and `steps: []` although the workflow run reports completed/failure. Therefore this still does not prove a UI/code failure. Treat it as unresolved Actions/runner evidence until a real job with executed steps exists.

### PR #10 — Timeline Domain contract
Branch: `core/timeline-item-contract`  
Head: `53825cc629fca1285e20c57bfdbc91369eabfb8c`  
State at latest live audit: open, non-draft, mergeable.

Scope:
- `TimelineItemType`: note/event/call/idea/activity
- storage/UI-independent `TimelineItem`
- `timelineAt` rule: `occurredAt ?? createdAt`
- domain tests for time behavior and shared types

No Persistence, Repository implementation, UI, Search, Reminder or Migration is included. Exact-head workflow lookup at the latest live audit still returned zero runs.

## Closed / Integrated Work
- PR #1: closed without merge; historical CI-path experiment only.
- PR #2: merged; Flutter Foundation now on `main`.
- Issue #4: closed/completed after PR #2; no duplicate Foundation work.

## Active Issues / Ownership
- Issue #5 → PR #8 only for RTL/Timeline UI scope.
- Issue #6 → PR #7 only for Fast CI consolidation; Full Build Gate remains future work until a valid platform build path exists.
- Issue #9 → PR #10 only for the minimal Timeline Item Domain contract.

Do not create competing Branches/PRs/Models/AppShells/Storage/CI for these active scopes.

## Parallel Work Model
Lane A — Core / Domain / Foundation  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current real parallel wave:
- Lane A: PR #10 Timeline Domain contract.
- Lane B: PR #8 RTL Timeline shell.
- Lane C: PR #7 CI consolidation + PR #3 documentation baseline.

File boundaries are intentionally non-overlapping so a blocked Actions lane does not stop independent engineering work.

## Product Direction
YadNegar is a Persian RTL, Timeline-oriented, capture-first application.

Near-term shared concepts:
- Note
- Event
- Call
- Idea
- Activity
- Quick Capture
- Timeline
- date/time handling
- View/Edit

First real vertical slice target:
`Quick Capture → Persist → Timeline → View/Edit`

Later phases may add Search, Filtering, Reminder, Backup, Export and Recovery after the shared foundation is stable.

## Persistence Rule
Do not jump directly to a database after PR #10. Audit persistence against:
- offline behavior
- Timeline/date sorting and query patterns
- schema migration
- backup/recovery
- export
- testability
- performance
- Flutter ecosystem support
- maintainability

Choose one shared persistence foundation; do not create competing storage/repository layers.

## Next Real Actions
1. Fresh-audit `main`, PR #3/#7/#8/#10, Issues #5/#6/#9 and exact-head Actions before any write/merge.
2. Obtain trustworthy exact-head GitHub Actions evidence for PR #7; merge CI consolidation first only when the real Fast Gate executes successfully.
3. After PR #7 merge, revalidate PR #8 and PR #10 using the consolidated CI; merge only after exact-head analyze/test evidence.
4. Keep PR #3 synchronized with every material merge/evidence change and merge the documentation baseline after valid evidence.
5. After PR #10 is integrated, audit Persistence options and implement the first real vertical slice: `Quick Capture → Persist → Timeline → View/Edit`.

## Validation Rule
No report may call CI green without evidence from the exact ref being discussed.

Current target validation chain:
`flutter pub get → flutter analyze → flutter test`

Add `flutter build` only when a valid platform project/build path exists and the build really executes.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first UI
- reuse shared Foundation before adding new foundations
- no competing Model/Repository/Storage/Router/AppShell without explicit architectural justification
- no fake persistence or fabricated implementation state
- no duplicate documentation governance

## Documentation Rule
Meaningful implementation, CI evidence, current-state documentation and handoff move together. Conversation memory is never the only operational record.

## Continuation Trigger
`ادامه یادنگار`

Meaning:
`Audit live GitHub → reconcile docs → inspect open PRs/issues → choose nearest real gaps → parallelize non-conflicting work → execute → validate exact refs → document → report briefly`

## Report Style
Keep owner-facing reports short and nontechnical:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Distinguish clearly between Actual, Plan and Blocked work.

## Speed Rule
Produce verified useful software in hours rather than days through parallel independent work, small PRs, automation, reuse and fast feedback—not by skipping quality or evidence.
