# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Product Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current product main SHA: `885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Main currently contains one Timeline foundation with Quick Capture, persistence, search/filter, edit/delete/undo, export, backup/restore, reminders, recurring reminders, reminder visibility/filtering, distinct type icons, and shared type icon/label presentation across cards and selectors.

## Completed Product Waves
### Recurring Reminder — #93
- #94 / PR #96 — recurrence contract + schema v3 migration
- #95 / PR #97 — device-local daily/weekly Android scheduling + Persian UX
- #98 — documentation synchronization
- parent #93 — completed

### Timeline Reminder Status — #99 / PR #100
Product + final docs verified. Issue #99 completed.

### Reminder Presence Filter — #102 / PR #103
Product merged to `3428c1798a43fd39fadd5f47673d1bd0366583ca`.
Final docs PR #105 merged to `4d6dc18021b5d327b3a55972288df2b2a4d1c197`.
Docs post-main Fast CI `33095853727`: success.
Issue #102 completed.

### Timeline Type Card Icons — #104 / PR #106 + Docs #107
Product merged to `9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`.
Final docs PR #107 merged to `09d3bf13a8f4a7525b7619247095f4974774de67`.
Docs post-main Fast CI `33098163806`: success.
Issue #104 completed.

## Timeline Type Selector Icons — #108 / PR #109
Final product head:
`e6195dc11eebbed7db9b83fcefc7bf52c7bd9268`

Merged main:
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Reuse-first implementation:
- one shared presentation source owns Persian type labels + Material icons
- Timeline cards reuse it
- Timeline type filter reuses it
- Quick Capture type selector reuses it
- Edit type selector reuses it
- duplicate/private type mappings were removed

Scope remained presentation/test-only:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_item_type_presentation.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_selector_icon_test.dart`

Exact-head pre-merge proof on `e6195dc1...`:
- Fast CI `33099191968`: success
- Android `33099192004`: success across Build/Candidate, emulator Smoke/Recovery, Readiness, deterministic Release Draft, Approval/Rollback evidence
- live mergeability=true
- exact `expected_head_sha` merge succeeded

Post-main proof on exact `885b988d...`:
- Fast CI `33103519511`: success
- Android `33103519546`: success across the full release-governance chain

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

Live `main-protection` requires PR and blocks deletion/non-fast-forward. Required status checks are not Platform-level enforced because connected tooling currently exposes Ruleset read without Ruleset write.

Until enforcement is writable:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## Active Documentation — #108
Branch: `docs/timeline-type-selector-icons-live`

The branch was created before product integration but remained untouched, then was safely fast-forwarded without force to exact product main `885b988d...` before these writes.

Docs-only merge contract:
1. fresh compare proves four-doc-only scope
2. exact current docs head
3. exact-head Fast CI Green
4. live mergeability=true
5. exact `expected_head_sha`
6. post-main Fast CI proof
7. close #108 only after final proof

## Maximum Parallel Rules
- Product / Release / Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- stacked preparation requires fresh compare proving isolated scope
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Current Queue
Open product/documentation work: #108 final docs synchronization.  
Open platform limitation: #19 required-status enforcement gap.

No additional product Issue should be invented just to fill backlog. After #108 closes, fresh-audit code and UX and open a new slice only when a real small reuse-first need is proven.

## Next Actions
1. Fresh-compare this docs branch against exact `885b988d...`.
2. Open docs PR and verify exact-head Fast CI.
3. Merge with live mergeability + exact expected-head lock.
4. Verify docs post-main Fast CI and close #108.
5. Fresh-audit product queue and code before selecting the next slice.
6. Keep #19 open until required-check enforcement is genuinely writable.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
