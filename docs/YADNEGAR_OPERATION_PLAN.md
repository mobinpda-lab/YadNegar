# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.3 — Reminder Presence Filter Complete

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
Current product main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Main شامل:
- Timeline foundation واحد
- schema v3 برای Reminder recurrence
- backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- نمایش مستقیم وضعیت Reminder روی کارت Timeline
- فیلتر Reminder presence: همه / دارای یادآور / بدون یادآور
- Search/Type/Date composition + clear/export behavior
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Completed Reminder Waves
### Recurring Reminder — #93
- PR #96 / Issue #94: recurrence contract + schema v3 + v1/v2 compatibility
- PR #97 / Issue #95: daily/weekly device-local scheduling + Persian UX
- #98 docs sync
- parent #93 completed

### Timeline Reminder Status — #99 / PR #100
Product merged to `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`.
Docs PR #101 merged to `fb2a02624421ba135de87357817d13922fed7abf` and post-main Fast CI passed.
Issue #99 completed.

## 5. Reminder Presence Filter — #102 / PR #103
Final product head:
`256c2f05a5ce0d4bfaba6c9a711e7470d78f932a`

Merged main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Scope واقعی:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_filter_test.dart`

رفتار:
- همه موارد
- دارای یادآور
- بدون یادآور
- compose با Search/Type/Date فعلی
- clear موجود همه فیلترها را Reset می‌کند
- export موارد visible فعلی را استفاده می‌کند

Pre-merge:
- CI `33092820178`: success
- Android `33092820203`: success across full chain

Post-main:
- CI `33093725156`: success
- Android `33093725042`: success
- Build/Candidate/Smoke-Recovery/Readiness/Release-Draft/Approval all success

## 6. Product Foundation
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Current storage schema: v3  
Compatibility: v1/v2 reads پشتیبانی می‌شوند.

هیچ Model / Repository / Storage / AppShell / Reminder DB / Scheduler موازی وجود ندارد.

## 7. Automation / Documentation
### Issue #19
Ruleset `main-protection` فعال است و PR را اجباری می‌کند و deletion/non-fast-forward را می‌بندد، اما required status checks هنوز Platform-level enforce نشده‌اند. Connected tooling Ruleset Write ندارد.

قانون عملی تا enforcement واقعی:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

### Active Docs Sync — #102
Branch:
`docs/timeline-reminder-filter-live`

هدف: چهار سند Current State / Persian Handoff / Operation Plan / Comprehensive Reference را با outcome واقعی #102/#103 همگام کند.

Merge Contract:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI
6. Close #102 فقط بعد از proof

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
1. Docs sync نهایی برای #102/#103
2. Issue #104 — distinct Timeline type icons، presentation-only
3. Issue #19 — required-status enforcement gap

### #104 Integration Dependency
Branch `product/timeline-type-icons` می‌تواند موازی آماده و تست شود، اما Merge فقط بعد از ادغام/Verify مستندات #102 و Fresh compare مستقل مجاز است.

### Security-separated
Production signing / real tag / release / publish فقط با Owner/Security decision صریح.

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
