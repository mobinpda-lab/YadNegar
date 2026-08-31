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

## Verified RC state — 2026-08-31

Canonical `main`:

`ec6c5995d21f63e79ecf0b7e3e83c253c5f89584`

Latest verified post-main proof on that exact SHA:

- YadNegar CI run `33388964263` / #505: `completed / success`.
- YadNegar Android Build run `33388965459` / #262: `completed / success`.
- PR #201 merged the factual recovery-evidence detector and Android gate trigger coverage for factory-status workflow changes.
- Controlled bounded-recovery evidence is recorded in #187 and #193, including exhausted 3-attempt source runs and deduplicated escalation records.
- No open PR remained immediately after PR #201 promotion.

## Remaining release blockers

The repository-side release controllers are installed and remain fail closed. A real Production Release is not yet allowed because:

1. Production Android signing material is external and must be supplied through GitHub Secrets/OIDC. Tracking: #185.
2. A persistent autonomous code-worker execution backend is not connected. Tracking: #184. GitHub Actions orchestration alone is not counted as code-worker execution evidence.
3. Required status checks are not yet platform-enforced in the main ruleset because the connected tooling does not expose a safe ruleset-write operation. Tracking: #186 and legacy pointer #19. Exact-head merge safety continues to be enforced by Production Orchestrator.
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
