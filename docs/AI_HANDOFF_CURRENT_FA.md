# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

## کجا هستیم
موج Reminder تکرارشونده از نظر Product کامل و روی main ادغام شده است. هر دو گیت اصلی post-main یعنی Fast CI و Android نیز Green هستند. کار فعال فعلی فقط Sync نهایی مستندات در PR #98 و بعد بستن Parent Issue #93 است.

## انجام‌شده — PR #96 / Issue #94
`recurrence contract + schema v3 migration`

Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

انجام‌شده:
- `none / daily / weekly`
- schema v3
- backward-compatible v1/v2 reads
- no read-time rewrite
- safe-write upgrade با همان tmp/bak recovery
- reuse کامل Timeline model/repository/storage موجود

Pre-merge:
- CI `33078963061`: success
- Android `33078963046`: success

Post-main:
- CI `33079988610`: success
- Android `33079988616`: success

## انجام‌شده — PR #97 / Issue #95
`Android scheduling + Persian recurrence UX`

Final head:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

رفتار نهایی:
- بدون تکرار: one-shot فعلی حفظ شده
- روزانه: ساعت محلی دستگاه
- هفتگی: روز هفته + ساعت محلی دستگاه
- reminder تکرارشونده قدیمی به occurrence بعدی آینده منتقل می‌شود
- timezone دستگاه قبل از startup/Restore reconcile تعیین می‌شود
- اگر timezone قابل تشخیص نباشد recurrence fail-closed است
- خطای notification باعث rollback داده ذخیره‌شده نمی‌شود
- انتخاب فارسی: `بدون تکرار / روزانه / هفتگی`
- recurrence فقط وقتی reminder وجود دارد دیده می‌شود
- persist-first حفظ شده
- پاک‌کردن reminder، recurrence را هم none می‌کند
- Delete/Undo همچنان cancel/reschedule امن دارد
- exact-alarm permission اضافه نشده

Pre-merge:
- CI `33080762656`: success
- Android `33080762586`: success

Merged main:
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Post-main:
- CI `33081668902`: success
- Android `33081668913`: success

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema فعلی: v3  
Compatibility: v1/v2 reads پشتیبانی می‌شوند.

هیچ Timeline/Reminder DB/Repository/Storage/Scheduler موازی وجود ندارد.

## Release Safety
وضعیت انتشار هنوز:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag/Release/Play Store publish واقعی یا production secret/keystore ساخته نشده است.

## Automation — Issue #19
#19 باز است. PR روی main اجباری است ولی required status checks هنوز Platform-level enforce نشده‌اند و ابزار متصل Ruleset Write ندارد.

قانون عملی Merge:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## فعال — PR #98
PR #98 چهار سند زنده/مرجع را با نتیجه واقعی Reminder sync می‌کند.

Gate نهایی:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact expected-head merge
5. post-main Fast CI
6. سپس Parent #93 بسته شود

## قدم محصول بعدی — Issue #99
`surface reminder status on Timeline cards`

Scope برنامه‌ریزی‌شده فقط Presentation است:
- reminder ندارد => چیزی نشان داده نشود
- one-shot => خلاصه تاریخ/ساعت
- daily => `روزانه` + ساعت
- weekly => `هفتگی` + روز/ساعت
- widget test متمرکز

بدون schema/repository/storage/scheduler/navigation جدید.

شروع Implementation فقط بعد از بسته‌شدن کامل #93.

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## ادامه
1. PR #98 را با exact-head Fast CI نهایی و Merge کن.
2. post-main Fast CI آن را Verify کن.
3. Parent #93 را Close کن.
4. Issue #99 را از main تازه به PR کوچک UI تبدیل کن.
5. #19 تا Ruleset Write واقعی باز بماند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
