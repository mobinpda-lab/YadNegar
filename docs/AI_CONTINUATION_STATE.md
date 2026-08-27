# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim, or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `99f672d53045782d18847380fc335fe1da25c0c6`

Main currently contains one shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo`

Capabilities already integrated:
- Note / Event / Call / Idea / Activity on one TimelineItem
- Persian RTL UI
- crash-recoverable schema-versioned JSON persistence
- Search + Type + Date Range
- occurredAt capture/edit for Event/Activity
- type correction
- safe delete with confirmation
- Undo with conflict/no-overwrite protection
- Fast CI + Android APK build/verify/upload

PR #50 documentation reconciliation is merged into current main. README / Current State / Handoff / Operation Plan are no longer on the old foundation snapshot.

## Active Product — PR #65 / Issue #64
`feat(export): copy visible Timeline items to clipboard`

Branch: `feature/timeline-export-clipboard`  
Current exact head: `114fca4cdfd2269d5d4ff906ce96afe0590a7162`  
Base: `main` at `99f672d53045782d18847380fc335fe1da25c0c6`  
Live diff: exactly 4 Export-related code/test files.

Final design:
- `ExportTimelineText` is a pure formatter in application layer
- input is the exact visible Timeline items, so Search / Type / Date filtering is preserved naturally
- no second Repository query or duplicate Search/Filter logic
- Clipboard stays in Presentation via Flutter Clipboard
- no dependency, Repository contract, schema or storage change
- widget coverage for success / empty / clipboard failure

Current exact-head gates:
- YadNegar CI run `33026398124`: in progress
- YadNegar Android Build run `33026398078`: in progress
- live mergeable: true; mergeable_state is unstable while checks settle

Keep PR #65 Draft until both exact-head gates are Green. Then re-read head + mergeability and merge only with `expected_head_sha`.

## Automation
Issue #62 is closed recovered. PR #65 registered both standard workflows normally on its exact head; no carrier or duplicate workflow is needed.

Issue #19 remains open: main Ruleset requires PR and protects deletion/non-fast-forward, but Platform-level required status checks are still not writable through the connected tooling.

Operational merge contract:
`exact current head + exact-head CI Green + exact-head Android Green + live mergeability + expected_head_sha lock + post-main proof`

## Parallel Work
- Product: PR #65 Export implementation + tests
- Automation: exact-head CI/Android and merge lock
- Documentation: `docs/current-state-wave6-export` tracks live state in parallel
- Ruleset: #19 remains isolated and must not block independent product work

## Next Actions
1. Finish exact-head CI + Android for PR #65.
2. If Green, mark Ready, Fresh-read head/mergeability and merge with expected-head lock.
3. Verify resulting main with Fast CI + Android.
4. Final-sync this docs lane onto the resulting main and merge after exact-head docs CI.
5. Fresh-audit Wave 6 before choosing the next slice; Backup is a candidate, not a pre-committed implementation.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
