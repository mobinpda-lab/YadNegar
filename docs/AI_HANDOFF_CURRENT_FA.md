# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

## کجا هستیم
موج Reminder تکرارشونده کامل شده و نمایش وضعیت Reminder روی کارت‌های Timeline نیز با PR #100 روی `main` ادغام شده است. Fast CI و کل زنجیره Android قبل و بعد از Merge سبز هستند.

## Reminder Recurrence — Completed
Parent #93 بسته شده است.

### PR #96 / Issue #94
- `none / daily / weekly`
- schema v3
- backward-compatible v1/v2 reads
- safe-write upgrade با همان recovery موجود
- بدون Model/Repository/Storage موازی

### PR #97 / Issue #95
- one-shot فعلی حفظ شده
- daily بر اساس ساعت محلی دستگاه
- weekly بر اساس روز هفته + ساعت محلی
- timezone قبل از startup/Restore reconciliation
- timezone failure => recurrence fail-closed
- خطای notification داده ذخیره‌شده را rollback نمی‌کند
- UI فارسی: `بدون تکرار / روزانه / هفتگی`
- no exact-alarm permission

## Reminder Status on Timeline — Issue #99 / PR #100
Final product head:
`32fd20609daa8d6fea74c325fecb14e096c0106d`

Merged main:
`8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

رفتار نهایی کارت Timeline:
- بدون Reminder => ردیف Reminder نمایش داده نمی‌شود
- one-shot => تاریخ/ساعت Reminder
- daily => `روزانه` + ساعت
- weekly => `هفتگی` + نام روز فارسی + ساعت
- نوع آیتم و زمان Timeline قبلی حفظ شده‌اند

Scope واقعی فقط دو فایل بود:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_status_test.dart`

Pre-merge exact-head:
- Fast CI `33086840280`: success
- Android `33086840284`: success

Post-main exact SHA:
- Fast CI `33087745543`: success
- Android `33087745462`: success
- Build/Candidate: success
- emulator Smoke/Recovery: success
- Release Readiness: success
- Release Draft: success
- Approval/Rollback evidence: success

Issue #99 فقط بعد از ادغام و Verify همین Sync مستندات بسته می‌شود.

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
#19 باز است. PR روی main اجباری است ولی required status checks هنوز Platform-level enforce نشده‌اند و ابزار متصل Ruleset Write ندارد.

قانون عملی Merge:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## مستندات فعال
Branch: `docs/timeline-reminder-status-live`

هدف: ثبت نتیجه واقعی #99/#100 در چهار سند live/canonical.

Gate Docs:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact expected-head merge
5. post-main Fast CI
6. سپس Close #99

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## ادامه
1. Docs sync را با exact-head Gate Merge کن.
2. post-main Fast CI مستندات را Verify کن.
3. #99 را Completed ببند.
4. معماری Search/Filter فعلی را Fresh Audit کن و اسلایس کوچک بعدی را فقط با reuse موجود باز کن.
5. #19 تا Ruleset Write واقعی باز بماند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
