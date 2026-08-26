# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current verified main: `dcdefb3155322b5d49972b196786e569bc541267`

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem
- فارسی و RTL
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type از همان Edit flow
- حذف با confirmation فارسی
- Undo حذف با جلوگیری از overwrite آیتم جدیدتر
- Fast CI + Android APK Build/Verify/Upload واقعی

Foundation موازی Model/Repository/Storage/AppShell وجود ندارد.

## PR #61 / Issue #57 — تکمیل شد
Safe Delete روی main ادغام شد.
- exact head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`
- CI `33020857429`: success
- Android `33020857455`: success
- mergeability clean
- expected-head lock
- merged main: `509817c344d014579e28f62d64ff8465b722f3b9`
- post-main CI `33023724452`: success
- post-main Android `33023724492`: success

## PR #63 / Issue #59 — تکمیل شد
Undo حذف روی main ادغام شد.
- exact head: `373a1b8cf18016d27e01297abc70ff6034ef6d2c`
- CI `33023943769`: success
- Android `33023943767`: success
- mergeability clean
- expected-head lock
- current main: `dcdefb3155322b5d49972b196786e569bc541267`
- post-main CI `33024326747`: success
- post-main Android `33024326787`: success با build/verify/upload APK

Undo همان TimelineItem حذف‌شده را با metadata اصلی برمی‌گرداند، اما اگر ID توسط داده جدیدتر دوباره استفاده شده باشد overwrite نمی‌کند.

Issue #59 بسته شده است.

## Automation
### Issue #62 — بسته شد
مشکل intermittent ثبت workflow/merge-ref بدون دورزدن Gate بررسی شد. PR #63 روی synchronize عادی هر دو Workflow را روی exact head دریافت کرد؛ incident بازیابی‌شده و بسته شده است.

### Issue #19 — باز است
Ruleset فعلی PR را الزام می‌کند، ولی required status check ندارد و Connector Ruleset write ارائه نمی‌دهد.

قانون Merge عملیاتی:
`exact-head CI Green + Android Green + live mergeability + expected-head lock + post-main proof`

## Docs — PR #50
README قدیمی نیز در Lane Docs اصلاح شده است.
PR #50 باید به‌صورت ساختاری روی main فعلی `dcdefb3...` Sync شود، exact-head validate شود و سپس امن Merge شود.

## Product بعدی — Issue #64
`feat(export): copy Timeline export to clipboard`

سند جامع Wave 6 را Reminder / Backup / Export تعریف می‌کند. Audit نشان داد هیچ implementation موجودی برای این سه وجود ندارد.

Export به Clipboard انتخاب شده چون:
- user-facing و قابل‌استفاده است
- Repository موجود را reuse می‌کند
- Flutter Clipboard داخلی کافی است
- dependency/permission/schema/storage جدید نمی‌خواهد
- Backup/Restore و Reminder را داخل یک PR قاطی نمی‌کند

Branch #64 فقط بعد از نهایی‌شدن Docs ساخته شود.

## اصل سرعت
Laneهای Product/Core/Automation/Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. PR #50 را روی main فعلی structurally sync کن.
2. exact-head CI آن را Verify و امن Merge کن.
3. Issue #64 را از main جدید شروع کن.
4. #19 را تا اعمال واقعی required status check باز نگه دار.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
