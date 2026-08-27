# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.6 — Independent Timeline Type Filter Clear Integrated

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
`b8bd35976fe3a51834c56799525451eec145a2fd`

Main شامل:
- Timeline foundation واحد
- schema v3 و backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- Reminder status روی کارت
- Reminder presence filter: همه / دارای یادآور / بدون یادآور
- Search/Type/Date composition + clear/export behavior
- آیکن متمایز پنج نوع canonical Timeline
- mapping مشترک label/icon در کارت، فیلتر نوع، Quick Capture و Edit
- گزینه واقعی `همه انواع` برای پاک‌کردن مستقل فیلتر نوع
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

Documented main after #110:
`2c79d2e4f3d64571032560186229117df33dcafa`

## 5. Independent Timeline Type Filter Clear — #111 / PR #112
Final product head:
`ee467aab71e682615d045acc5e363061e24a6ac5`

Merged main:
`b8bd35976fe3a51834c56799525451eec145a2fd`

Scope واقعی:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_filter_all_option_test.dart`

Reuse-first behavior:
- `همه انواع` از hint به گزینه واقعی nullable تبدیل شد.
- callback موجود `TimelineItemType?` با `null` reuse شد.
- State یا callback دوم ساخته نشد.
- حذف type constraint، query فعال را حفظ می‌کند.
- date/reminder state با این action reset نمی‌شود.
- Global Clear All بدون تغییر باقی مانده است.

Pre-merge exact-head:
- CI `33105499667`: success
- Android `33105499651`: success full chain
- live mergeability=true
- expected-head merge: success

Post-main exact SHA `b8bd3597...`:
- CI `33109216102`: success
- Android `33109216100`: success full chain
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

### Active Docs Sync — #111
Branch:
`docs/timeline-type-filter-all-option-live`

Branch از documented main قبلی ساخته شد و تا پایان Product Gate بدون Write ماند؛ سپس بدون Force به exact main `b8bd3597...` Fast-forward شد و با Evidence واقعی به‌روزرسانی شد.

Merge Contract:
1. fresh compare = docs-only
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact `expected_head_sha`
6. post-main Fast CI
7. Close #111 فقط بعد از proof

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
1. Docs sync نهایی #111
2. Issue #19 — required-status enforcement gap

### Next Product Discovery
Candidate واقعی Audit‌شده ولی هنوز باز نشده: پاک‌کردن مستقل Date Range. `_dateStart/_dateEndExclusive` State مستقل هستند؛ UI فعلی انتخاب/تعویض بازه را دارد ولی حذف بازه از Global Clear All عبور می‌کند. پس از پایان Docs #111 باید Fresh Audit تکرار شود و فقط اگر Scope کوچک و presentation/reuse-first ماند Issue بعدی باز شود.

### Security-separated
Production signing / real tag / release / publish فقط با Owner/Security decision صریح.

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
