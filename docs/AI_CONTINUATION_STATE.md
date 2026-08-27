# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Verified main SHA: `a29fe46ba9c9c50be107e36b6c618ddc1a0c6e95`

Main includes completed Release Wave 7 plus deterministic Release Manifest evidence.

### Integrated PR #85 / Issue #84
`release: add deterministic release manifest evidence`

Final exact PR head:
`2a456003899ec24ab310a86f5f521c68a97fb483`

Pre-merge exact-head proof:
- YadNegar CI `33070804473`: success
- YadNegar Android Build `33070804465`: success
- `android-build`: success
- Release Candidate + `RELEASE_MANIFEST.txt`: build/verify/upload success
- `android-smoke-recovery`: success

Merge used exact `expected_head_sha` and produced main:
`a29fe46ba9c9c50be107e36b6c618ddc1a0c6e95`

Post-main proof on this exact main:
- YadNegar CI `33071541211`: success
- YadNegar Android Build `33071541182`: success
- `android-build`: success
- `android-smoke-recovery`: success

Issue #84 is closed/completed.

## Verified Product / Release Baseline
One shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Verified foundations on main:
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

No duplicate Timeline model/repository/storage/AppShell/Reminder database exists.

## Release Signing State
Current Android release-mode build still uses the debug signing config.

Correct status:
`candidate verified / not production-signed / not Play-Store-ready`

No secret or production keystore is committed to the repository.

## Active Release Governance — Issue #87 / PR #88
`release: aggregate candidate readiness evidence`

Branch:
`release/candidate-readiness-evidence`

Exact current head at this documentation commit:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Purpose:
- reuse the existing Android workflow
- preserve Build + Manifest + Smoke/Recovery gates
- add dependent `release-readiness` aggregation
- validate exact-run Candidate and Smoke evidence
- emit `RELEASE_READINESS.txt`
- explicitly report Production signing as blocked while debug signing remains

Exact-head runs started:
- YadNegar CI `33073336472`
- YadNegar Android Build `33073336417`

These runs were active when this document revision was written. Fresh-read is required before any Green or merge claim.

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
1. Validate PR #88 on exact head `32d2b6de...`: Fast CI + Android Build + Smoke/Recovery + Release Readiness.
2. If Green, fresh-read head/mergeability and merge only with exact `expected_head_sha`.
3. Verify post-main after any #88 merge.
4. Refresh PR #86 one final time from actual #88 outcome, then merge docs-only safely.
5. Keep Issue #19 open until required-check enforcement is genuinely writable.
6. Production signing remains a separate security-sensitive slice after secure keystore/credential ownership is defined.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
