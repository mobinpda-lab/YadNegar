# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current verified main: `71d1d993e362be898be955963653eff832a7da0a`

## وضعیت محصول روی main
یک Timeline مشترک داریم:
`Quick Capture → Persist → Timeline → View/Edit`

قابلیت‌ها:
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- Event/Activity occurredAt capture
- نمایش زمان ثبت/رخداد روی کارت‌ها
- ویرایش/پاک‌کردن occurredAt
- اصلاح type از همان Edit flow
- JSON persistence واقعی و crash-recoverable
- Fast CI + Android APK Build/Verify/Upload واقعی

## PR #56 / Issue #55 — تکمیل شد
Merged main: `71d1d993e362be898be955963653eff832a7da0a`

Pre-merge:
- CI `33017606387`: success
- Android `33017606312`: success

Post-main:
- CI `33017911498`: success
- Android `33017911496`: success

## Product فعال — PR #61 / Issue #57
`feat(timeline): delete items with confirmation`

Branch: `feature/delete-timeline-item-final`  
Current exact head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`

پیاده‌سازی واقعی:
- `deleteById` روی همان `TimelineRepository`
- delete JSON از همان مسیر crash-recoverable استفاده می‌کند
- `DeleteTimelineItem` use case کوچک
- wiring واقعی در production
- حذف داخل همان Edit dialog با confirmation فارسی
- reload با حفظ Search/Type/Date state
- تست Application + Widget + real temp-file persistence
- حذف ID ناموجود write staging ایجاد نمی‌کند

## سابقه Validation
- PR #58: CI دو Fake Repository ناقص را پیدا کرد؛ اصلاح شدند.
- Head میانی #58 Fast CI + Android Green شد، ولی بعد تست نهایی حفظ فیلترها Head را تغییر داد؛ Green قدیمی دیگر معتبر نیست.
- PR #60 برای validation تازه ساخته شد اما GitHub raw PR API در `mergeable_state: unknown` ماند و Run جدید ثبت نشد.
- PR #61 همان final tree را با history تمیز مستقیم روی main حمل می‌کند. آخرین Head با یک Contents API commit عادی هم synchronize شده است.

Merge #61 تا exact-head Fast CI + Android Green و live mergeability true ممنوع است.

## Automation — Issue #62
مشکل delayed PR merge-ref/workflow registration جداگانه ثبت شده است.
Workflowها روی main صحیح‌اند و Actions globally فعال است؛ PR #50 در همین بازه CI موفق گرفته است.

Connector فعلی workflow dispatch مستقیم ندارد. Gate دور زده نمی‌شود.

## Next Product — Issue #59
Undo حذف آماده صف است و باید از `upsert(...)` موجود استفاده کند؛ soft-delete/Storage/Schema جدید ممنوع.
Branch محصول #59 فقط بعد از settle شدن #61 ساخته شود.

## Docs — PR #50
PR #50 replacement و Draft است. محتوا هم‌زمان refresh می‌شود؛ قبل از Merge باید روی final main واقعاً Sync، Fresh Audit و exact-head validate شود.

## Ruleset — Issue #19
Required Status Check هنوز در Ruleset وجود ندارد و Connector Ruleset write ندارد.

تا رفع واقعی:
`exact-head CI Green + Android Green + live mergeability + expected-head lock + post-main proof`

## اصل سرعت
سه Lane موازی:
- Product/UX
- Core/Data
- CI/Automation/Docs

Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، automation، تست واقعی و docs هم‌زمان می‌آید؛ نه از دورزدن Gate.

## ادامه
1. PR #61 Head و workflow registration را Fresh بخوان.
2. فقط exact-head CI/Android فعلی معتبر است.
3. اگر Green + mergeable شد با expected-head lock Merge کن.
4. main را post-merge Verify کن.
5. #59 را از main جدید شروع کن و #50 را هم‌زمان Final Sync کن.
6. #62 و #19 را تا رفع واقعی باز نگه دار.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
