# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Current main SHA: `8656564b57271947f6b45f0dbb206dbc4d3a3a38`

Main now includes completed Release Wave 7, deterministic Release Manifest evidence, and Candidate Readiness aggregation.

### Integrated PR #88 / Issue #87
`release: aggregate candidate readiness evidence`

Final exact PR head:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Pre-merge exact-head proof:
- YadNegar CI `33073336472`: success
- YadNegar Android Build `33073336417`: success
- `android-build`: success
- `android-smoke-recovery`: success
- `release-readiness`: success

Merge used exact `expected_head_sha` and produced main:
`8656564b57271947f6b45f0dbb206dbc4d3a3a38`

Post-main proof on this exact main:
- YadNegar CI `33074363600`: success
- YadNegar Android Build `33074363581`: active at this documentation revision; final Android/Readiness Green must be fresh-read before any claim

Issue #87 is closed/completed.

### Previously integrated PR #85 / Issue #84
Deterministic `RELEASE_MANIFEST.txt` is verified on main. PR #85 final head `2a456003899ec24ab310a86f5f521c68a97fb483`; post-main CI `33071541211` and Android `33071541182` both succeeded. Issue #84 is completed.

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

No duplicate Timeline model/repository/storage/AppShell/Reminder database exists.

## Release Signing State
Current Android release-mode build still uses the debug signing config.

Correct status:
`candidate verified / not production-signed / not Play-Store-ready`

No secret or production keystore is committed to the repository.

## Active Release Governance — Issue #89 / PR #90
`release: generate deterministic version and release-notes draft`

Branch:
`release/version-notes-draft`

Exact current head at this documentation revision:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Scope is isolated to two files:
- `.github/scripts/release-draft.sh`
- `.github/workflows/android-build.yml`

Purpose:
- reuse exact-run Candidate + Readiness artifacts
- derive version name and build number from verified manifest
- propose, but never create, a version tag
- emit `RELEASE_VERSION.txt`
- emit `RELEASE_NOTES_DRAFT.md`
- preserve the explicit Production-signing blocker

Validation at this revision:
- YadNegar CI `33074488110`: success
- YadNegar Android Build `33074488158`: active; full Build → Smoke/Recovery → Readiness → Release Draft chain must be fresh-read before merge

PR #90 is mergeable at the latest fresh read, but merge is forbidden until both #88 post-main Android proof and all exact-head #90 gates are Green.

## Active Documentation — PR #86
Branch:
`docs/release-wave7-final`

Purpose:
- keep Current State / Persian Handoff / Operation Plan / Canonical Governance aligned with GitHub reality
- remain docs-only
- merge only after exact-head Fast CI + fresh mergeability + `expected_head_sha`

## Automation Gap
Issue #19 remains open.

`main` requires PR via the live Ruleset, but required status checks are not currently configured as Platform-level enforcement. Connected tooling still exposes Ruleset read, not Ruleset write.

Until real platform enforcement is writable, operational merge safety remains:
`exact current head + exact-head quality + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## Parallel Speed Rules
- Product / Release / CI-Automation / Docs move simultaneously when independent
- blocked Runner never stops an independent Lane
- reuse before rebuild
- small reversible PRs
- no fake or stale evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Fresh-read post-main Android run `33074363581` for main `8656564b...`; require Build + Smoke/Recovery + Readiness Green.
2. Validate PR #90 exact head `f3aab864...`: Fast CI + Android Build + Smoke/Recovery + Readiness + Release Draft Green.
3. Merge #90 only after both previous conditions plus fresh head/mergeability and exact `expected_head_sha`.
4. Verify #90 post-main.
5. Final-refresh PR #86 from actual #90 outcome and merge docs-only safely.
6. Keep Issue #19 open until required-check enforcement is genuinely writable.
7. Production signing/tag/release/publish mutations require separate security/owner decisions.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
