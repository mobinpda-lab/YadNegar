# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current product main SHA: `3428c1798a43fd39fadd5f47673d1bd0366583ca`

Main contains the recurring-reminder foundation, reminder status on Timeline cards, and reminder-presence filtering.

## Completed Reminder Waves
### Recurring Reminder — #93
- #94 / PR #96 — recurrence contract + schema v3 migration
- #95 / PR #97 — device-local daily/weekly Android scheduling + Persian UX
- #98 — documentation synchronization
- parent #93 — completed

### Timeline Reminder Status — #99 / PR #100
Product merged to `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`.
Final docs PR #101 merged to `fb2a02624421ba135de87357817d13922fed7abf` and post-main Fast CI passed.
Issue #99 is closed/completed.

### Reminder Presence Filter — #102 / PR #103
Final product head:
`256c2f05a5ce0d4bfaba6c9a711e7470d78f932a`

Merged main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Integrated behavior:
- `همه موارد`
- `دارای یادآور`
- `بدون یادآور`
- composes with existing Search/Type/Date results
- clear-filters also resets reminder presence
- export uses currently visible filtered items

Product scope remained limited to:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_filter_test.dart`

Exact-head pre-merge proof:
- Fast CI `33092820178`: success
- Android `33092820203`: success across Build/Candidate, emulator Smoke/Recovery, Readiness, Release Draft, Approval/Rollback evidence

Post-main proof on exact main `3428c1798a43fd39fadd5f47673d1bd0366583ca`:
- Fast CI `33093725156`: success
- Android `33093725042`: success across the full release-governance chain

## Product / Data Foundation
Main flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3.  
Backward compatibility: v1 + v2 reads remain supported.

No duplicate Timeline model/repository/storage/AppShell/Reminder database/scheduler exists.

## Release Baseline — Stable
Verified chain:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

Release status:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

No real tag, GitHub Release, Play Store publish, production keystore or signing secret has been created.

## Automation Gap — Issue #19
Issue #19 remains open.

Live `main-protection` ruleset requires PR and blocks deletion/non-fast-forward. Required status checks are not Platform-level enforced because connected tooling currently exposes Ruleset read without Ruleset write.

Until enforcement is writable:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## Active Documentation — #102
Branch: `docs/timeline-reminder-filter-live`

Purpose: synchronize the four live/canonical project documents with the completed #102 / PR #103 outcome and exact post-main evidence.

Docs-only merge contract:
1. exact current docs head
2. exact-head Fast CI Green
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI proof
6. close #102 only after that proof

## Next Product Slice — #104
Issue #104: differentiate Timeline item types with existing Material icons.
Branch: `product/timeline-type-icons`

Scope is presentation-only and may be prepared in parallel, but must not integrate before #102 documentation is merged and verified. No schema/storage/scheduler/navigation/dependency changes are allowed.

## Maximum Parallel Rules
- Product / Release / Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- stacked preparation requires fresh compare proving isolated scope
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Finish #102 docs sync and run exact-head Fast CI.
2. Merge docs with live mergeability + exact expected-head lock.
3. Verify docs post-main Fast CI and close #102.
4. Continue #104 focused implementation/testing in its independent branch.
5. Keep #19 open until required-check enforcement is genuinely writable.
6. Production signing and real tag/release/publish remain separate Owner/Security decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
