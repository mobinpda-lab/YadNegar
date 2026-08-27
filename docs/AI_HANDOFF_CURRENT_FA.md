# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup Share`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem
- فارسی و RTL
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن
- Undo با no-overwrite conflict protection
- کپی خروجی خوانا از آیتم‌های visible Timeline
- ساخت و Share یک snapshot معتبر و قابل‌حمل از Timeline
- Fast CI + Android APK Build/Verify/Upload واقعی

Foundation موازی Model/Repository/Storage/AppShell وجود ندارد.

## PR #68 / Issue #67 — تکمیل شد
Backup Share وارد main شد.

Exact pre-merge head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
- CI `33042505480`: success
- Android `33042505505`: success
- merge main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

طراحی Backup:
- از همان `JsonFileTimelineRepository` استفاده می‌کند
- parser/encoder production را reuse می‌کند
- serializer/schema/storage موازی نساخته
- staging recovery قبل از snapshot انجام می‌شود
- Timeline خالی هم snapshot معتبر می‌سازد بدون ساخت primary user storage
- snapshot نهایی دوباره با parser اصلی validate می‌شود
- Share با `share_plus` سازگار و pin‌شده انجام می‌شود
- Restore/Import عمداً خارج Scope این PR بوده است

Post-main exact-ref روی `edf0c72...`:
- CI `33042973852`: success
- Android Build `33042973848`: در زمان این audit هنوز in_progress است

تا وقتی Run بالا با success تمام نشده، post-main Android را Green اعلام نکن.

## محصول بعدی — Issue #70
`feat(backup): restore a validated Timeline snapshot safely`

Scope تأییدشده در Issue زنده:
- validation کامل با parser/schema اصلی قبل از هر تغییر primary
- حفظ داده قبلی و rollback واقعی اگر replace نهایی fail شود
- reload Timeline از همان Repository production پس از restore موفق
- پیام فارسی برای success / invalid / unsupported schema / failure
- تست فایل واقعی برای restore معتبر، JSON خراب، schema نامعتبر، rollback و unchanged primary
- widget/integration test برای انتخاب، تأیید و reload

قوانین ایمنی:
- Branch محصول فقط بعد از موفق‌شدن post-main Android دقیق روی `edf0c72...` شروع شود
- copy خام فایل روی primary ممنوع
- parser/serializer دوم ممنوع
- Repository/Schema/AppShell جدید ممنوع
- Reminder/notification خارج Scope بماند

## Documentation Lane
Branch: `docs/current-state-post-backup`

این Lane فقط دو سند canonical را با واقعیت بعد از PR #68 Sync می‌کند. مستقل از Android Build در حال اجراست و نباید هیچ Workflow یا Lane سالمی را cancel/replace کند.

## Automation
Issue #19 همچنان باز است. Ruleset فعلی PR را الزام می‌کند ولی required status check در سطح Platform هنوز از Connector قابل‌نوشتن نیست.

قانون Merge عملیاتی:
`exact current head + exact-head CI Green + exact-head Android Green برای تغییر محصول + live mergeability + expected_head_sha lock + post-main proof`

## اصل سرعت
Product / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate. Workflow مفید در حال اجرا فقط برای تمیزشدن audit لغو نمی‌شود.

## ادامه
1. Android Build `33042973848` را بدون دخالت تا پایان دنبال کن و نتیجه exact-main را Verify کن.
2. CI دقیق head شاخه docs را Verify کن و فقط با mergeability زنده و head ثابت Merge کن.
3. پس از کامل‌شدن post-main proof، Issue #70 را از main تازه شروع کن.
4. Restore را در همان persistence/application موجود نگه دار و file picker را فقط در platform edge وارد کن.
5. #19 را باز نگه دار تا Ruleset write واقعی ممکن و Verify شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
