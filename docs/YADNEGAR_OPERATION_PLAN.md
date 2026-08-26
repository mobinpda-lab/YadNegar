# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.1 — Retrieval Integrated + occurredAt Capture Active

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

## 2. وضعیت Verify‌شده main
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

Current-main proof after PR #47:
- Fast CI Run `33015057876`: success
- Android Build Run `33015057863`: success

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

Shared `TimelineItemType` supports Note/Event/Call/Idea/Activity.

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

Recent completed items:
- PR #42 / Issue #41 — persistence reliability
- PR #47 / Issue #46 — date-range retrieval UI

## 4. Active Product Slice — PR #49 / Issue #48
`feat(capture): add optional occurredAt for Event and Activity`

Exact PR head at this snapshot:
`20597e134e08dcb4a6b1c910ed8d38cdbd99ee6b`

Fresh code audit showed the foundation already existed:
- `TimelineItem.occurredAt`
- `TimelineItem.timelineAt`
- `QuickCapture.capture(occurredAt: ...)`

Implementation scope is UI/composition only:
- optional Persian/RTL date + time for Event/Activity
- pass selected value to existing `QuickCapture`
- Note/Call/Idea keep current fast capture behavior
- clear selected occurredAt
- clear hidden occurredAt draft when switching to unsupported type
- focused widget regression coverage

No Timeline model, use case, Repository, Storage, Schema, or dependency was added.

Validation at this snapshot:
- `YadNegar CI` Run `33015406333`: success
- `YadNegar Android Build` Run `33015406042`: in progress
- live mergeability last verified: true

Merge only after Android is Green, then re-read exact head + mergeability and use expected-head lock.

## 5. Parallel Execution Model
### Lane A — Core / Data Reliability
Stable:
- shared Timeline Domain
- real schema-versioned JSON persistence
- crash recovery

Do not add DB/indexing/pagination without real scale/performance evidence.

### Lane B — Product / UX
Active:
- PR #49 occurredAt capture UI

After integration, choose the next gap from fresh code/issue audit. A likely area to audit is whether Timeline cards expose the existing `timelineAt` meaningfully, but do not create work until duplicate/open-issue checks are completed.

### Lane C — CI / Documentation / Governance
Active:
- Draft PR #50 replaces stale PR #43
- PR #43 was closed without merge
- #50 tracks current main + active #49 and must be final-synced after #49 settles
- Issue #19 remains Ruleset gap

## 6. PR / Merge Contract
Every product PR:
- one clear primary goal
- reuse existing contracts before creating anything
- focused relevant tests
- exact-head `YadNegar CI` Green
- Android Build exact-head Green for product/build surfaces
- live head and mergeability re-read immediately before merge
- merge with `expected_head_sha` where supported
- post-merge main validation

If main advances after branch creation, synchronize first and rerun gates.

## 7. Retrieval Contract
Integrated MVP:
- `SearchTimeline` handles query/type
- `FilterTimelineByDateRange` handles start-inclusive/end-exclusive date boundary
- UI composes Date + Text + Type without a duplicate storage path

UI selected end day is inclusive by converting it to next-day exclusive Application boundary.

A unified `QueryTimeline` optimization is optional only when real read/latency evidence justifies it.

## 8. Persistence Contract
JSON persistence is:
- real
- application-support based
- schema-versioned
- crash-recoverable with `.tmp`/`.bak`
- test-covered with real temp files/directories
- replaceable

Do not add a DB for appearance.

## 9. CI / Android Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

After PR #45:
- feature work validates through PR to main
- push quality remains on main
- duplicate feature push + PR quality runs are avoided

## 10. Ruleset Reality
Active `main-protection` id `20952887` requires Pull Requests and protects deletion/non-fast-forward, but does not currently contain a required-status-check rule.

Issue #19 owns this gap.

Until real Ruleset write capability is available and proven:
`exact-head Green gates + live mergeability + expected-head merge lock` is mandatory.

## 11. Documentation Contract
Canonical governance:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

Active plan:
`docs/YADNEGAR_OPERATION_PLAN.md`

Current state:
`docs/AI_CONTINUATION_STATE.md`

Handoff:
`docs/AI_HANDOFF_CURRENT_FA.md`

PR #43 is closed stale history. Draft PR #50 is its clean replacement and must be final-synced after active product integration before merge.

## 12. Current Work Queue
### Active
1. PR #49 / Issue #48 — occurredAt Event/Activity Quick Capture UI.
2. Draft PR #50 — documentation reconciliation; final sync after #49.
3. Issue #19 — required CI status in Ruleset; blocked by actual write capability.

### Recently Completed
- PR #44 — typography
- PR #45 — CI deduplication
- PR #42 / Issue #41 — crash-recoverable persistence
- PR #47 / Issue #46 — date-range retrieval UI

## 13. Definition of Done
Product slice:
`Working capability + tests + exact-head CI + Android proof + safe merge + post-main validation + docs impact`

Docs slice:
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
- query/date/capture logic duplicate در UI
- fake persistence/build/test
- merge با stale evidence
- ادعای required status check بدون Ruleset proof
- توقف Lane مستقل به خاطر Build در حال اجرا
- نگه داشتن سند عملیاتی stale
- درصد پیشرفت ساختگی

## 16. گزارش مالک پروژه
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی و نتیجه‌محور.
