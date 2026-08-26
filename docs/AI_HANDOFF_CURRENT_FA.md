# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge یا اعلام SHA/CI/Mergeability وضعیت زنده را دوباره Audit کن.

Canonical governance: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
Active plan: `docs/YADNEGAR_OPERATION_PLAN.md`  
Current state: `docs/AI_CONTINUATION_STATE.md`

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `6e379f4de11edfd323f79861b04b16992ee6f614`

## وضعیت محصول
Vertical Slice واقعی:
`Quick Capture → Persist → Timeline → View/Edit`

Main اکنون علاوه بر آن دارد:
- نوع‌های Note/Event/Call/Idea/Activity روی یک مدل مشترک
- Search + Type + Date Range
- ثبت اختیاری occurredAt برای Event/Activity
- نمایش زمان ثبت/رخداد روی کارت Timeline با `timelineAt`
- JSON persistence واقعی و crash-recoverable
- Vazirmatn + optional private IRANSansX
- Fast CI + Android APK Build واقعی و deduplicated

## #49 — occurredAt Capture تکمیل شد
Merged: `16eb0e041cb6431c83bb9abc844d0291a5bc1cb4`

Pre-merge:
- CI `33015406333`: success
- Android `33015406042`: success

Post-merge:
- CI `33015801059`: success
- Android `33015801063`: success

Issue #48 بسته است.

## #52 — Date/Time Context تکمیل شد
Merged/current main: `6e379f4de11edfd323f79861b04b16992ee6f614`

Exact head: `3d082c19200f2b62dd70d382ea885277d17e9337`

Pre-merge:
- CI `33016029795`: success
- Android `33016029822`: success

Post-merge:
- CI `33016376693`: success
- Android `33016376667`: success

Issue #51 بسته است.

## محصول فعال — PR #54 / Issue #53
`feat(edit): update Event and Activity occurredAt`

Branch: `feature/edit-occurred-at`  
Exact head snapshot: `183cddb533b58284c534ad2dacee74b88d6dbaff`  
Base: `6e379f4de11edfd323f79861b04b16992ee6f614`

Reuse شده:
- `TimelineItem.occurredAt`
- `timelineAt`
- همان `EditTimelineItem`
- همان picker pattern موجود

Scope:
- Event/Activity: تغییر یا پاک کردن occurredAt
- Note/Call/Idea: همان ویرایش متن ساده
- `updateText` برای سازگاری حفظ شده
- Application + Widget tests
- بدون Model/Repository/Storage/Schema/dependency جدید

Merge فقط بعد از exact-head CI + Android Green، read نهایی Head/Mergeability و expected-head lock.

## Docs
PR قدیمی #43 بدون Merge بسته شد.
PR #50 جایگزین آن است و Branch آن اکنون روی main #52 Sync شده است.

#50 عمداً تا فعال بودن #54 Draft می‌ماند؛ بعد از Merge محصول یک Final Sync، Fresh Audit، exact-head validation و Merge امن می‌گیرد.

## Ruleset — #19
Required Status Check هنوز واقعاً در Ruleset تنظیم نشده است.
تا وقتی Write واقعی Ruleset قابل انجام و Verify نشده:
`exact-head Green CI/Android + live mergeability + expected-head lock` اجباری است.

## مدل ادامه سریع
Lane A — Core/Data: پایدار؛ Foundation تکراری نساز.  
Lane B — Product: #54 فعال.  
Lane C — Automation/Docs: #50 موازی فعال + #19 gap.  

یک Lane در حال Build نباید Laneهای مستقل را متوقف کند.

## ادامه کار
1. Gateهای exact-head #54 را کامل کن.
2. اگر Green بود، Head/Mergeability را دوباره بخوان و با lock Merge کن.
3. main جدید را Fast + Android Verify کن.
4. #50 را Final Sync/Refresh/Validate/Merge کن.
5. Gap بعدی را با Fresh Audit انتخاب و بلافاصله Slice کوچک بعدی را شروع کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

گزارش کوتاه، غیر فنی و نتیجه‌محور باشد.
