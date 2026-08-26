# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.1 — Retrieval Integrated + Next Capture Slice

**تاریخ مبنا:** 2026-08-27  
**وضعیت:** Current execution plan  
**مرجع حقیقت:** GitHub Repository State  
**مرجع قواعد:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
**Current State:** `docs/AI_CONTINUATION_STATE.md`  
**Handoff:** `docs/AI_HANDOFF_CURRENT_FA.md`

## 1. هدف اجرایی
YadNegar یک Flutter MVP واقعی با Timeline یکپارچه، Persistence واقعی، Retrieval قابل‌استفاده و Android Build واقعی است.

چرخه تحویل:
`Gap واقعی → Reuse existing contract → Small branch/PR → Test → exact-head CI/Android → safe merge → main proof → docs sync → next slice`

سرعت از موازی‌سازی Laneهای مستقل و جلوگیری از دوباره‌کاری می‌آید؛ نه از حذف Gate.

## 2. وضعیت Verify‌شده فعلی
### main
Current integrated product head:
`453a77a9e662f705bed8f899a769b425927bebb4`

Main شامل:
- Flutter/Dart + Persian RTL foundation
- Timeline Domain واحد
- `TimelineRepository`
- JSON persistence واقعی و schema-versioned MVP
- crash-recoverable staged JSON replacement/recovery
- Quick Capture / Load / Edit application logic
- typed Quick Capture برای Note/Event/Call/Idea/Activity
- Timeline UI واقعی
- `SearchTimeline` + text/type UI
- `FilterTimelineByDateRange` + date-range UI
- Date + Text + Type composition
- Vazirmatn + optional private licensed IRANSansX
- Fast CI
- Android debug APK Build Gate
- deduplicated feature PR/main quality triggers

No duplicate Model/Repository/Storage/AppShell exists.

### Current post-merge validation
On main `453a77a...`:
- Fast CI Run `33015057876`: running at this snapshot
- Android Build Run `33015057863`: running at this snapshot

Fresh-read before updating these conclusions.

## 3. Completed Waves
### Wave 0 — Governance / Reality Baseline
**COMPLETED**

### Wave 1 — Flutter Foundation
**COMPLETED**

### Wave 2 — Domain / Persistence / CI Consolidation
**COMPLETED**

### Wave 3 — First Product Vertical Slice
**COMPLETED**

`Quick Capture → Persist → Timeline → View/Edit`

### Wave 3.5 — Android Foundation / Build Gate
**COMPLETED**

### Wave 4 — Typed Product Expansion
**COMPLETED FOR CURRENT SCOPE**

Shared `TimelineItemType` supports:
- Note
- Event
- Call
- Idea
- Activity

### Wave 5 — Retrieval & Reliability
**COMPLETED FOR CURRENT MVP SCOPE**

Integrated:
- Search application boundary
- RTL Search + Type UI
- date-range application boundary
- RTL Date Range UI
- combined Text + Type + Date retrieval
- crash-recoverable JSON persistence
- CI duplicate-trigger fix

Recent integration evidence:
- PR #42 / Issue #41: persistence reliability completed
- PR #47 / Issue #46: date-range UI completed

## 4. Active Wave — Capture Semantics
### Issue #48
`feat(capture): expose occurredAt for Event and Activity`

Fresh audit shows no new foundation is needed:
- `TimelineItem.occurredAt` exists
- `TimelineItem.timelineAt` already prefers occurredAt over createdAt
- `QuickCapture.capture(occurredAt: ...)` exists

The product gap is only UI/composition.

### Intended slice
For Event/Activity Quick Capture:
- optional Persian/RTL date/time selection
- pass chosen value to the existing `QuickCapture` use case
- default capture remains fast and optional
- Note/Call/Idea current behavior remains stable
- no new repository/storage/model/schema
- widget tests for with/without occurredAt

Implementation should begin from current main after the active docs synchronization is safely settled, because the previous retrieval slice touched the same Timeline UI surface.

## 5. Parallel Execution Model
### Lane A — Core / Data Reliability
Current state:
- shared Timeline Domain stable
- JSON persistence real and crash-recoverable
- no DB migration justified yet

Next work only when evidence requires it:
- migration/recovery hardening
- query optimization
- indexing/pagination/DB migration

### Lane B — Product / UX
Current next owner:
- Issue #48 occurredAt capture UI

After #48, choose the next gap from a fresh product/code audit. Do not prebuild speculative foundations.

### Lane C — CI / Documentation / Governance
Current:
- post-merge validation on main `453a77a...`
- clean docs replacement branch `docs/current-state-after-reliability`
- stale PR #43 must be superseded/closed
- Issue #19 remains Ruleset gap

## 6. PR / Merge Contract
Every product PR:
- one clear primary goal
- reuse existing contracts before creating anything
- relevant focused tests
- exact-head `YadNegar CI` Green
- Android Build exact-head Green when product/build surface changes
- live head and mergeability re-read immediately before merge
- merge with `expected_head_sha` where supported
- post-merge main validation

If main advances after branch creation, synchronize first and rerun gates.

## 7. Retrieval Contract
Current MVP contract is integrated:
- repository snapshot
- `SearchTimeline` for query/type
- `FilterTimelineByDateRange` for start-inclusive/end-exclusive range
- UI composes date results with search/type results

UI end-date semantics:
- selected end day is user-inclusive
- application receives next-day exclusive boundary

Optimization such as a unified `QueryTimeline` is optional only when real read/latency evidence justifies it. It is not a blocker for current product work.

## 8. Persistence Contract
JSON persistence is:
- real
- stored in application support directory
- schema-versioned
- crash-recoverable with `.tmp`/`.bak`
- test-covered with real temporary files/directories
- replaceable

Do not add a DB for appearance. Require real evidence such as query volume, transaction needs, migration needs, or performance limits.

## 9. CI / Android Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

CI trigger model after PR #45:
- feature work validates via PR to `main`
- push quality remains on `main`
- avoid duplicate push + PR quality runs for the same feature SHA

## 10. Ruleset Reality
Active `main-protection` ruleset id `20952887` requires Pull Requests and protects deletion/non-fast-forward, but does not currently contain a required-status-check rule.

Issue #19 owns this gap.

Until real Ruleset write capability is available and verified:
`exact-head Green gates + live mergeability + expected-head merge lock` is mandatory operational enforcement.

## 11. Documentation Contract
Canonical governance:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

Active plan:
`docs/YADNEGAR_OPERATION_PLAN.md`

Current state:
`docs/AI_CONTINUATION_STATE.md`

Handoff:
`docs/AI_HANDOFF_CURRENT_FA.md`

PR #43 is stale. Replacement branch:
`docs/current-state-after-reliability`

Do not merge stale snapshots merely to close documentation work.

## 12. Current Work Queue
### Active
1. Finish post-merge Fast + Android validation on `453a77a...`.
2. Open/validate clean docs replacement PR; close stale #43 as superseded.
3. Issue #48 occurredAt Event/Activity capture UI.
4. Issue #19 Ruleset required-status gap remains blocked by actual write capability.

### Recently Completed
- PR #44 — typography
- PR #45 — CI deduplication
- PR #42 / Issue #41 — crash-recoverable persistence
- PR #47 / Issue #46 — date-range retrieval UI

## 13. Definition of Done
A product slice is Done when applicable:
`Working capability + tests + exact-head CI + Android proof + safe merge + post-main validation + docs impact`

A docs slice is Done when:
`Fresh GitHub reconciliation + exact-head validation + non-stale merge`

## 14. Work Queue Hygiene
Every continuation:
1. main SHA audit
2. open PR audit
3. exact-head workflow audit
4. issue ownership audit
5. duplicate/stale detection
6. independent lane execution
7. safe merge
8. main validation
9. docs refresh
10. next real product gap

## 15. خط قرمزها
- Foundation دوم
- App Shell دوم
- Timeline Model دوم
- Repository/Storage موازی
- query/date logic duplicate در UI
- fake persistence/build/test
- merge با stale evidence
- ادعای required status check بدون Ruleset proof
- توقف Laneهای مستقل به خاطر یک Build در حال اجرا
- نگه داشتن سند عملیاتی stale
- درصد پیشرفت ساختگی

## 16. گزارش مالک پروژه
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی و نتیجه‌محور.
