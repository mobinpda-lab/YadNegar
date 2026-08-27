# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `6f3b1de0777263201a55faac9d1af1007d4d2e25`

Main now includes:
- completed Release Wave 7
- deterministic Release Manifest evidence
- Candidate Readiness aggregation
- deterministic Version + Release Notes Draft evidence

### Integrated PR #88 / Issue #87 — Candidate Readiness
Final exact PR head:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Pre-merge:
- YadNegar CI `33073336472`: success
- YadNegar Android Build `33073336417`: success
- android-build: success
- android-smoke-recovery: success
- release-readiness: success

Post-main on `8656564b57271947f6b45f0dbb206dbc4d3a3a38`:
- YadNegar CI `33074363600`: success
- YadNegar Android Build `33074363581`: success
- android-build: success
- android-smoke-recovery: success
- release-readiness: success

Issue #87 is closed/completed.

### Integrated PR #90 / Issue #89 — Version + Release Notes Draft
Final exact PR head:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Pre-merge exact-head proof:
- YadNegar CI `33074488110`: success
- YadNegar Android Build `33074488158`: success
- android-build: success
- android-smoke-recovery: success
- release-readiness: success
- release-draft: success

Merge used exact `expected_head_sha` and produced current main:
`6f3b1de0777263201a55faac9d1af1007d4d2e25`

Post-main runs on this exact main:
- YadNegar CI `33075537776`: active at this documentation revision
- YadNegar Android Build `33075537814`: active at this documentation revision

Do not report #90 post-main final Green until a fresh read proves the full chain complete.

## Verified Product / Release Baseline
One shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Verified foundations:
- Note / Event / Call / Idea / Activity on one `TimelineItem`
- Persian RTL UI
- crash-recoverable schema-versioned JSON persistence
- Search + Type + Date Range
- optional `occurredAt`
- safe Delete + Undo
- visible Export
- validated Backup/Restore
- schema-v2 optional `reminderAt` with backward-compatible v1 reads
- Persian Reminder UX + Android local notifications
- startup/post-Restore Reminder reconciliation
- Fast CI
- Android Debug APK artifact
- release-mode Candidate APK
- SHA-256 + byte-size evidence
- deterministic `RELEASE_MANIFEST.txt`
- exact source SHA separated from workflow validation SHA
- Android emulator startup proof
- production storage `.bak` recovery proof
- deterministic `RELEASE_READINESS.txt`
- deterministic `RELEASE_VERSION.txt`
- deterministic `RELEASE_NOTES_DRAFT.md`

No duplicate Timeline model/repository/storage/AppShell/Reminder database or duplicate Android workflow exists.

## Release Signing State
Current Android release-mode build still uses the debug signing config.

Correct status:
`candidate verified / production signing blocked / not Play-Store-ready`

No secret or production keystore is committed to the repository.

## Active Release Governance — Issue #91 / PR #92
`release: prove tag availability and emit approval rollback package`

Branch:
`release/approval-rollback-package`

Exact current head:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Fresh compare after #90 merge proves the scope remains isolated to:
- `.github/scripts/release-approval.sh`
- `.github/workflows/android-build.yml`

Purpose:
- reuse exact-run Release Version + Readiness evidence
- verify source SHA identity
- check proposed remote tag availability without creating/moving refs
- fail closed if the proposed tag exists or lookup cannot be verified
- emit `RELEASE_APPROVAL.txt`
- emit `ROLLBACK_PLAN.md`
- keep approval explicitly blocked while Production signing remains unresolved
- perform no tag/release/store/signing mutation

Exact-head validation started:
- YadNegar CI `33075612499`
- YadNegar Android Build `33075612644`

Both were active at this documentation revision. Fresh-read is mandatory before any Green or merge claim.

## Active Documentation — PR #86
Branch:
`docs/release-wave7-final`

Purpose:
- keep Current State / Persian Handoff / Operation Plan / Canonical Governance aligned with GitHub reality
- remain docs-only
- merge only after exact-head Fast CI + fresh mergeability + `expected_head_sha`

## Automation Gap
Issue #19 remains open.

Live Ruleset requires PR and blocks deletion/non-fast-forward, but required status checks are not configured as Platform-level enforcement. Fresh tool discovery on 2026-08-27 still exposes Ruleset read only, not Ruleset write.

Until real platform enforcement is writable, operational merge safety remains:
`exact current head + exact-head quality + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## Parallel Speed Rules
- Product / Release / CI-Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- stacked preparation is allowed only when later fresh compare proves isolated scope
- reuse before rebuild
- small reversible PRs
- no fake or stale evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Fresh-read #90 post-main runs `33075537776` and `33075537814`; require full chain Green.
2. Validate PR #92 exact head `1990e70d...`: Fast CI + Build + Smoke/Recovery + Readiness + Release Draft + Release Approval Green.
3. Merge #92 only after #90 post-main Green plus fresh #92 head/mergeability and exact `expected_head_sha`.
4. Verify #92 post-main.
5. Final-refresh PR #86 from actual #92 outcome and merge docs-only safely.
6. Keep Issue #19 open until required-check enforcement is genuinely writable.
7. Production signing and any real tag/release/publish mutation remain owner/security decisions and are not automated by the current chain.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
