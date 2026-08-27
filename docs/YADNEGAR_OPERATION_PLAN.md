# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 4.5 — Shared Timeline Type Presentation Integrated

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
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Main شامل:
- Timeline foundation واحد
- schema v3 برای Reminder recurrence
- backward-compatible v1/v2 reads
- daily/weekly Android reminder scheduling با timezone محلی دستگاه
- Persian recurrence UX
- نمایش مستقیم وضعیت Reminder روی کارت Timeline
- فیلتر Reminder presence: همه / دارای یادآور / بدون یادآور
- Search/Type/Date composition + clear/export behavior
- آیکن متمایز برای پنج نوع canonical Timeline
- mapping مشترک label/icon برای کارت، فیلتر نوع، Quick Capture و Edit
- Release Governance غیرمخرب کامل
است.

## 3. Release Baseline — Stable
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت Release:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag، GitHub Release، Play Store publish یا production keystore/secret ساخته نشده است.

## 4. Completed Product Waves
### Recurring Reminder — #93
- PR #96 / Issue #94: recurrence contract + schema v3 + v1/v2 compatibility
- PR #97 / Issue #95: daily/weekly device-local scheduling + Persian UX
- #98 docs sync
- parent #93 completed

### Timeline Reminder Status — #99 / PR #100
Product + final docs verified; Issue #99 completed.

### Reminder Presence Filter — #102 / PR #103
Product merged to `3428c1798a43fd39fadd5f47673d1bd0366583ca`.
Docs PR #105 merged to `4d6dc18021b5d327b3a55972288df2b2a4d1c197`.
Docs post-main Fast CI `33095853727`: success.
Issue #102 completed.

### Timeline Type Card Icons — #104 / PR #106 + Docs #107
Product merged to `9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`.
Docs PR #107 merged to `09d3bf13a8f4a7525b7619247095f4974774de67`.
Docs post-main Fast CI `33098163806`: success.
Issue #104 completed.

## 5. Shared Timeline Type Presentation — #108 / PR #109
Final product head:
`e6195dc11eebbed7db9b83fcefc7bf52c7bd9268`

Merged main:
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Scope واقعی:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_item_type_presentation.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_selector_icon_test.dart`

Reuse:
- یک mapping presentation برای Persian label + Material icon
- استفاده در Timeline card
- استفاده در type filter
- استفاده در Quick Capture selector
- استفاده در Edit selector
- حذف mappingهای خصوصی/تکراری قبلی

Mapping:
- note => `Icons.note_outlined` + `یادداشت`
- event => `Icons.event_outlined` + `رویداد`
- call => `Icons.call_outlined` + `تماس`
- idea => `Icons.lightbulb_outline` + `ایده`
- activity => `Icons.check_circle_outline` + `فعالیت`

Pre-merge exact-head:
- CI `33099191968`: success
- Android `33099192004`: success full chain
- live mergeability=true
- expected-head merge: success

Post-main exact SHA `885b988d...`:
- CI `33103519511`: success
- Android `33103519546`: success full chain
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

### Active Docs Sync — #108
Branch:
`docs/timeline-type-selector-icons-live`

Branch قبل از Product Merge ساخته شد ولی هیچ Write نداشت؛ پس از Merge بدون Force به exact main `885b988d...` Fast-forward شد و سپس چهار سند canonical با Evidence واقعی به‌روزرسانی شدند.

Merge Contract:
1. fresh compare = docs-only
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact `expected_head_sha`
6. post-main Fast CI
7. Close #108 فقط بعد از proof

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
1. Docs sync نهایی #108
2. Issue #19 — required-status enforcement gap

### Next Product Discovery
Open product backlog دیگری وجود ندارد. پس از تکمیل Docs #108، Queue و کد باید Fresh Audit شوند. Slice بعدی فقط در صورت Scope کوچک، مستقل و reuse-first باز می‌شود؛ Foundation جدید صرفاً برای پر کردن backlog ممنوع است.

### Security-separated
Production signing / real tag / release / publish فقط با Owner/Security decision صریح.

## 11. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
