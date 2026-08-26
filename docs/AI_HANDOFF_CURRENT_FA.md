# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `740c290f8c2c3104dbca6518ee8c3de54b9abc51`

## وضعیت واقعی محصول
یک Timeline مشترک داریم:
`Quick Capture → Persist → Timeline → View/Edit`

قابلیت‌های موجود روی main:
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- Event/Activity occurredAt capture
- نمایش زمان ثبت/رخداد روی کارت‌ها
- ویرایش/پاک‌کردن occurredAt برای Event/Activity
- JSON persistence واقعی و crash-recoverable
- Fast CI + Android APK Build واقعی

## PR #54 / Issue #53 — تکمیل شد
Merged current main:
`740c290f8c2c3104dbca6518ee8c3de54b9abc51`

Exact head:
`183cddb533b58284c534ad2dacee74b88d6dbaff`

Pre-merge:
- CI `33016928847`: success
- Android `33016928837`: success

Post-main snapshot:
- CI `33017214825`: success
- Android `33017214826`: in progress

## Product فعال — PR #56 / Issue #55
`feat(edit): allow Timeline item type changes`

Branch: `feature/edit-item-type`  
Current exact head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`

Scope:
- همان `EditTimelineItem` توسعه یافته؛ Use Case دوم نداریم
- type از داخل Edit قابل اصلاح است
- تغییر Event/Activity به Note/Call/Idea occurredAt پنهان را پاک می‌کند
- تغییر به Event/Activity کنترل زمان موجود را reuse می‌کند
- بدون Model/Repository/Storage/Schema/dependency جدید

در Snapshot فعلی برای Head جدید هنوز Check Run ثبت نشده است. تا CI و Android واقعی روی همین Head ایجاد و Green نشوند Merge ممنوع است.

## Docs — PR #50
PR #43 stale بسته شده است.
PR #50 replacement است و Branch آن روی main بعد از #54 Sync شده است.

#50 تا زمانی که Product فعال حرکت می‌کند Draft می‌ماند؛ بعد از settle شدن محصول Final Sync + Fresh Audit + exact-head validation می‌گیرد.

## Automation — Issue #19
Ruleset زنده هنوز Required Status Check ندارد و Connector فقط Read ارائه می‌دهد.

تا رفع واقعی:
`exact-head CI Green + Android Green + live mergeability + expected-head lock + post-main proof`

## اصل سرعت
Laneها موازی‌اند:
- Product/UX
- Core/Data
- CI/Automation/Docs

یک Build در حال اجرا نباید Lane مستقل را متوقف کند. سرعت از reuse، PRهای کوچک، automation و مستندسازی هم‌زمان می‌آید؛ نه از حذف تست.

## ادامه
1. Android post-main #54 را نهایی Verify کن.
2. Trigger/Gate واقعی #56 را تأیید کن.
3. #56 فقط با exact-head Green merge شود.
4. main بعدی را Verify کن.
5. #50 را Final Sync و امن Merge کن.
6. Gap بعدی را Fresh Audit کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
