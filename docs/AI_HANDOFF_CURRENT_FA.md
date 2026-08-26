# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `509817c344d014579e28f62d64ff8465b722f3b9`

## وضعیت محصول
Timeline واحد حفظ شده و قابلیت حذف امن هم وارد main شده است.

### PR #61 / Issue #57 — Merge شد
حذف Timeline item با confirmation فارسی تکمیل شد.

Exact pre-merge head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`
- Fast CI `33020857429`: success
- Android `33020857455`: success
- live mergeability: clean
- merge با `expected_head_sha`
- main جدید: `509817c344d014579e28f62d64ff8465b722f3b9`

نتیجه:
- حذف روی همان Repository/Storage موجود
- write path crash-recoverable reuse شده
- حذف داخل Edit flow موجود
- Search/Type/Date بعد از حذف حفظ می‌شوند
- schema/storage/model موازی ساخته نشده

Post-main Fast CI + Android برای `509817c...` در حال Verify هستند؛ تا هر دو Green نشوند post-main proof کامل نیست.

## Product فعال — PR #63 / Issue #59
`feat(timeline): allow undo after item deletion`

PR از حالت stacked روی #61 به `main` جدید Retarget شده و همچنان فقط ۵ فایل تغییر دارد.

Current head: `5d651814147289ae3b410d5f023eb777fb91f53e`
Status: Draft

پیاده‌سازی:
- `RestoreTimelineItem` کوچک با reuse `findById + upsert`
- اگر همان ID دوباره وجود داشته باشد restore انجام نمی‌شود تا داده جدید overwrite نشود
- action فارسی `بازگردانی` بعد از حذف
- همان TimelineItem در حافظه برگردانده می‌شود؛ history storage/soft-delete نداریم
- Search/Type/Date state حفظ می‌شود
- تست Application و Widget برای metadata و فیلترها اضافه شده

بعد از Green شدن post-main #61، یک تست Widget conflict-path نهایی اضافه می‌شود تا synchronize طبیعی #63 ساخته شود؛ سپس exact-head CI + Android لازم است.

## Automation — Issue #62
مشکل delayed PR merge-ref/workflow registration باز است. #61 در نهایت سالم Gate گرفت؛ برای بستن #62 باید یک PR بعدی مثل #63 بدون carrier churn به‌طور قابل‌تکرار Gate بگیرد.

Gate دور زده نمی‌شود و historical Green به Head جدید نسبت داده نمی‌شود.

## Docs — PR #50
Docs هم‌زمان به‌روز می‌شوند و PR #50 فعلاً Draft است. Merge Docs فقط بعد از پایان موج Product و sync واقعی روی main پایدار.

## Ruleset — Issue #19
Required Status Check هنوز از طریق Connector قابل‌نوشتن/اثبات نیست.

قانون Merge:
`exact-head CI Green + Android Green + live mergeability + expected-head lock + post-main proof`

## اصل سرعت
سه Lane موازی:
- Product/UX
- Core/Data
- CI/Automation/Docs

Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، تست واقعی، automation و docs هم‌زمان می‌آید؛ نه از کاهش کنترل کیفیت.

## ادامه
1. post-main #61 را Green verify کن.
2. conflict-path test نهایی #63 را اضافه کن.
3. exact-head CI + Android #63 را بگیر.
4. اگر Green + mergeable بود با expected-head lock Merge کن.
5. main جدید را دوباره Verify کن.
6. سپس PR #50 را Final Sync کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
