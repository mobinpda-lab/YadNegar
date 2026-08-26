# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.6 — Delete Integrated + Undo Active

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
`509817c344d014579e28f62d64ff8465b722f3b9`

Main شامل Timeline واحد، JSON persistence واقعی/crash-recoverable، Quick Capture/Load/Edit، پنج Type، Search/Type/Date، occurredAt capture/edit، card time context، اصلاح Type، و اکنون حذف امن با confirmation فارسی است.

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — PR #61 / Issue #57
Exact pre-merge head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`
- Fast CI `33020857429`: success
- Android `33020857455`: success
- Android build + verify + upload: success
- live mergeability: clean
- merge با expected-head lock
- merged main: `509817c344d014579e28f62d64ff8465b722f3b9`

Delete روی Repository/Storage موجود انجام می‌شود، Search/Type/Date state را حفظ می‌کند و هیچ schema/soft-delete/tombstone foundation جدیدی ندارد.

Post-main Fast CI + Android برای main جدید در حال اجرا هستند.

## 4. Product Slice فعال — PR #63 / Issue #59
`feat(timeline): allow undo after item deletion`

Branch: `feature/delete-undo-stacked`  
Current head: `5d651814147289ae3b410d5f023eb777fb91f53e`  
Base: `main` at `509817c...`  
Status: Draft

Scope فقط ۵ فایل:
- `RestoreTimelineItem` با reuse `findById + upsert`
- conflict check برای جلوگیری از overwrite داده جدیدتر
- action فارسی `بازگردانی`
- restore همان TimelineItem در حافظه
- reload از state/filter path موجود
- application/widget tests

ممنوع:
- Repository contract جدید
- schema/storage جدید
- soft-delete/tombstone/history foundation
- duplicate delete/edit path

## 5. Lane A — Core/Data
Undo Core آماده است:
- restore فقط اگر ID آزاد باشد
- metadata اصلی حفظ می‌شود
- existing repository methods reuse می‌شوند

## 6. Lane B — Product/UX
Undo UX آماده است:
- SnackBar action پس از حذف
- Search/Type/Date حفظ می‌شود
- widget flow برای delete → undo موجود است

یک conflict-path widget proof نهایی قبل از validation exact-head اضافه می‌شود.

## 7. Lane C — CI/Automation/Docs
- PR #50 Draft و هم‌زمان refresh می‌شود
- Issue #62 incident ثبت workflow/merge-ref باز است
- Issue #19 Ruleset required-status gap باز است
- #61 نشان داد incident recoverable است، اما #62 فقط بعد از اثبات تکرارپذیر روی PR بعدی بسته می‌شود

## 8. Merge Contract
1. exact current head
2. Fast CI Green همان head
3. Android Green همان head
4. live mergeability true
5. `expected_head_sha` lock
6. post-main Fast + Android proof

Historical Green معتبر نیست.

## 9. Automation Recovery Rule
اگر run جدید ثبت نشد:
- workflow و raw PR state را Fresh audit کن
- duplicate workflow نساز
- historical run را به Head جدید نسبت نده
- incident را در #62 ثبت کن
- Laneهای مستقل Product/Docs را ادامه بده

## 10. Ruleset — Issue #19
Required status check هنوز از طریق Connector قابل‌نوشتن/اثبات نیست. Operational lock تا رفع واقعی اجباری است.

## 11. Documentation Contract
- PR #50 replacement/Draft
- docs هم‌زمان با Product refresh می‌شوند
- قبل از Merge docs: final main structural sync + Fresh Audit + exact-head gates + safe merge

## 12. Queue
### Active
1. PR #63 / Issue #59 — Undo deletion
2. PR #50 — parallel docs reconciliation
3. Issue #62 — workflow registration incident
4. Issue #19 — Ruleset enforcement gap

### Just completed
- PR #61 / Issue #57 — safe delete with confirmation

## 13. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
