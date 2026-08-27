# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current product main: `885b988d996e7daf8e79e82ebe25b2d55e14f95a`

## کجا هستیم
Foundation اصلی Timeline/Reminder پایدار است. موج #108 / PR #109 نیز ادغام شده و اکنون کارت‌ها، فیلتر نوع، ثبت سریع و ویرایش همگی از یک mapping مشترک برای عنوان فارسی و آیکن نوع Timeline استفاده می‌کنند. pre-merge و post-main Fast CI/Android برای همین SHA کامل سبز هستند.

## موج‌های تکمیل‌شده
- Recurring Reminder — parent #93: تکمیل
- Reminder Status — #99 / PR #100: تکمیل
- Reminder Presence Filter — #102 / PR #103 + docs #105: تکمیل
- Timeline Type Card Icons — #104 / PR #106 + docs #107: تکمیل

#104 پس از docs PR #107 و post-main Fast CI `33098163806` بسته شد.

## Timeline Type Selector Icons — #108 / PR #109
Final product head:
`e6195dc11eebbed7db9b83fcefc7bf52c7bd9268`

Merged main:
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

رفتار نهایی:
- یادداشت => note outline + `یادداشت`
- رویداد => event outline + `رویداد`
- تماس => call outline + `تماس`
- ایده => lightbulb outline + `ایده`
- فعالیت => check-circle outline + `فعالیت`

همین metadata مشترک در چهار محل reuse می‌شود:
- کارت Timeline
- فیلتر نوع
- Quick Capture
- Edit

Mappingهای خصوصی/تکراری قبلی حذف شدند.

Scope واقعی فقط چهار فایل Presentation/Test بود:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_item_type_presentation.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_selector_icon_test.dart`

Pre-merge exact-head روی `e6195dc1...`:
- Fast CI `33099191968`: success
- Android `33099192004`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main روی `885b988d...`:
- Fast CI `33103519511`: success
- Android `33103519546`: success full chain
- Build/Candidate: success
- emulator Smoke/Recovery: success
- Release Readiness: success
- deterministic Release Draft: success
- Approval/Rollback evidence: success

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema: v3  
Compatibility: v1/v2 reads فعال است.

هیچ Timeline/Reminder DB/Repository/Storage/Scheduler موازی وجود ندارد.

## Release Safety
وضعیت انتشار:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag/Release/Play Store publish واقعی یا production secret/keystore ساخته نشده است.

## Automation — Issue #19
#19 باز است. Ruleset `main-protection` فعال است؛ PR اجباری و deletion/non-fast-forward بسته است، اما required status checks هنوز Platform-level enforce نشده‌اند چون ابزار متصل Ruleset Write ندارد.

قانون عملی Merge:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## مستندات فعال #108
Branch: `docs/timeline-type-selector-icons-live`

این Branch قبل از Merge محصول ساخته شد اما دست‌نخورده ماند؛ پس از Merge، بدون Force به exact main `885b988d...` Fast-forward شد و فقط اکنون با Evidence واقعی به‌روزرسانی می‌شود.

Gate Docs:
1. Fresh compare = فقط چهار سند canonical
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact expected-head merge
6. post-main Fast CI
7. سپس Close #108

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## صف فعلی
- #108: فقط مستندات نهایی و proof باقی مانده است.
- #19: محدودیت Ruleset Write؛ باز می‌ماند.
- Issue محصول جدیدی از قبل در صف نیست.

پس از بسته‌شدن #108، Slice بعدی فقط با Fresh Audit کد/UX و اثبات نیاز واقعی کوچک و reuse-first انتخاب می‌شود.

## ادامه
1. چهار سند #108 را Fresh compare کن.
2. PR Docs را باز کن و exact-head Fast CI بگیر.
3. با mergeability زنده + expected-head ادغام کن.
4. post-main Fast CI را Verify و #108 را Completed ببند.
5. سپس Queue واقعی و کد را Fresh Audit کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
