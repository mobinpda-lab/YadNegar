# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current verified main: `40415af1f064a7ef7298ce9993ee949c52664bff`

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem
- فارسی و RTL
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن
- Undo با no-overwrite conflict protection
- کپی خروجی خوانا از آیتم‌های فعلی Timeline
- Fast CI + Android APK Build/Verify/Upload واقعی

Foundation موازی Model/Repository/Storage/AppShell وجود ندارد.

## PR #65 / Issue #64 — تکمیل شد
Export visible Timeline به Clipboard وارد main شد.

Exact pre-merge head: `114fca4cdfd2269d5d4ff906ce96afe0590a7162`
- CI `33026398124`: success
- Android `33026398078`: success
- build/verify/upload APK: success
- live mergeable=true
- merge با expected-head lock

Merged main: `40415af1f064a7ef7298ce9993ee949c52664bff`

Post-main:
- CI `33026680361`: success
- Android `33026680302`: success با build/verify/upload APK

طراحی Export:
- Formatter خالص
- همان آیتم‌های visible کپی می‌شوند
- Search/Type/Date طبیعی حفظ می‌شوند
- query دوم و dependency/schema/storage جدید وجود ندارد

Issue #64 بسته شده است.

## Docs فعال — PR #66
Branch: `docs/current-state-wave6-export`

از نظر تاریخچه روی main Export‌شده Sync شده و فقط سه فایل مستندات را تغییر می‌دهد. پس از این Final Refresh باید exact-head CI جدید بگیرد؛ سپس Ready + Fresh mergeability + expected-head merge lock.

## Automation
Issue #62 بسته و recovered است. Workflowها روی #65 طبیعی اجرا شدند و workaround تکراری ساخته نشد.

Issue #19 باز است: Ruleset فعلی PR را الزام می‌کند ولی required status check Platform-level هنوز از Connector قابل‌نوشتن نیست.

## Product بعدی — Issue #67
`feat(backup): share a validated Timeline backup snapshot`

Audit اولیه:
- فایل داده واقعی در Application Support است
- Storage فعلی schema-versioned و recoverable است
- Backup باید همان storage معتبر را snapshot کند، نه JSON serializer دوم بسازد
- Restore/Import در Slice جداگانه است
- dependency اشتراک فایل فقط بعد از Flutter/Android compatibility audit انتخاب می‌شود
- Reminder فعلاً ریسک permission/scheduling بیشتری دارد

Branch Backup فقط بعد از Merge نهایی #66 شروع شود.

## اصل سرعت
Product / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. exact-head CI جدید #66 را Verify کن.
2. Green → Ready → Fresh head/mergeability → expected-head Merge.
3. main docs-only را با Fast CI Verify کن.
4. سپس #67 را با compatibility audit Android/Share شروع کن.
5. #19 را باز نگه دار تا Ruleset write واقعی ممکن شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
