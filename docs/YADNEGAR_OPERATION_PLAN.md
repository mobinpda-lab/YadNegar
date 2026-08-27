# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.2 — Timeline Reminder Status Complete

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
`8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

Main شامل:
- Timeline foundation واحد
- schema v3 برای Reminder recurrence
- backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- نمایش مستقیم وضعیت Reminder روی کارت Timeline
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Recurring Reminder Wave — Completed
Parent #93 بسته است.

### PR #96 / Issue #94
- recurrence contract: `none / daily / weekly`
- schema v3
- v1/v2 backward compatibility
- safe-write migration با recovery موجود

### PR #97 / Issue #95
- daily/weekly device-local scheduling
- Persian recurrence UX
- timezone-safe reconciliation
- fail-closed recurrence on timezone resolution failure
- persist-first behavior
- no exact-alarm permission

## 5. Timeline Reminder Status — Issue #99 / PR #100
Final product head:
`32fd20609daa8d6fea74c325fecb14e096c0106d`

Merged main:
`8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

Scope واقعی:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_status_test.dart`

رفتار:
- no reminder => no row
- one-shot => date/time
- daily => `روزانه` + clock
- weekly => `هفتگی` + Persian weekday + clock

Pre-merge:
- CI `33086840280`: success
- Android `33086840284`: success

Post-main:
- CI `33087745543`: success
- Android `33087745462`: success
- Build/Candidate/Smoke-Recovery/Readiness/Release-Draft/Approval all success

## 6. Product Foundation
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3  
Compatibility: v1/v2 reads پشتیبانی می‌شوند.

هیچ Model / Repository / Storage / AppShell / Reminder DB / Scheduler موازی وجود ندارد.

## 7. Automation / Documentation
### Issue #19
Ruleset فعلی PR را اجباری می‌کند و deletion/non-fast-forward را می‌بندد، اما required status checks هنوز Platform-level enforce نشده‌اند. Connected tooling Ruleset Write ندارد.

قانون عملی تا enforcement واقعی:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

### Active Docs Sync
Branch:
`docs/timeline-reminder-status-live`

هدف: چهار سند Current State / Persian Handoff / Operation Plan / Comprehensive Reference را با outcome واقعی #99/#100 همگام کند.

Merge Contract:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI
6. Close #99 فقط بعد از proof

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
1. docs sync برای outcome #99/#100
2. Issue #19 — required-status enforcement gap

### Next Product Discovery
3. Fresh Audit معماری Search/Filter موجود
4. انتخاب یک Slice کوچک و reuse-first که به schema/storage/scheduler جدید نیاز نداشته باشد
5. ایجاد Issue/Branch فقط بعد از اثبات Scope مستقل
6. exact-head CI/Android + expected-head merge + post-main proof + concurrent docs

### Security-separated
7. Production signing / real tag / release / publish فقط با Owner/Security decision صریح

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
