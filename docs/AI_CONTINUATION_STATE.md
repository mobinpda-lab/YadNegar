# YadNegar AI Continuation State

Last updated: 2026-08-26

## Source of Truth
`GitHub Reality > approved architecture decisions > docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md > exact CI/workflow evidence > conversation memory`

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main SHA: `c632570a8d09fffecc3ae27e9747f417888b9c5f`  
Commit: `feat(foundation): establish real Flutter RTL foundation`

PR #2 was merged on 2026-08-26. Flutter Foundation is now real `main` state, not only a target.

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

Do not infer an application-code regression from those statuses without exact job evidence. The repository already has a dedicated consolidation PR to remove the ambiguous three-workflow state.

## Active Pull Requests
### PR #3 — Canonical documentation baseline
Branch: `docs/yadnegar-documentation-baseline`
Status: open / documentation-only.

Package includes:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `PROJECT_DOCUMENTATION_FA.md`
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md`
- updated `README.md`

This PR must remain documentation/README-only and be merged only after exact-ref validation is satisfactory.

### PR #7 — CI consolidation
Branch: `ci/consolidate-flutter-gates`
Head at creation: `f8cfea3747745ba87184d300b6c3203b0c15f27b`

Scope:
- make `flutter-ci.yml` the single Fast Quality Gate
- `permissions: contents: read`
- branch/PR concurrency with stale-run cancellation
- Flutter cache
- `flutter pub get → flutter analyze → flutter test`
- remove placeholder `test.yml`
- remove placeholder `build.yml`

APK/full build is not claimed yet because platform build foundation is not present. Issue #6 remains open for the later Full Build Gate.

### PR #8 — RTL Timeline shell
Branch: `ui/rtl-timeline-shell`
Head at creation: `5e459940fedf8a5b83cb9708396ca6ea7ca0a989`

Scope:
- feature-based `TimelineScreen`
- Persian RTL shell
- real empty state
- Quick Capture entry contract kept disabled until persistence exists
- widget test for RTL/empty-state/disabled capture contract

No model, repository or persistence foundation is duplicated in this PR.

## Closed / Integrated Work
- PR #1: closed without merge; historical CI-path experiment only.
- PR #2: merged; Flutter Foundation now on `main`.
- Issue #4 was tied to PR #2 and must not spawn another Foundation implementation.

## Active Issues
### Issue #5 — UI / RTL
Being advanced by PR #8. Do not create a competing App Shell or Router foundation.

### Issue #6 — CI / Automation
Being advanced by PR #7. Fast Gate consolidation is current priority; Full Build Gate follows only when the repository can actually build a platform artifact.

## Parallel Work Model
Lane A — Core / Domain / Foundation  
Lane B — UI / Feature  
Lane C — CI / Automation / Documentation

Current real parallel wave:
- Lane A: Foundation integrated; next is Timeline/Core contract.
- Lane B: PR #8 RTL Timeline shell.
- Lane C: PR #7 CI consolidation + PR #3 documentation baseline.

These workstreams use non-overlapping file boundaries and should remain parallel.

## Next Real Actions
1. Verify exact-head Actions for PR #7 and merge only when the new single CI gate is trustworthy.
2. Verify PR #8 with Flutter analyze/test and merge after exact-head evidence.
3. Keep PR #3 synchronized with current `main`, PR #7 and PR #8; merge its documentation baseline after valid CI evidence.
4. After CI/UI integration, start Timeline Domain contract in an independent branch.
5. Decide persistence only after the shared Timeline Item contract is audited and stabilized.
6. First real product vertical slice remains: `Quick Capture → Persist → Timeline → View/Edit`.

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
- shared Foundation reused before adding new foundations
- no competing Model/Repository/Storage/Router/AppShell without explicit architectural justification
- no fake persistence or fabricated implementation state

## Documentation Rule
Meaningful implementation, CI evidence, current-state documentation and handoff move together. Conversation memory is never the only operational record.

## Continuation Protocol
`ادامه یادنگار` means:
`Audit live GitHub → reconcile docs → inspect open PRs/issues → choose nearest real gaps → parallelize non-conflicting work → execute → validate exact refs → document → report briefly`

## Speed Rule
Produce verified useful software in hours rather than days through parallel independent work, small PRs, automation, reuse and fast feedback—not by skipping quality or evidence.
