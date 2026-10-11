# YadNegar — Canonical Completion & Execution Map

## 0. Authority and independence
- Reference HEAD for this map: `8020b8241b2eb1133854947da8b04e4bc530e99c` on `main`.
- This document is for **YadNegar product only**. It is not an Arvin, NIRA or Payesh plan.
- Learn only general engineering patterns from other projects; implement independently. Never transfer project-specific code, business logic, roadmap, scope, issues, bugs, data, secrets, artifacts or dependencies.
- Historical PRs/branches/issues are not current gaps until reconciled against current `main`.

## 1. Required lifecycle
Every capability progresses through: `Planned → Implemented → Executed → Verified → Proven`.
No capability is complete merely because code, a PR or a test exists.

## 2. P0 — Product integrity and release blockers
1. **Canonical Timeline/persistence** — one authoritative repository path; preserve schema compatibility and safe recovery.
2. **Migration and backup/restore** — schema migrations, JSON recovery/backup behavior, corruption/partial-write handling and reproducible evidence.
3. **Notification/scheduler reliability** — scheduled reminders, restart, overdue, duplicate prevention and Android runtime behavior.
4. **Release evidence** — exact-head tests, analyze/CI, security, release build, artifact integrity, installability and release delivery.

## 3. P1 — Medication / reminder capability
5. **Actual-dose anchored consumption reminder** — current main contains the merged implementation from PR #239: `actualTakenAt + interval` anchoring and single-reminder persistence.
6. Complete the remaining acceptance evidence for this capability: UI behavior, persistence/schema migration, backup/restore, scheduler, restart, overdue cases, duplicate prevention, full CI and release-grade proof.
7. Verify edge cases: repeated consumption, late consumption, missing/invalid timestamps and rescheduling without parallel persistence systems.

## 4. P1 — Core journal/timeline product
8. Timeline creation/edit/delete and chronological behavior.
9. Persian/Jalali date/time behavior and RTL UI.
10. Notes/events/history organization and search/edit flows where contracted.
11. Widget/device projection and Android runtime behavior where contracted.

## 5. P2 — Quality and release hardening
12. Regression suite covering persistence, migration, scheduler and restart.
13. Security and data-integrity checks.
14. Build reproducibility and artifact provenance.
15. Performance/accessibility/visual polish after functional release blockers.

## 6. Execution order
- P0 integrity/release blockers first.
- P1 medication and timeline capabilities proceed in parallel when files/contracts are independent.
- P2 hardening follows functional stability but may run concurrently where it does not touch shared foundations.
- Never create a second persistence/store/scheduler merely to accelerate a feature.

## 7. Evidence ledger
For each capability record exact HEAD, acceptance criteria, implementation source, targeted tests, CI run, security result, build/artifact, runtime/installability evidence and remaining gap. Revalidate when HEAD, PR, CI, artifact or evidence changes.

## 8. Anti-forgetting rule
This is the ordered completion checklist for YadNegar. Update this document when the product contract or verified evidence changes; do not create competing status documents. A capability moves to `Proven` only after its full acceptance and evidence chain is satisfied.
