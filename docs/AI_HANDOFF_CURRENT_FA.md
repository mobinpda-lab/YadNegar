# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `71d1d993e362be898be955963653eff832a7da0a`

## وضعیت واقعی محصول
یک Timeline مشترک داریم:
`Quick Capture → Persist → Timeline → View/Edit`

روی main:
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- Event/Activity occurredAt capture
- نمایش زمان ثبت/رخداد روی کارت‌ها
- ویرایش/پاک‌کردن occurredAt
- اصلاح type از همان Edit flow
- JSON persistence واقعی و crash-recoverable
- Fast CI + Android APK Build/Verify/Upload واقعی

## PR #56 / Issue #55 — تکمیل شد
Merged main:
`71d1d993e362be898be955963653eff832a7da0a`

Exact PR head:
`ff59496fd12c098a5ebce7cd60dc301bb0fb8724`

Pre-merge:
- CI `33017606387`: success
- Android `33017606312`: success
- live mergeability: true

Post-main:
- CI `33017911498`: success
- Android `33017911496`: success

نتیجه:
- type از همان `EditTimelineItem` قابل اصلاح است
- تغییر Event/Activity به نوع بدون occurredAt، مقدار پنهان را پاک می‌کند
- مسیر Edit موازی ساخته نشده است

## Product فعال — PR #58 / Issue #57
`feat(timeline): delete items with confirmation`

Branch: `feature/delete-timeline-item`  
Current exact head: `58bce967c3d28fcd70d117ab114ee4d24625166f`

پیاده‌سازی واقعی:
- `deleteById` روی همان `TimelineRepository`
- JSON delete از همان `_readAll → _writeAll` crash-recoverable استفاده می‌کند
- `DeleteTimelineItem` application use case کوچک
- wiring واقعی در production
- حذف داخل همان Edit dialog با تأیید صریح فارسی
- پس از حذف Timeline با state/filter موجود reload می‌شود
- تست Application + Widget + temp-file persistence

Validation history:
- Head قبلی Android Green شد
- Fast CI فقط به‌علت دو Fake Repository قدیمی Fail شد
- CI دقیقاً `timeline_edit_flow_test.dart` و `timeline_search_flow_test.dart` را مشخص کرد
- هر دو Fake روی Head فعلی اصلاح شده‌اند

تا Fast CI و Android واقعی روی **همین Head فعلی** Green نشوند Merge ممنوع است.

## Docs — PR #50
PR #43 stale بسته شده است.
PR #50 replacement و فعلاً Draft است تا Product فعال جلو برود.

قبل از Merge Docs:
`Final main sync → Fresh Audit → exact-head validation → safe merge`

## Automation — Issue #19
Ruleset زنده Required Status Check ندارد و Connector Ruleset write واقعی ارائه نمی‌دهد.

تا رفع واقعی:
`exact-head CI Green + Android Green + live mergeability + expected-head lock + post-main proof`

## اصل سرعت
سه Lane موازی:
- Product/UX
- Core/Data
- CI/Automation/Docs

Fail یا Build در یک Lane، Lane مستقل دیگر را متوقف نمی‌کند. سرعت از reuse، PR کوچک، تست واقعی، automation و مستندسازی هم‌زمان می‌آید.

## ادامه
1. exact-head Gateهای #58 را Fresh Verify کن.
2. خطای واقعی را فقط روی همان سطح اصلاح کن؛ historical Green معتبر نیست.
3. اگر هر دو Green شدند، Head/Mergeability را دوباره بخوان و با expected-head lock Merge کن.
4. main را بعد از Merge با CI + Android Verify کن.
5. #50 را روی main نهایی Sync و سپس امن Merge کن.
6. Gap بعدی را فقط با Fresh Audit انتخاب کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
