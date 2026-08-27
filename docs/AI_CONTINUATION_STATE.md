# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical governance > current-state docs > conversation memory`

Fresh-audit GitHub before every write, merge, SHA/status claim or progress claim. Historical Green never transfers to a new head.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Branch: `main`  
Verified main SHA: `9ffa1041c3205a35d0aa0744236e9e4dcbb28333`

Main includes PR #83:
`release: prove Android emulator smoke and storage recovery`

PR #83 final exact head:
`60d1f21ce3574e3b6c04478351136acf35e9e8e7`

Pre-merge exact-head proof:
- YadNegar CI run `33069328808`: success
- YadNegar Android Build run `33069328907`: success
- `android-build`: success
- `android-smoke-recovery`: success
- Debug APK + Release Candidate: build/verify/upload success
- emulator startup + real storage recovery evidence: success

Merge used exact `expected_head_sha` and produced main `9ffa1041c3205a35d0aa0744236e9e4dcbb28333`.

Post-main proof currently:
- YadNegar CI run `33070027775`: success
- YadNegar Android Build run `33070027900`: active at this documentation commit; do not report final Green until a fresh read proves all jobs complete

Issue #82 is closed/completed.

## Verified Product Baseline
One shared Timeline flow:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore → Reminder`

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
- release-mode candidate APK + SHA-256/size evidence
- Android emulator startup proof
- production storage `.bak` recovery proof

No duplicate Timeline model/repository/storage/AppShell/Reminder database exists.

## Completed Release Wave 7
Wave 7 contract:
`E2E + build + artifact + smoke + recovery`

Completed:
- PR #81 / Issue #80 — deterministic Release Candidate artifact gate
- PR #83 / Issue #82 — Android emulator smoke + real storage recovery gate

Current release candidate is **not production-signed**. `android/app/build.gradle.kts` still uses the debug signing config for release-mode builds. Do not claim Play-Store-ready or production-signed status.

## Active Release Governance — Issue #84 / PR #85
Issue #84 / PR #85:
`release: add deterministic release manifest evidence`

Branch:
`release/deterministic-release-manifest`

Initial exact head:
`cb8bd2d23dfc06bdb8f8ab20869dabb8edbfd340`

Purpose:
- reuse existing Android workflow
- preserve build + artifact + smoke/recovery gates
- add `RELEASE_MANIFEST.txt`
- record app version, application id, exact source SHA, APK SHA-256, byte size and explicit signing state
- no signing secret
- no tag/release/publish mutation

Current exact-head runs:
- YadNegar CI `33070352421`
- YadNegar Android Build `33070352464`

Both must be fresh-read before any Green or merge claim.

## Automation Gap
Issue #19 remains open.

Live `main-protection` Ruleset requires PR and blocks deletion/non-fast-forward, but platform-level required status checks are still not configured. Fresh tool discovery on 2026-08-27 again exposes Ruleset read only, not Ruleset write.

Until real Ruleset write exists, operational merge safety is:
`exact current head + exact-head quality + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## Parallel Speed Rules
- Product / Release / CI-Automation / Docs move simultaneously when independent
- blocked runner does not stop independent work
- reuse before rebuild
- small reversible PRs
- no fake evidence
- no stale merge evidence
- no duplicate workflow/storage/foundation
- docs move concurrently with implementation

## Next Actions
1. Fresh-read post-main Android run `33070027900` for main `9ffa1041...`.
2. Validate PR #85 exact head; require Fast CI + Android Build + Smoke/Recovery Green.
3. Finalize this docs branch from the actual completed evidence and open a docs-only PR.
4. Merge any Green PR only after fresh head/mergeability and exact `expected_head_sha`.
5. Keep #19 open until Ruleset write is genuinely available.
6. Production signing remains a separate security-sensitive slice after keystore/credential ownership is defined.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
