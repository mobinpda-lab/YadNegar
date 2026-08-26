# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `c632570a8d09fffecc3ae27e9747f417888b9c5f`  
Commit: `feat(foundation): establish real Flutter RTL foundation`

PR #2 was merged on 2026-08-26. Flutter Foundation is now real `main` state.

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

The failed/queued jobs did not provide usable step/log evidence; a later log fetch returned no stored job log. These statuses are not proof of an application-code regression.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Scope remains documentation/README only: canonical operating package, comprehensive project document, active operation plan, current state, AI handoff, technical/product documentation and README map.

### PR #7 — CI consolidation
Branch: `ci/consolidate-flutter-gates`  
Current head: `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`

Scope:
- make `flutter-ci.yml` the single Fast Quality Gate
- `permissions: contents: read`
- branch/PR concurrency with `cancel-in-progress: true`
- Flutter cache
- explicit diagnostic step names
- `flutter pub get → flutter analyze → flutter test`
- remove placeholder `test.yml`
- remove placeholder `build.yml`

PR #7 was closed/reopened once and then received a fresh diagnostic commit to emit a new synchronize event. At the latest Audit, GitHub still reported zero workflow runs for branch `ci/consolidate-flutter-gates`. Do not merge without exact-head evidence.

### PR #8 — RTL Timeline shell
Branch: `ui/rtl-timeline-shell`  
Head: `5e459940fedf8a5b83cb9708396ca6ea7ca0a989`

Scope:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- Quick Capture entry contract disabled until persistence exists
- widget test for RTL/empty-state/disabled capture

The old placeholder `Test` workflow reported failure for PR #8, but the job had no executed steps/log evidence at inspection time. Treat this as unresolved CI evidence, not a verified UI failure.

### PR #10 — Timeline Domain contract
Branch: `core/timeline-item-contract`  
Head: `53825cc629fca1285e20c57bfdbc91369eabfb8c`

Scope:
- `TimelineItemType`: note/event/call/idea/activity
- storage/UI-independent `TimelineItem`
- `timelineAt` rule: `occurredAt ?? createdAt`
- domain tests for time behavior and shared types

No Persistence, Repository implementation, UI, Search, Reminder or Migration is included. No exact-head Actions run had been registered at the latest check.

## Closed / Integrated Work
- PR #1: closed without merge; historical CI-path experiment only.
- PR #2: merged; Flutter Foundation now on `main`.
- Issue #4: tracked PR #2; no duplicate Foundation work should be created.

## Active Issues / Ownership
- Issue #5 → PR #8 only for RTL/Timeline UI scope.
- Issue #6 → PR #7 only for Fast CI consolidation; Full Build Gate remains future work until a valid platform build path exists.
- Issue #9 → PR #10 only for the minimal Timeline Item Domain contract.

## Parallel Work Model
Lane A — Core / Domain / Foundation  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current real parallel wave:
- Lane A: PR #10 Timeline Domain contract.
- Lane B: PR #8 RTL Timeline shell.
- Lane C: PR #7 CI consolidation + PR #3 documentation baseline.

File boundaries are intentionally non-overlapping so a blocked Actions lane does not stop independent engineering work.

## Next Real Actions
1. Obtain exact-head GitHub Actions evidence for PR #7; merge CI consolidation first when trustworthy.
2. Revalidate PR #8 and PR #10 on the consolidated CI and merge only after analyze/test evidence.
3. Keep PR #3 synchronized and merge the documentation baseline after valid evidence.
4. After PR #10 is integrated, audit Persistence options against Timeline query, offline behavior, migration, recovery and testability.
5. Implement the first real vertical slice on the shared contract: `Quick Capture → Persist → Timeline → View/Edit`.

## Validation Rule
No report may call CI green without evidence from the exact ref being discussed.

Current target validation chain:
`flutter pub get → flutter analyze → flutter test`

Add `flutter build` only when a valid platform project/build path exists.

## Architecture Rules
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first UI
- reuse shared Foundation before adding new foundations
- no competing Model/Repository/Storage/Router/AppShell without explicit architectural justification
- no fake persistence or fabricated implementation state

## Documentation Rule
Meaningful implementation, CI evidence, current-state documentation and handoff move together. Conversation memory is never the only operational record.

## Continuation Protocol
`ادامه یادنگار` means:
`Audit live GitHub → reconcile docs → inspect open PRs/issues → choose nearest real gaps → parallelize non-conflicting work → execute → validate exact refs → document → report briefly`

## Speed Rule
Produce verified useful software in hours rather than days through parallel independent work, small PRs, automation, reuse and fast feedback—not by skipping quality or evidence.
