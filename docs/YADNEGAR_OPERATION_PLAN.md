# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.1 — Recurring Reminder Wave Complete

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
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Main شامل:
- Timeline foundation واحد
- schema v3 برای Reminder recurrence
- backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Recurring Reminder Wave — Completed
Parent: Issue #93

### Issue #94 / PR #96
`recurrence contract + schema v3 migration`

Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

Pre-merge:
- CI `33078963061`: success
- Android `33078963046`: success

Post-main:
- CI `33079988610`: success
- Android `33079988616`: success

### Issue #95 / PR #97
`Android scheduling + Persian recurrence UX`

Final head:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

رفتار نهایی:
- none => one-shot فعلی
- daily => ساعت محلی دستگاه
- weekly => روز هفته + ساعت محلی دستگاه
- past anchor => occurrence بعدی آینده
- timezone قبل از startup/Restore reconciliation
- timezone failure => recurrence fail-closed؛ داده rollback نمی‌شود
- Persian UI: `بدون تکرار / روزانه / هفتگی`
- persist-first حفظ شده
- clear reminder => recurrence none
- no exact-alarm permission

Pre-merge:
- CI `33080762656`: success
- Android `33080762586`: success

Merged main:
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Post-main:
- CI `33081668902`: success
- Android `33081668913`: success

## 5. Product Foundation
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3  
Compatibility: v1/v2 reads پشتیبانی می‌شوند.

هیچ Model / Repository / Storage / AppShell / Reminder DB / Scheduler موازی وجود ندارد.

## 6. Automation / Documentation
### Issue #19
Ruleset فعلی PR را اجباری می‌کند و deletion/non-fast-forward را می‌بندد، اما required status checks هنوز Platform-level enforce نشده‌اند. Connected tooling Ruleset Write ندارد.

قانون عملی تا enforcement واقعی:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

### PR #98 — Final Recurring-Reminder Docs
چهار سند Current State / Persian Handoff / Operation Plan / Canonical Governance با outcome واقعی #97 همگام می‌شوند.

Merge Contract:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI
6. Close parent #93

## 7. Next Product Slice — Issue #99
`product: surface reminder status on Timeline cards`

هدف: کاربر بدون بازکردن Edit بداند Timeline item reminder دارد یا تکرارشونده است.

Scope:
- Presentation-only
- reuse `TimelineItem.reminderAt` + recurrence
- no reminder => no reminder row/badge
- one-shot => reminder date/time
- daily => `روزانه` + clock time
- weekly => `هفتگی` + weekday/clock summary
- focused TimelineScreen widget tests

Out of scope:
- schema
- repository/storage
- scheduler
- navigation/screen foundation
- Reminder DB

Dependency: Implementation فقط پس از بسته‌شدن کامل #93.

## 8. Merge Contract
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

## 9. خط قرمز
- duplicate workflow/foundation/storage
- fake/stale evidence
- destructive migration
- risky direct main edits
- secret/keystore داخل Repository
- production-signing claim بدون verified config
- Tag/Release/Play Store mutation بدون Owner/Security decision
- حذف Gate برای سرعت

## 10. Queue
### Active
1. PR #98 — final recurring-reminder docs gate + merge
2. Issue #19 — required-status enforcement gap

### Immediately After #98
3. Verify docs post-main Fast CI
4. Close parent Issue #93
5. Start Issue #99 as a small UI-only branch/PR
6. Run exact-head Fast CI + relevant Android gate
7. Merge with expected-head lock + post-main proof + concurrent docs

### Security-separated
8. Production signing / real tag / release / publish only with explicit Owner/Security decision

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
