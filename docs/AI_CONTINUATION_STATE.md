# YadNegar AI Continuation State

Last verified: 2026-09-25

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Current Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `8af3bff4470f0041945ed797c8af8ad94d7d15ed`

Latest merged product slice:
- PR #274 — medication consumption reminder UI slice
- merged with exact expected head `2634adc2af0469f6c2059b3e2f2779a784ab8ad2`
- merge commit: `8af3bff4470f0041945ed797c8af8ad94d7d15ed`

## #274 Exact-Head Evidence
PR head `2634adc2af0469f6c2059b3e2f2779a784ab8ad2`:
- YadNegar CI #599 / run `36141428254`: success
- YadNegar UI Evidence #149 / run `36141428122`: success
- YadNegar Android Build #322 / run `36141428204`: success
  - Debug APK: success
  - Release Candidate: success
  - Emulator startup/storage recovery: success
  - Release Readiness: success
  - Release Draft: success
  - Release Approval/Rollback evidence: success

No gate bypass was used.

## Product Slice Now in Main
Medication consumption reminder uses the existing Timeline aggregate and single reminder engine:
- reminder type: `یادآور مصرف`
- fields: medication name, amount, unit, interval, first scheduled time
- `مصرف کردم` records actual consumption
- `scheduledAt` and `actualTakenAt` remain separate
- next reminder is anchored to actual consumption + interval
- existing repository and scheduler are reused
- no parallel medication store or reminder engine was added
- unit coverage exists for creation

Issue #224 remains the canonical product specification/acceptance record until its full acceptance evidence is explicitly reconciled.

## Core Product Foundation
Canonical model:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Share/Print`

Existing product foundations include:
- persistent tracked-task root and FollowUp history
- Waiting-for-response status
- Persian Search v2
- Projects / Categories / Tags
- Today / Next Action foundation
- Jalali/Persian UI
- Reminder + recurrence foundation
- Android widget / notifications
- PDF / Print / Share
- JSON Backup/Restore
- schema migrations and crash-safe persistence

Architecture law:
- one canonical repository/storage foundation
- reuse before add
- no duplicate Task/FollowUp store
- no duplicate Reminder scheduler
- no duplicate Search/PDF/Backup foundation

## Backup / Restore — Current Gap
Current backup is a validated JSON snapshot and restore path.

Not yet implemented/verified:
- password-protected encrypted backup envelope
- AES-256-GCM encryption
- Argon2id password derivation
- encrypted backup/restore acceptance and regression evidence

This is a real product/security lane, not a claim of completion.

## Release Status
Operational Android chain is verified for exact tested heads:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

Current product-release status:
- Android candidate chain: operationally verified on the merged medication slice
- production signing: blocked until valid external signing credentials are intentionally provided
- real GitHub Release / Play Store publication: not claimed

## Platform / Factory Gaps
Issue #19 remains an independent Platform-limited ruleset-write gap.

Factory automation is a means, not the product. No Level-10/100% factory claim is made merely from workflow health.

Known factory blockers remain separate from Product First completion:
- production signing credentials
- persistent autonomous code-worker backend / real E2E worker evidence
- platform Ruleset write capability
- release publication/monitoring evidence

These must not stop independent product work.

## Next Execution Lanes
1. Freshly verify post-merge main CI/Android evidence for `8af3bff...`.
2. Reconcile/close #224 only after its remaining acceptance evidence is explicitly covered.
3. Start the encrypted Backup/Restore product slice on a fresh main branch, reusing the existing JSON snapshot/restore path.
4. In parallel, continue independent Release/Regression audits without creating duplicate foundations.
5. After each merge: fresh main SHA → open PR audit → impacted-lane rebuild → post-main proof → state update.

## Anti-Rework / Continuation Rule
Required cycle:
`Fresh Audit → Last-Failure Classification → Reuse/Compare → Single Hypothesis → Small Change → Exact-Head Validation → Decision → Continue/Change Path`

Never reuse historical CI as proof for a new head.

## PRODUCT FIRST
**کارخانه وسیله است؛ یادنگار محصول نهایی است.**

Every factory, automation, workflow, governance or documentation change must directly serve production, completion, testing or delivery of YadNegar.

Success means:
**YadNegar usable and Release-Ready — not merely a healthy factory.**

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
