# YadNegar — Permanent Completion Register

Date: 2026-09-07
Baseline HEAD: `8020b8241b2eb1133854947da8b04e4bc530e99c`

## Project boundary
This register belongs ONLY to `mobinpda-lab/YadNegar`. Arvin-clean, NetworkCenterMonitor/Payesh, Arvin Factory and other projects are independent. No project-specific code, data model, storage, roadmap, business rule, issue or dependency may be copied across projects. Only general engineering patterns may be independently adapted after audit.

## P0 — Current completion gates
- [ ] Reconcile current main with the comprehensive product document, feature spec and roadmap.
- [ ] Finish/verify current post-main CI, Android build, smoke/recovery and release-readiness evidence on the exact current HEAD.
- [ ] Resolve any failure reproduced on current HEAD; stale historical failures do not count.
- [ ] Verify local Backup/Restore end-to-end, validation, overwrite protection and recovery.
- [ ] Keep production signing, release tag, GitHub Release and Play Store publication behind explicit owner authorization.

## P1 — Product roadmap
- [ ] Today/Attention Center: Today, Overdue, Upcoming, No Next Action using derived buckets and no second store.
- [ ] Next Action root-only data contract, migration, set/edit/clear, UI and tests.
- [ ] Tracked-task Reminder integration: safe reschedule/edit/restart reconciliation and notification navigation.
- [ ] Tag + Star + compact filters.
- [ ] Archive + Trash + Restore with history preservation and explicit permanent-delete guard.
- [ ] Multi-select and safe bulk actions.
- [ ] Recurring FollowUp / Next Action with recurrence distinct from Reminder recurrence.
- [ ] Jalali Calendar projection over existing data; no calendar storage path.
- [ ] Date-based reports/PDF/Print/Share over one canonical projection.
- [ ] Backup/Restore UX and then Cloud Backup, only after local reliability is proven.

## P2 — Smart extensions
- [ ] Rule-based attention signals: stale/no-follow-up/overdue/no-next-action/summary.
- [ ] Semantic/smart search only as a complementary layer over exact search and canonical data.
- [ ] History summary, next-action suggestions and other AI assistance only after foundation stability; AI is never source of truth.
- [ ] Additional roadmap/idea items only after reconciliation with current code, issues, PRs, architecture and backup coverage.

## Already present on current main — do not rebuild
- [x] Persistent tracked-task root + child FollowUp model.
- [x] Search over title/description/FollowUp text.
- [x] Jalali/Persian presentation and shared date/time pickers.
- [x] PDF/report projection and Print/Share foundation.
- [x] JSON schema-versioned persistence with backward reads and crash recovery.
- [x] Project support in the same JSON foundation.
- [x] Actual-dose anchored medication-consumption reminder use case at HEAD `8020b824...`, with automated test; integration/UI/release validation must still be verified before treating the feature as fully delivered.
- [x] VazirHarf v34.003 canonical font work already present in recent main history; do not duplicate it.

## Idea queue rule
Every new idea is classified against the live product as DUPLICATE, COMPATIBLE_NOW, COMPATIBLE_LATER, or DECISION_REQUIRED. Compatible ideas become executable only with acceptance criteria and dependency links. Ideas never interrupt an actual blocker and never create a second Repository/DB/Search/Calendar/Report/Backup foundation.

## Definition of complete
A feature is not complete merely because code exists. Applicable implementation, tests, documentation, CI/build, integration/device evidence, recovery/security impact, exact-head validation and safe release status must be proven.

## Permanent anti-forgetting rule
Before YadNegar is declared complete, run this register against current main, canonical product docs, roadmap, open issues/PRs, implementation, workflows, tests, Android artifact, UI/RTL, Backup/Restore, security and release governance. Every applicable item must be completed, explicitly deferred with a reason, or represented by an active blocker.
