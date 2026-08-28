# YadNegar AI Continuation State

Last updated: 2026-08-28

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Product Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current product main SHA: `2c1f944f94de729037adc62939650863123786c3`

The owner-approved tracked-task contract in #121 is implemented on the existing YadNegar Timeline/storage foundation. The old flat Timeline remains available as legacy tools where needed, but the primary product direction is root tracked tasks with persistent child follow-up history.

## Current Product Contract
A tracked task is one persistent root. Every follow-up appends a child record to that same root; adding or editing a follow-up never replaces sibling history.

Primary tracked-task behavior now includes:
- root-only tracked-task Home
- latest real FollowUp drives Home exact Jalali/Persian date-time and secondary relative text
- explicit no-follow-up state; root creation time never masquerades as the latest follow-up
- dedicated `ثبت پیگیری` screen from an obvious round `+`
- optional follow-up title; blank saves as `پیگیری`
- default device date/time with editable Jalali/Persian input before save
- task editing and individual follow-up editing
- newest FollowUp first on detail/history
- computed elapsed time since latest FollowUp
- computed interval between FollowUps; derived durations are never persisted
- optional multi-line tracked-task description/summary across create/edit/detail
- compact Home cards; description does not displace latest-follow-up hierarchy
- Persian PDF generation with RTL layout, Jalali dates, Persian digits and bundled Vazirmatn
- PDF scopes: all tracked tasks, selected tracked tasks, or one tracked task with complete history
- share and print actions reuse the same PDF projection/document path
- JSON backup/restore remains a separate machine-readable safety feature

## Data / Architecture Foundation
One repository and one JSON persistence foundation are reused. No second Task/FollowUp store, DB, scheduler or AppShell was introduced.

Current storage schema: **v5**.  
Backward-compatible reads: **v1-v4**.  
Key schema evolution:
- v4: optional parent relation for root→follow-up history
- v5: optional tracked-task root description

Safety properties remain:
- no destructive migration
- no read-time rewrite
- safe-write upgrade path
- tmp/bak recovery
- backup/restore validation
- older unsupported schema consumers fail closed rather than silently dropping new fields

Primary dependency direction remains:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain contracts`

## Canonical #121 Completion Waves
The canonical correction was delivered as reuse-first slices rather than a replacement system:
- #122 / PR #124: tracked-task/root + persistent follow-up foundation
- #126 / PR #130: Jalali input and Persian date/time presentation
- #129 / PR #133: shared computed Persian duration foundation
- #128 follow-up/product flow: dedicated capture, editing, correct Home/detail semantics and history-safe behavior
- #125 / PR #138 + PR #139: Persian PDF foundation + all/selected/single share/print scopes
- #140 / PR #141 + PR #142: optional tracked-task description storage + create/edit/detail/PDF completion

The superseded flat-Timeline polish lane #119 / PR #120 remains intentionally not merged because #121 changed the canonical product direction.

## Final #140 / #142 Evidence
Final PR #142 product head:
`da362d2138df05b859468d36b52b61d1ac95192f`

Merged main:
`2c1f944f94de729037adc62939650863123786c3`

Fresh PR scope was exactly eight files and `behind=0` before merge.

Exact-head pre-merge proof:
- YadNegar CI `33179167525`: success
- YadNegar UI Evidence `33179167522`: success
- YadNegar Android Build `33179167509`: success full chain
  - debug APK + verification/upload
  - release-candidate APK + evidence
  - emulator startup + storage recovery
  - release readiness
  - deterministic release draft
  - approval/rollback evidence
- live mergeability=true
- exact `expected_head_sha` merge succeeded

Post-main proof on exact `2c1f944...`:
- YadNegar CI `33179977417`: success
- YadNegar Android Build `33179977437`: success full chain, including emulator recovery/readiness/draft/approval

The narrow 320px tracked-task create dialog is covered through the real `YadNegarApp` theme; the final fix uses a 20px horizontal Dialog inset and does not remove content or shrink normal typography.

## Earlier Timeline Utility Completion
Issue #117 is product-complete and only carried historical documentation debt:
- final product head `6d740ee26f48c9958d80b68c5c5f785af124d33c`
- merged main `8b1ff3912cca3c90f69dd2fcae4a98b3151049dd`
- pre-merge CI `33119504206`: success
- pre-merge Android `33119504472`: success full chain
- post-main CI `33120260013`: success
- post-main Android `33120260012`: success full chain

Its dedicated query-clear action remains available in legacy Timeline tooling and does not conflict with the tracked-task primary product direction.

## Reminder / Release Baseline
Existing one-shot + daily/weekly Reminder foundation remains reused with device-local timezone handling and fail-closed behavior.

Verified automation chain:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

Release status:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

No production keystore/secret, real tag, GitHub Release or Play Store publish has been created.

## Automation Gap — Issue #19
Issue #19 remains intentionally open. `main-protection` requires PRs and blocks deletion/non-fast-forward, but required status checks are not Platform-level enforced because connected tooling still has no Ruleset Write capability.

Operational merge contract until enforcement is writable:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## Documentation Finalization Lane
Branch: `docs/tracked-task-canonical-final`

The branch was created from the prior main without documentation writes, then safely fast-forwarded **without force** to exact verified product main `2c1f944...` only after product post-main CI + Android were fully Green.

This lane synchronizes exactly the four canonical/live documents:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

After docs exact-head Fast CI, fresh four-doc-only compare, live mergeability and expected-head merge, run docs post-main Fast CI. Then close #117 and canonical parent #121 as completed.

## Maximum Parallel Rules
- independent Product / Release / Automation / Docs lanes move concurrently
- blocked Runner never stops an independent lane
- reuse before rebuild
- small reversible PRs
- safe stacked preparation only with fresh scope proof
- no stale/fake evidence
- no duplicate workflow/storage/foundation
- historical Green never transfers after a head change

## Current Queue
Product contract work is complete. After documentation issue-state cleanup, the only known open issue is:
- #19: required-status enforcement gap; platform-limited

Do not invent product backlog merely to keep work moving. Fresh-audit the actual app/code and open the next slice only when a real small reuse-first need is proven.

## Next Actions
1. Fresh-compare `docs/tracked-task-canonical-final` against exact main and prove four-doc-only scope.
2. Open docs PR and verify exact-head Fast CI.
3. Merge with live mergeability + exact expected-head lock.
4. Verify docs post-main Fast CI.
5. Close #117 and #121 as completed.
6. Fresh-audit the product for the next real need while keeping #19 open until Ruleset Write is genuinely available.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
