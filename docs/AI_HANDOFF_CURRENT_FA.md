# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `dc58de0e9d4b6aaa90a800a894404e9db86cf4f5`

## کجا هستیم
Release Governance غیرمخرب کامل و post-main Green است. توسعه محصول بعدی روی **Reminder تکرارشونده** در حال اجراست و هیچ Foundation موازی ساخته نشده است.

## انجام‌شده — PR #96 / Issue #94
`recurrence contract + schema v3 migration`

Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

روی همان Timeline foundation موجود اضافه شد:
- `none / daily / weekly`
- schema v3
- خواندن backward-compatible v1/v2
- حفظ reminderAt قدیمی
- عدم rewrite هنگام read
- upgrade فقط در safe write موجود با tmp/bak
- تست‌های migration و application

Pre-merge:
- CI `33078963061`: success
- Android `33078963046`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

با `expected_head_sha` Merge شد و main به `dc58de0e...` رسید.

Post-main:
- CI `33079988610`: success
- Android `33079988616`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

## فعال — PR #97 / Issue #95
`Android scheduling + Persian recurrence UX`

Branch:
`product/recurring-reminder-scheduler-ux`

Head دقیق این revision:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

Scope واقعی بعد از Fresh compare:
- همان Android reminder scheduler
- همان Quick Capture/Edit dialogs
- timezone initialization اپ
- dependency رسمی device timezone
- همان reminder flow tests

رفتار پیاده‌شده:
- بدون تکرار: رفتار فعلی حفظ می‌شود
- روزانه: ساعت محلی دستگاه
- هفتگی: روز هفته + ساعت محلی دستگاه
- reminder تکرارشونده قدیمی به occurrence بعدی آینده منتقل می‌شود
- timezone دستگاه قبل از startup/Restore reconcile تعیین می‌شود
- اگر timezone قابل تشخیص نباشد recurrence fail-closed است و داده کاربر حذف/rollback نمی‌شود
- انتخاب فارسی: `بدون تکرار / روزانه / هفتگی`
- recurrence فقط وقتی reminder وجود دارد دیده می‌شود
- persist-first حفظ شده است
- پاک‌کردن reminder، recurrence را هم none می‌کند
- Delete/Undo همچنان cancel/reschedule امن دارد
- exact-alarm permission اضافه نشده است

Validation:
- CI `33080762656`: success
- Android `33080762586`: هنگام این revision فعال

تا Fresh-read پایان Android، Green نهایی #97 گزارش نشود.

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema فعلی روی main: v3  
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

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## ادامه
1. Android #97 روی Head دقیق کامل Green شود.
2. Fresh head/mergeability #97 گرفته شود.
3. Merge فقط با exact `expected_head_sha`.
4. post-main #97 با Fast CI + Android/relevant gates Verify شود.
5. docs recurring-reminder با نتیجه واقعی نهایی Refresh و Merge شود.
6. Parent #93 فقط بعد از Product + post-main + docs بسته شود.
7. #19 تا Ruleset Write واقعی باز بماند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
