# YadNegar AI Continuation State

Last updated: 2026-08-28

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Repository / Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Verified main at start of this sync: `b4504f11a8eed99cc3c2c03c4e436d6c953aba78`

Main contains the roadmap/date-reporting/picker work and first-class Projects. PR #157 is the active performance lane and must not be recorded as merged until exact-head full gates and expected-head merge complete.

## Canonical Product Model
- A tracked task/root is the primary work item.
- A task may have zero or many persistent child FollowUps.
- Adding a FollowUp never creates a new root task.
- Editing one FollowUp never deletes sibling history.
- Every root task has its own optional multi-line description.
- FollowUps use their own text and do not duplicate the root description.
- A task may have zero or one Project in v1 of Projects.
- Project is a first-class grouping container and is **not a Tag**.
- FollowUps do not own `projectId`; project context comes from their parent task.

## Home / UX
Current Home includes:
- Persian RTL presentation
- compact root-task cards
- FollowUp count and latest real FollowUp
- Jalali/Persian date-time
- stats, search, bottom navigation, add button, more menu and Backup
- Project context and colored Project boxes

Home search covers:
1. task title
2. task description
3. Project title
4. text of persisted FollowUps

Issue #151 remains open only for:
- `بسم الله الرحمن الرحیم` at the top of Home
- safe left/right Swipe action to add FollowUp for the same task

The Jalali monthly grid Date Picker and 24-hour dial Time Picker parts of #151 are already delivered on main through PR #154.

## Projects — #155 / PR #156
Completed and merged.

Rules:
- add/edit Project title
- choose/change Project color
- colored Project cards/boxes
- assign or clear Project during task create/edit
- a task with FollowUps or without FollowUps can belong to a Project
- a non-empty Project cannot be deleted; guard exists in Application logic, not only UI
- Project and Tag remain separate concepts

Merged main for this slice:
`b4504f11a8eed99cc3c2c03c4e436d6c953aba78`

## Data / Architecture Foundation
One Timeline repository and one JSON persistence foundation remain canonical. No second DB/store was introduced.

Current storage schema: **v6**  
Backward-compatible reads: **v1-v5**

Schema evolution:
- v2: reminder foundation
- v3: reminder recurrence
- v4: optional `parentId` for root → FollowUp history
- v5: optional tracked-task root `description`
- v6: Projects collection + optional root-task `projectId`

Safety properties:
- additive/backward-compatible migration
- no destructive migration
- no read-time rewrite
- safe-write upgrade path
- tmp/bak crash recovery
- Backup/Restore validation
- Projects and task Project membership included in Backup/Restore
- unsupported newer schema fails closed

Primary dependency direction remains:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain contracts`

## Date-based Reports — #153 / PR #154
Completed and merged.

Reporting supports:
- one Jalali day
- inclusive Jalali date range
- PDF / Print / Share through the existing export/document path
- root shown once
- only matching FollowUps included
- root creation date does not substitute for a FollowUp date
- deterministic Persian RTL output

No second report store or report engine was introduced.

## PDF / Backup / Reminder
PDF foundation remains shared for single / selected / all tracked-task scopes and date-based reporting.

Backup/Restore remains the machine-readable safety path.

Reminder foundation remains:
- none
- daily
- weekly
- device-local timezone handling

## Active Performance Lane — #149 / PR #157
Fresh audit found Home still performed N+1 full JSON repository reads:
- one root load
- one full repository load per root for FollowUps

Stale PR #150 was closed without merge because it became behind current main after date-reporting and Projects landed.

Rebuilt branch from exact current main:
`perf/home-single-snapshot-v6`

Active PR:
`#157 — perf(home): rebase single-snapshot loading onto schema v6 Home`

Exact PR head at creation:
`e9873838a025f236e77e0cb80a029c8164607dc8`

Fresh final scope is exactly three files:
- `lib/features/timeline/application/load_tracked_subjects.dart`
- `lib/features/timeline/presentation/tracked_subject_home.dart`
- `test/features/timeline/application/load_tracked_subject_home_data_test.dart`

Behavior:
- Home reads `TimelineRepository.listNewestFirst()` once per reload
- roots and FollowUps are projected/grouped in memory
- orphan children are ignored
- Project membership is preserved in roots
- no cache/repository/schema/dependency change
- Detail keeps existing `LoadTimelineFollowUps`

Current exact-head evidence when this document branch was created:
- YadNegar CI #388: running/then requires final verification before merge
- YadNegar UI Evidence #33: success
- YadNegar Android Build #162: running full chain

Do not merge #157 until all exact-head gates are green, fresh compare shows `behind=0`, three-file scope remains exact, PR is mergeable, and expected-head SHA is still unchanged.

## Release / Merge Contract
Before every product merge:
- Fresh Audit
- exact Head SHA
- fresh compare / `behind=0`
- exact scope
- CI
- Android Build
- UI Evidence for UI changes
- Smoke/Recovery
- Release Readiness
- Release Draft
- Release Approval
- merge with `expected_head_sha`

After merge:
- resolve new `main` SHA
- run/check Post-main Proof on that exact SHA
- only then close issue and sync canonical docs

## Platform Gap — #19
Issue #19 remains intentionally open.

Main ruleset requires PRs and protects destructive/non-fast-forward changes, but Required Status Checks are not platform-level configured because connected tooling currently exposes Ruleset read without the needed Ruleset write action.

Do not mark #19 completed artificially.

Operational contract until platform enforcement becomes writable:
`exact head + exact-head gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## Maximum Parallel Rules
- independent Product / Performance / Release / Docs lanes move concurrently
- blocked lane never stops healthy lanes
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- no Force Merge of stale/behind/red PRs
- documentation records only verified reality

## Immediate Queue
1. finish exact-head gates for PR #157
2. fresh compare, expected-head merge if green
3. Post-main Proof and close #149
4. finish remaining #151: Bismillah + safe Swipe FollowUp
5. sync the rest of canonical documentation to schema v6 / Projects / date reports / latest verified main
6. continue Fresh Audit for the next concrete defect

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
