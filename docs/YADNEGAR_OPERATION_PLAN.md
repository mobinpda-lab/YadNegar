# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.7 — Independent Timeline Date-Range Clear Integrated

**تاریخ مبنا:** 2026-08-28  
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

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Stacked preparation فقط با Fresh compare و اثبات Scope مستقل مجاز است.

## 2. main فعلی
Current product main:
`0fbdb1c9dc3473112530843620480a3e7283e7ae`

Main شامل:
- Timeline foundation واحد
- schema v3 و backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- Reminder status روی کارت
- Reminder presence filter: همه / دارای یادآور / بدون یادآور
- Search/Type/Date composition
- آیکن و label مشترک پنج نوع canonical Timeline
- پاک‌کردن مستقل فیلتر نوع با گزینه واقعی `همه انواع`
- پاک‌کردن مستقل Date Range با حفظ query/type/reminder filter
- Export + Backup/Restore
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Completed Product Waves
- Recurring Reminder — #93 / PR #96 / PR #97 + docs #98: completed
- Timeline Reminder Status — #99 / PR #100 + docs #101: completed
- Reminder Presence Filter — #102 / PR #103 + docs #105: completed
- Timeline Type Card Icons — #104 / PR #106 + docs #107: completed
- Shared Timeline Type Presentation — #108 / PR #109 + docs #110: completed
- Independent Type Filter Clear — #111 / PR #112 + docs #113: completed; documented main `654cb489...`

## 5. Independent Date-Range Clear — #114 / PR #115
Final product head:
`6cb084ae12c9dbab1e2fcd2dc812374522f1f895`

Merged main:
`0fbdb1c9dc3473112530843620480a3e7283e7ae`

Scope واقعی:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_date_filter_clear_test.dart`

Reuse-first behavior:
- State مستقل موجود `_dateStart/_dateEndExclusive` reuse شد.
- callback کوچک date-only clear به `TimelineScreen` متصل شد.
- کنترل پاک‌کردن فقط هنگام Date Range فعال دیده می‌شود.
- query فعال، type filter و reminder-presence filter حفظ می‌شوند.
- Global Clear All بدون تغییر باقی ماند.
- Domain/schema/repository/storage/scheduler/workflow/dependencies دست‌نخورده ماندند.

Pre-merge exact-head:
- CI `33114258026`: success
- Android `33114258075`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main exact SHA `0fbdb1c9...`:
- CI `33115076694`: success
- Android `33115076613`: success full chain
- Build/Candidate/Smoke-Recovery/Readiness/Release-Draft/Approval: all success

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

### Active Docs Sync — #114
Branch:
`docs/timeline-date-filter-clear-live`

Branch از main قبلی `654cb489...` ساخته شد و تا پایان Product Gate بدون Write ماند؛ سپس بدون Force به exact main `0fbdb1c9...` Fast-forward شد و با Evidence واقعی به‌روزرسانی شد.

Merge Contract:
1. fresh compare = docs-only
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact `expected_head_sha`
6. post-main Fast CI
7. Close #114 فقط بعد از proof

## 8. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/relevant gates Green همان Head
4. Fresh compare برای Scope/Dependency
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
1. Docs sync نهایی #114
2. Issue #19 — required-status enforcement gap

### Next Product Discovery
بعد از بسته‌شدن #114، Queue و کد باید Fresh Audit شوند. Issue محصولی صرفاً برای پرکردن Backlog ساخته نمی‌شود؛ Slice بعدی باید نیاز واقعی، Scope کوچک و reuse بالا داشته باشد.

### Security-separated
Production signing / real tag / release / publish فقط با Owner/Security decision صریح.

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
