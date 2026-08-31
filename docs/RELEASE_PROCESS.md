# YADNEGAR Release Process

## Pipeline

Development
↓
CI Green
↓
PR Validation
↓
Release Candidate
↓
Production Signing
↓
Production Release
↓
Production Monitoring / Recovery

## Rules

- No major change without validation.
- Merge only after required exact-head checks.
- Historical Green evidence never transfers after the PR head moves.
- Production Orchestrator remains the canonical merge authority.
- A PR must remain based on the current `main` and `behind_by=0` before promotion.
- Post-main CI and Android proof must be tied to the exact merged `main` SHA.
- Production release must fail closed unless a production-signed artifact, checksum, source SHA and release manifest are verified.
- Documentation and traceability are updated from verified GitHub evidence only.
- The generated Autonomous Factory status is refreshed on every `main` update, after completed Android Build runs on `main`, and by the hourly safety sweep. Pull-request Android runs do not update the generated main-state report.

## Verified RC baseline — 2026-08-31

Current verified `main` after PR #203:

`0191ceed40768e0519010071ac8c21309c471f5e`

Exact-main proof on the current baseline:

- YadNegar CI run `33422019524` / #509: `completed / success`.
- YadNegar Android Build run `33422021648` / #265: `completed / success`.
- YadNegar Autonomous Queue run `33423147476` / #2: `completed / success`; no eligible autonomous task was present, so no worker lease was created.
- PR #201 merged the factual recovery-evidence detector and Android gate trigger coverage for factory-status workflow changes.
- Controlled bounded-recovery evidence is recorded in #187 and #193, including exhausted 3-attempt source runs and deduplicated escalation records.
- PR #202 synchronized verified RC/release evidence into canonical documentation.
- PR #203 added Android-completion refresh for the generated factory status, but live audit after the exact-main Android #265 completion found no corresponding Factory Status run and the generated status comment on #194 remained tied to older main. The existing status workflow is therefore also triggered directly on every `main` update so generated evidence cannot remain stale while the Android-completion trigger and hourly sweep remain as additional refresh paths.
- No open PR existed at the start of this correction.

## Remaining release blockers

The repository-side release controllers are installed and remain fail closed. A real Production Release is not yet allowed because:

1. Production Android signing material is external and must be supplied through GitHub Secrets/OIDC. Tracking: #185.
2. A persistent autonomous code-worker execution backend is not connected. Tracking: #184. GitHub Actions orchestration alone is not counted as code-worker execution evidence.
3. Required status checks are not yet platform-enforced in the main ruleset because the connected tooling does not expose a safe ruleset-write operation. Tracking: #19. Exact-head merge safety continues to be enforced by Production Orchestrator.
4. A real GitHub Release and post-release monitoring/rollback execution evidence remain blocked by production signing. Tracking: #188 and #191.

## Release evidence policy

A release may be considered production-ready only when all of the following are verified for the exact current `main` SHA:

- CI success.
- Android build + emulator/storage recovery proof success.
- Production signing success with no debug-key fallback.
- Signed artifact manifest contains the exact source SHA, version, application ID, checksum and byte size.
- Release controller verifies tag/version availability and creates one immutable GitHub Release.
- Release assets and provenance are monitored after publication; failures create a deduplicated incident and bounded recovery/rollback follows only verified provenance.

Running, skipped, missing or YAML-only capabilities are not release success evidence.
