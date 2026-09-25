# YadNegar AI Continuation State

Last verified: 2026-09-26

## Source of Truth
`GitHub Reality > owner-approved product contract > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Current Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current verified main SHA: `146ffab08da161baecce00fe99bcdb19fe76bc59`

## Latest Product Work
### Encrypted Backup foundation — PR #280
- merged: 2026-09-25
- exact PR head: `5e8021ec1a8473bab4880efef457a6d4d6035ffc`
- merge commit: `d26eb12126d35b971d381a2164eb8a417015b80c`
- exact-head CI #610: success
- exact-head Android Build #327: success
- exact-head UI Evidence #153: success
- implementation reuses the existing JSON snapshot/restore path
- AES-256-GCM + Argon2id, versioned envelope, fresh salt/nonce, wrong-password/tamper rejection
- no second storage/repository

### Encrypted Backup UI — PR #284
- merged: 2026-09-25
- exact PR head: `252a1a00a6e7dfc3d7c0b0e645d38d968817dd11`
- merge commit / current main: `146ffab08da161baecce00fe99bcdb19fe76bc59`
- adds encrypted backup and encrypted restore actions to the real product UI
- password entry/confirmation is in the UI
- restore reuses the existing repository and triggers reminder/widget reconciliation
- source-level UI test coverage exists
- post-merge workflow evidence for current main is **نامشخص**

## Backup Acceptance — Current Truth
Implemented:
- encrypted snapshot creation
- AES-256-GCM
- Argon2id
- fresh salt/nonce
- version/algorithm validation
- wrong-password/tamper fail-closed
- encrypted backup UI entry
- encrypted restore UI entry
- existing repository reuse
- reminder/widget reconciliation after successful restore

Still **نامشخص / not fully proven**:
- real Android restart → encrypted restore acceptance
- real product-data identity after encrypted restore
- medication reminder preservation through encrypted backup/restore
- end-to-end UI interaction beyond source-level assertions
- explicit user-facing success/error detail for every restore failure class
- legacy unencrypted backup compatibility after encrypted feature integration
- current-main post-merge CI/Android/UI evidence for `146ffab...`

Issue #278 remains open until these acceptance gaps are reconciled with evidence.

## Product Foundation
Canonical model:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Share/Print`

Existing foundations include:
- persistent tracked-task root and FollowUps
- Waiting-for-response
- Persian Search v2
- Projects / Categories / Tags
- Today / Next Action foundation
- Jalali/Persian UI
- Reminder + recurrence
- Android widget / notifications
- PDF / Print / Share
- JSON Backup/Restore
- encrypted Backup/Restore slice
- schema migrations and crash-safe persistence

Architecture law:
- one canonical repository/storage foundation
- reuse before add
- no duplicate Task/FollowUp store
- no duplicate Reminder scheduler
- no duplicate Search/PDF/Backup foundation

## Next Product Lane
1. Fresh-audit current main `146ffab...` and impacted Backup/Restore paths.
2. Add real behavioral tests for encrypted UI actions instead of source-only assertions where practical.
3. Add explicit restore confirmation and useful Persian error/success feedback without exposing passwords.
4. Prove restart + encrypted restore + medication/reminder preservation on Android.
5. Re-run exact-head CI, UI Evidence and Android Build on the resulting PR.
6. Only then reconcile/close Issue #278.
7. Keep factory blockers separate from Product First.

## Open Governance / Factory Work
Open documentation/factory PRs based on stale main must not be merged blindly:
- PR #283 is based on old main SHA `594ce8a4...`
- PR #242 is an old draft based on an older main
They require fresh rebase/audit before any promotion.

Known factory blockers remain independent:
- production signing credentials
- persistent autonomous code-worker E2E evidence
- platform Ruleset write capability
- real release publication/monitoring evidence

No Level-10/100% factory claim is made from workflow health alone.

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
