# YadNegar AI Continuation State

Last updated: 2026-08-28

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Product Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified product main SHA: `9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

The canonical product remains one persistent tracked-task root with persistent child FollowUps. The earlier flat Timeline is retained only as legacy tooling; no second Task/FollowUp store was introduced.

## Current Product Contract
Primary behavior now includes:
- root-only tracked-task Home
- latest real FollowUp drives exact Jalali/Persian date-time and derived relative text
- explicit no-follow-up state; root creation time never masquerades as latest FollowUp
- dedicated FollowUp capture/edit with Jalali input and Persian digits
- task edit and individual FollowUp edit with parent/sibling history preservation
- optional multi-line tracked-task description across create/edit/detail/PDF
- computed elapsed/inter-FollowUp durations; derived values are never persisted
- Persian RTL PDF with bundled Vazirmatn for all / selected / single-task scopes
- Share and Print reuse the same PDF projection/document path
- Home search matches task title, optional task description, and any persisted child FollowUp text
- JSON Backup/Restore remains a separate machine-readable safety feature

## Data / Architecture Foundation
One repository and one JSON persistence foundation are reused.

Current storage schema: **v5**  
Backward-compatible reads: **v1-v4**

Key schema evolution:
- v4: optional `parentId` for root → FollowUp history
- v5: optional tracked-task root `description`

Safety properties:
- no destructive migration
- no read-time rewrite
- safe-write upgrade path
- tmp/bak recovery
- backup/restore validation
- unsupported newer schema fails closed

Primary dependency direction remains:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain contracts`

## Canonical Contract Completion
Issue #121 is already **Completed**. Its main delivery waves were:
- #122 / PR #124: tracked-task/root + persistent FollowUp foundation
- #126 / PR #130: Jalali/Persian date-time foundation
- #129 / PR #133: computed Persian duration foundation
- #128: final FollowUp capture/edit/Home/detail semantics
- #125 / PR #138 + #139: Persian PDF + all/selected/single + share/print
- #140 / PR #141 + #142: optional description storage/UI/PDF
- PR #143: canonical documentation closure

Issue #117 is also already **Completed**. Do not treat #117 or #121 as future work.

## Latest Product Slice — #144 / PR #145
Fresh audit found the Home search hint promised search in tasks and FollowUps, while the implementation only matched root titles.

Delivered behavior:
- task-title match returns the root
- description-only match returns the root
- child-FollowUp-text match returns the root
- no duplicate roots
- current ordering/hierarchy preserved
- no repository/disk read per keystroke
- no schema/model/store/scheduler/dependency change

Final PR head:
`b876bade5c89d5215d7955c8b1ffc250bd8f627e`

Fresh pre-merge scope: exactly two files, `behind=0`.

Pre-merge evidence:
- YadNegar CI `33183658883`: success
- YadNegar UI Evidence `33183658891`: success
- YadNegar Android Build `33183658875`: success full chain

Merged with exact expected-head lock to:
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

Post-main proof on exact merged SHA:
- YadNegar CI `33185558030`: success
- YadNegar Android Build `33185558017`: success full chain
  - debug APK build/verify/upload
  - release-candidate build/evidence
  - emulator startup + storage recovery
  - release readiness
  - deterministic release draft
  - release approval/rollback evidence

Issue #144 is **Completed**.

## Reminder / Release Baseline
Existing one-shot + daily/weekly Reminder foundation remains reused with device-local timezone handling and fail-closed behavior.

Verified automation chain:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback Evidence`

Release status:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

No production keystore/secret, real tag, GitHub Release or Play Store publish has been created.

## Automation Gap — Issue #19
Issue #19 remains intentionally open. `main-protection` is active and requires pull requests while blocking deletion and non-fast-forward updates. Required status checks are still not Platform-level enforced because connected tooling exposes Ruleset read but not Ruleset write.

Operational merge contract until enforcement is writable:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## Documentation Lane
Active branch:
`docs/tracked-subject-search-content`

It was kept untouched until #145 post-main proof finished, then fast-forwarded **without force** to exact verified main `9b577cc...`.

Expected docs-only scope is exactly:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

After exact-head docs Fast CI, fresh four-doc scope, live mergeability and expected-head merge, run post-main Fast CI and refresh #19 to the newest canonical main.

## Maximum Parallel Rules
- independent Product / Release / Automation / Docs lanes move concurrently
- a blocked runner pauses only its lane
- reuse before rebuild
- small reversible PRs
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- no force integration when a fresh rebuild/fast-forward is safer
- documentation records only verified reality

## Current Queue
Fresh issue/PR audit after #144 completion:
- no open product PRs
- no known open product issue
- #19 is the only known open issue and is Platform-limited

Do not invent backlog merely to keep work moving. The next product slice must come from a fresh, concrete UX/code audit with a small reuse-first Definition of Done.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
