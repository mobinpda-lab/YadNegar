# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.9 — Export Integrated / Backup Next

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در چند ساعت به‌جای چند روز.

چرخه:
`Fresh Audit → Reuse → Small PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند.

## 2. main فعلی
`40415af1f064a7ef7298ce9993ee949c52664bff`

Main شامل Timeline واحد، JSON persistence واقعی/crash-recoverable، Quick Capture/Load/Edit، پنج Type، Search/Type/Date، occurredAt capture/edit، اصلاح Type، حذف امن، Undo و Export visible Timeline است.

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — Export
PR #65 / Issue #64

Exact pre-merge head:
`114fca4cdfd2269d5d4ff906ce96afe0590a7162`

Pre-merge proof:
- CI `33026398124`: success
- Android `33026398078`: success
- Android build + verify + upload: success
- live mergeable=true
- merged with expected-head lock

Merged main:
`40415af1f064a7ef7298ce9993ee949c52664bff`

Post-main proof:
- CI `33026680361`: success
- Android `33026680302`: success
- Android build + verify + upload: success

Export behavior:
- pure text formatter
- exact visible Timeline items are exported
- current Search/Type/Date state is naturally reflected
- no second repository query
- Clipboard only at presentation edge
- no dependency/schema/storage/repository-contract change

## 4. Lane A — Core/Data
Foundation remains stable:
- one Timeline model
- one Repository contract
- one crash-recoverable JSON storage

Next Backup work must reuse the existing validated/recovered storage representation rather than introducing a second serializer or storage contract.

## 5. Lane B — Product/UX
Export is integrated.

Next candidate is Issue #67 — validated portable backup snapshot.
Do not start Restore/Import or Reminder inside the same Slice.

## 6. Lane C — CI/Automation/Docs
- PR #66 final Wave 6 documentation lane is structurally synced onto exported main
- final docs refresh must receive a fresh exact-head Fast CI before merge
- Issue #62 recovered/closed
- Issue #19 required-status Ruleset gap remains open

## 7. Merge Contract
1. exact current head
2. Fast CI Green on that head
3. Android Green on that head for Product changes
4. live mergeability true
5. `expected_head_sha` lock
6. post-main proof

Historical Green is never reused for a new head.

## 8. Wave 6 Next — Issue #67 Backup
Objective: create a validated portable Timeline backup snapshot.

Fresh audit:
- source data is `Application Support/timeline.json`
- repository storage is schema-versioned and crash-recoverable
- Backup should snapshot valid storage bytes after recovery/validation
- primary user data must not be mutated
- Restore/Import is out-of-scope and needs its own validation/rollback Slice
- Reminder remains higher risk because of scheduling/permission/data-contract concerns
- Share/Save dependency must be compatible with the pinned Flutter/Android toolchain before adoption

Do not create the Backup branch until PR #66 is final-merged.

## 9. Queue
### Active
1. PR #66 — final docs after Export
2. Issue #67 — next Product candidate: validated portable Backup
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- PR #65 / Issue #64 — visible Timeline Export
- PR #50 — documentation reconciliation
- PR #63 / Issue #59 — Undo deletion
- PR #61 / Issue #57 — safe delete
- Issue #62 — workflow registration incident recovered/closed

## 10. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof
- duplicate JSON serializer for Backup
- mixing Restore/Reminder into Backup Slice

## 11. قدم بعد
- final exact-head CI برای #66
- Green → Ready → Fresh mergeability → expected-head merge
- Verify docs-only main with Fast CI
- compatibility audit Android/Share for #67
- then create the smallest safe Backup branch

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
