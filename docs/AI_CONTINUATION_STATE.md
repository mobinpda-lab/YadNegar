# YadNegar AI Continuation State

Last updated: 2026-08-29

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Product Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current merged product main SHA: `64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

Canonical model:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Share/Print`

The earlier flat Timeline remains only as legacy tooling. No second Task/FollowUp store exists.

## Current Product Contract
- one persistent root per tracked task
- persistent child FollowUps with parent/sibling history preservation
- optional root description
- optional root Project membership; FollowUps inherit Project context from parent
- Projects stored in the same JSON foundation, not a second database
- root-only Home with one repository snapshot per reload
- latest real FollowUp drives exact date/time and relative status; root creation time never masquerades as a FollowUp
- Home search across task title + description + child FollowUp text
- subtle `بسم الله الرحمن الرحیم` at top of Home
- swipe left or right on a task opens FollowUp capture for the same root and never dismisses/deletes the root
- Jalali monthly grid date picker
- 24-hour dial time picker
- Persian RTL PDF for all / selected / single-task scopes
- date-based one-day/range reports over matching FollowUps only
- PDF / Print / Share reuse the same report/document foundation
- validated JSON Backup/Restore
- reminder foundation with none/daily/weekly recurrence and local-time semantics

## Data / Architecture Foundation
One repository and one JSON persistence foundation are reused.

Current storage schema: **v6**  
Backward-compatible reads: **v1-v5**

Schema evolution:
- v2: optional reminder time
- v3: reminder recurrence
- v4: optional `parentId` for root → FollowUp history
- v5: optional tracked-task root `description`
- v6: Projects + optional root `projectId`

Safety:
- no destructive migration
- no read-time rewrite
- safe-write upgrade
- tmp/bak crash recovery
- validated Backup/Restore
- unsupported newer schema fails closed
- FollowUps cannot own Project membership

## Recent Completed Slices
### #153 — Date-based Reports
Completed and merged before the current Home work.
- one Jalali day or inclusive Jalali range
- root appears once
- only matching FollowUps are included
- root creation date alone does not count
- existing PDF/Print/Share path reused

### #149 / PR #157 — Home Single Snapshot
Completed.
- Home now calls the repository once per reload and groups roots/children in memory
- Projects, description, search and FollowUp ordering preserved
- no cache, store, schema or dependency added

Merged main after PR #157:
`2f360ca952ffdd706461c6fb428d67853f8e27b9`

Post-main CI and Android full chain were Green; #149 is closed Completed.

### #151 / PR #159 — Final Home/FollowUp UX
Final PR head:
`0e27cfd8083ca5428b1fb7a321982cc6d4b7f936`

Final scope: exactly two files, `behind=0`.

Exact-head evidence:
- YadNegar CI #396 `33209126088`: success
- YadNegar UI Evidence #39 `33209126046`: success
- YadNegar Android Build #169 `33209126028`: full chain success
  - Debug APK
  - Release Candidate
  - Emulator Smoke/Recovery
  - Release Readiness
  - Release Draft
  - Release Approval/Rollback

Merged with exact expected-head lock to:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

Post-main:
- CI #397 `33209875036`: success
- Android #170 `33209875095`: **currently running** at this documentation-preparation commit

Issue #151 must remain open until Android #170 full post-main chain is Green. This docs branch must not merge before that proof is updated to success.

## Release Baseline
Verified release automation:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

Release status remains:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

No production keystore/secret, real release tag, GitHub Release or Play Store publish is created without an explicit Owner/Security decision.

## Platform Gap — Issue #19
#19 remains open and Platform-limited. `main-protection` requires PRs and blocks deletion/non-fast-forward updates, but connected tooling still does not expose Ruleset Write for enforcing required check contexts.

Until then:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## Next Product Slice — Issue #160
`Today Center: اقدام بعدی، امروز، عقب‌افتاده و آینده بدون تداخل با Reminder`

Fresh audit decisions:
- optional root-only `nextActionAt`
- Next Action is distinct from Notification/Reminder
- derived buckets are not persisted
- local calendar-day semantics:
  - Today = anywhere on the current local day
  - Overdue = before start of today
  - Upcoming = after end of today
  - No Next Action = null
- reuse `TimelineItem`, `QuickCapture`, `EditTimelineItem`, JSON repository, Jalali grid, 24h dial and Home single-snapshot projection
- no second store/calendar/search/reminder foundation

Prepared decomposition:
1. Slice A — schema v7 + domain/application + derived buckets + tests
2. Slice B — create/edit/detail/Home Today Center UI

No product write for #160 begins until #151 post-main proof is Green.

## Documentation Lane
Active branch:
`docs/current-state-after-151`

Final intended scope is exactly four canonical documents:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

Before merge, replace the temporary Android #170 running status with exact Green evidence, fresh-compare four-doc scope, run exact-head CI, merge with expected-head lock, then take post-main CI proof.

## Maximum Parallel Rules
- independent Product / Release / Automation / Docs lanes move concurrently
- reuse before rebuild
- small reversible slices
- one source of truth for data
- no stale/fake evidence
- no duplicate storage/workflow/foundation
- stacked work must be fresh-compared after base moves
- documentation records only verified reality

## Current Queue
- #151: awaiting only post-main Android #170 proof before final closure
- #160: next product lane, design ready
- #19: independent Platform-limited governance gap

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
