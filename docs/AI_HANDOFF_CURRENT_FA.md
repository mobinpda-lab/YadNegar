# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.
Active operation plan: `docs/YADNEGAR_OPERATION_PLAN.md` v2.0.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `369296a0b85862859b75cbbbed401921e7e04cd0`

## Integrated Product
- `Quick Capture → Persist → Timeline → View/Edit`
- typed Quick Capture
- Search Application + Persian RTL Search UI/type filter
- date-range retrieval foundation
- production-safe JSON persistence
- Android foundation
- Fast CI + real APK Build Gate

No duplicate Model/Repository/Storage/AppShell exists.

## Latest Integrated Retrieval
PR #38 Search UI merged as `feee7e92464df470a4ad14b8a5437bf5a7bc8648` after exact-head Fast + Android Green and artifact `9619820772`.

PR #40 Date-range final head:
`3c162f2c57fe5b1299d14b63d2dd1a8fe538c308`

Exact-head evidence:
- Fast CI `33004335465`: success
- Android Build `33004335450`: success
- APK artifact `9620025086`
- digest `sha256:eab9b743f6ade550e9723419154d549a61f811b914c429e9adedc625975456b9`

#40 was merged concurrently by another GitHub flow after both gates were Green. Main is now `369296a0b85862859b75cbbbed401921e7e04cd0`.

## Persistence Reliability — PR #42 ACTIVE
Issue #41.
Branch: `persistence/crash-recovery`.
Exact head: `f0ac1dd678a327e67961ea7cb63e80e1a50dc675`.

This branch was restacked on latest main after #40 merged.

Scope:
- staged `.tmp` write + validation
- previous primary `.bak`
- recovery of backup-only interruption
- fallback from corrupted primary to valid backup
- valid first-write temp promotion
- invalid temp discard
- staging cleanup
- same JSON schema / same Repository contract
- focused temp-directory tests

Arvin was fresh-searched for a reusable persistence write pattern; none relevant was found, so YadNegar foundation was extended directly.

Fresh exact-head gates:
- Fast CI `33004964100`
- Android Build `33004964101`

Do not merge until both are Green, exact-head APK artifact exists, and live mergeability is safe.

## Ruleset
`main-protection` id `20952887` is active but still lacks required `YadNegar CI / quality` enforcement. Issue #19 remains open because connector has Ruleset read only.

## Continue
1. Inspect PR #42 Fast/Android jobs and fix real failures on same branch.
2. If Green, verify artifact + live mergeability and merge with expected-head lock.
3. Validate new main after merge.
4. Final-sync/open docs PR and merge only with exact-head docs CI Green.
5. Continue Wave 5 reliability/grouping lanes independently.
6. Keep #19 open until actual Ruleset write exists.

## Reuse From Arvin
Allowed when useful: fresh-audit first, adapt only compatible code/patterns, never create duplicate YadNegar foundations.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
