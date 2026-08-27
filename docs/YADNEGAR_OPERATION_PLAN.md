# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.0 — Recurring Reminder Wave Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در ساعت‌ها به‌جای روزها.

چرخه:
`Fresh Audit → Reuse → Small/Safe Parallel Slice → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Stacked preparation فقط با Fresh compare و اثبات Scope مستقل قابل Merge است.

## 2. main فعلی
Current main:
`dc58de0e9d4b6aaa90a800a894404e9db86cf4f5`

Main شامل:
- Timeline foundation واحد
- schema v3 برای Reminder recurrence
- backward-compatible v1/v2 reads
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Recurring Reminder Wave — Issue #93
هدف: Reminder تکرارشونده امن با reuse کامل foundation موجود.

### Completed — Issue #94 / PR #96
`recurrence contract + schema v3 migration`

Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

انجام‌شده:
- recurrence: `none / daily / weekly`
- همان TimelineItem و repository
- schema v3
- v1/v2 backward-compatible reads
- no read-time rewrite
- safe-write upgrade با همان tmp/bak recovery
- focused migration/application tests

Pre-merge:
- CI `33078963061`: success
- Android `33078963046`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

Merge با exact `expected_head_sha` انجام شد.

Post-main روی `dc58de0e...`:
- CI `33079988610`: success
- Android `33079988616`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

### Active — Issue #95 / PR #97
`Android scheduling + Persian recurrence UX`

Exact head این revision:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

Scope:
- همان Android Reminder scheduler
- همان Quick Capture/Edit dialogs
- device timezone initialization
- `flutter_timezone` dependency
- همان reminder flow tests

رفتار:
- بدون تکرار: one-shot فعلی
- روزانه: ساعت محلی دستگاه
- هفتگی: روز هفته + ساعت محلی دستگاه
- occurrence قدیمی به اجرای آینده منتقل می‌شود
- timezone قبل از startup/Restore reconcile تعیین می‌شود
- timezone نامعتبر/ناموجود => recurrence fail-closed؛ داده ذخیره‌شده rollback نمی‌شود
- UI فقط هنگام وجود Reminder گزینه‌های `بدون تکرار / روزانه / هفتگی` را نشان می‌دهد
- persist-first حفظ شده است
- پاک‌کردن Reminder recurrence را هم none می‌کند
- exact-alarm permission اضافه نشده است

Validation:
- CI `33080762656`: success
- Android `33080762586`: Build Green؛ Smoke/Recovery هنگام این revision در حال اجرا

Merge فقط پس از Green کامل Android و Fresh head/mergeability انجام می‌شود.

## 5. Product Foundation
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3  
Compatibility: v1/v2 reads پشتیبانی می‌شوند.

هیچ Model / Repository / Storage / AppShell / Reminder DB موازی وجود ندارد.

## 6. Automation / Documentation
### Issue #19
Ruleset فعلی PR را اجباری می‌کند و deletion/non-fast-forward را می‌بندد، اما required status checks هنوز Platform-level enforce نشده‌اند. Connected tooling Ruleset Write ندارد.

قانون عملی تا enforcement واقعی:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

### PR #98 — Documentation
Branch:
`docs/recurring-reminders-live`

Current State / Persian Handoff / Operation Plan / Canonical Governance هم‌زمان با Product Sync می‌شوند.

PR #98 قبل از Merge یک Refresh نهایی از outcome واقعی #97 دریافت می‌کند.

## 7. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/relevant gates Green همان Head
4. stacked dependency post-main Green + Fresh isolated compare
5. live mergeability=true
6. exact `expected_head_sha`
7. post-main proof
8. docs sync

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI

Historical Green برای Head جدید معتبر نیست.

## 8. خط قرمز
- duplicate workflow/foundation/storage
- fake/stale evidence
- destructive migration
- risky direct main edits
- secret/keystore داخل Repository
- production-signing claim بدون verified config
- Tag/Release/Play Store mutation بدون Owner/Security decision
- حذف Gate برای سرعت

## 9. Queue
### Active
1. PR #97 — finish Android + merge gate
2. PR #98 — concurrent documentation
3. Issue #19 — required-status enforcement gap

### After #97
4. post-main proof #97
5. final docs refresh + docs-only merge
6. close parent #93 only after Product + post-main + docs
7. Production signing در Slice امنیتی جدا

## 10. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
