# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Product Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current product main SHA: `9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`

Main contains the recurring-reminder foundation, reminder status and reminder-presence filtering on Timeline, plus distinct icons for all five canonical Timeline item types.

## Completed Reminder Waves
### Recurring Reminder — #93
- #94 / PR #96 — recurrence contract + schema v3 migration
- #95 / PR #97 — device-local daily/weekly Android scheduling + Persian UX
- #98 — documentation synchronization
- parent #93 — completed

### Timeline Reminder Status — #99 / PR #100
Product merged to `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`.
Final docs PR #101 merged and post-main verified.
Issue #99 is closed/completed.

### Reminder Presence Filter — #102 / PR #103
Product merged to `3428c1798a43fd39fadd5f47673d1bd0366583ca`.
Final docs PR #105 merged to `4d6dc18021b5d327b3a55972288df2b2a4d1c197`.
Docs post-main Fast CI `33095853727`: success.
Issue #102 is closed/completed.

## Timeline Type Icons — #104 / PR #106
Final product head:
`042491caadb405a31473b51986c263a6f9ba5d5c`

Merged main:
`9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`

Integrated mapping:
- note => `Icons.note_outlined`
- event => `Icons.event_outlined`
- call => `Icons.call_outlined`
- idea => `Icons.lightbulb_outline`
- activity => `Icons.check_circle_outline`

Existing Persian type labels, Timeline timestamp, reminder status and reminder-presence filter remain unchanged.

Product scope remained limited to:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_icon_test.dart`

Exact-head pre-merge proof:
- Fast CI `33095681567`: success
- Android `33095681514`: success across Build/Candidate, emulator Smoke/Recovery, Readiness, Release Draft, Approval/Rollback evidence

Post-main proof on exact main `9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`:
- Fast CI `33096491732`: success
- Android `33096491859`: success across the full release-governance chain

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

## Active Documentation — #104
Branch: `docs/timeline-type-icons-live`

Purpose: synchronize the four live/canonical project documents with the completed #104 / PR #106 product outcome and exact post-main evidence.

Docs-only merge contract:
1. exact current docs head
2. exact-head Fast CI Green
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI proof
6. close #104 only after that proof

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
1. Integrate this #104 docs synchronization with exact-head evidence.
2. Verify docs post-main Fast CI and close #104.
3. Fresh-audit the resulting open issue/product queue before selecting another slice.
4. Keep #19 open until required-check enforcement is genuinely writable.
5. Production signing and real tag/release/publish remain separate Owner/Security decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
