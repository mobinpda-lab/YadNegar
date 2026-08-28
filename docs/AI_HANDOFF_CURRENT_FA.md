# YadNegar — Live AI Handoff

## مرجع حقیقت
`GitHub Reality > قرارداد تأییدشده مالک > Governance > اسناد canonical > حافظه گفتگو`

قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified product main: `2c1f944f94de729037adc62939650863123786c3`

## کجا هستیم
اصلاح اصلی محصول در Issue #121 تکمیل شده است. جهت اصلی یادنگار دیگر یک Timeline تخت نیست؛ محصول اصلی اکنون «کار ثابت + تاریخچه پیگیری‌های فرزند» است و همان Foundation قبلی Repository/JSON را reuse می‌کند.

یک کار اصلی ثابت می‌ماند و هر پیگیری به همان کار append می‌شود. ایجاد یا ویرایش پیگیری، سابقه قبلی را حذف یا جایگزین نمی‌کند.

## رفتار نهایی محصول
### خانه
- فقط کارهای اصلی/root نمایش داده می‌شوند.
- اگر پیگیری وجود داشته باشد، آخرین FollowUp واقعی مبنای تاریخ/ساعت دقیق و متن نسبی است.
- تاریخ ساخت خود کار هرگز به‌عنوان «آخرین پیگیری» نمایش داده نمی‌شود.
- اگر پیگیری وجود نداشته باشد، وضعیت واضح بدون پیگیری نمایش داده می‌شود.
- کارت‌ها compact باقی مانده‌اند.

### ثبت و ویرایش پیگیری
- دکمه گرد `+` واضح و در دسترس است.
- `+` صفحه مستقل `ثبت پیگیری` را باز می‌کند.
- عنوان پیگیری اختیاری است؛ خالی باشد `پیگیری` ذخیره می‌شود.
- تاریخ/ساعت پیش‌فرض از دستگاه می‌آید ولی قبل از ذخیره قابل تغییر است.
- ورودی تاریخ جلالی/فارسی و نمایش اعداد فارسی است.
- خود کار و هر پیگیری بعداً قابل ویرایش هستند.
- `parentId` و تاریخچه خواهر/برادرها هنگام ویرایش حفظ می‌شوند.

### جزئیات و تاریخچه
- عنوان + شرح/خلاصه اختیاری کار نمایش داده می‌شود.
- جدیدترین پیگیری اول دیده می‌شود.
- زمان سپری‌شده از آخرین پیگیری محاسبه می‌شود و Persist نمی‌شود.
- فاصله بین پیگیری‌ها محاسبه می‌شود و Persist نمی‌شود.
- حالت بدون پیگیری صریح است.

### شرح/خلاصه کار
- هنگام ساخت کار می‌توان شرح چندخطی اختیاری ثبت کرد.
- Edit می‌تواند شرح را اضافه/تغییر/پاک کند.
- Detail شرح را نمایش می‌دهد یا empty state ساده دارد.
- Home برای حفظ سرعت و hierarchy، شرح را روی کارت‌ها شلوغ نمی‌کند.

### PDF / اشتراک / چاپ
PDF فارسی واقعی برای سه Scope وجود دارد:
1. همه کارها
2. کارهای انتخاب‌شده
3. یک کار با کل تاریخچه پیگیری‌ها

PDF از RTL، ارقام فارسی، تاریخ جلالی و Vazirmatn bundled استفاده می‌کند. شرح کار در صورت وجود داخل PDF می‌آید. Share و Print همان projection/document path را reuse می‌کنند. JSON Backup همچنان ویژگی جداگانه machine-readable است.

## Data Safety و معماری
Storage schema فعلی: **v5**  
Backward-compatible reads: **v1 تا v4**

- schema v4: رابطه اختیاری parent برای root→follow-up
- schema v5: description اختیاری روی root tracked task

اصول حفظ‌شده:
- یک Repository/Storage واحد
- بدون DB/Store دوم برای Task/FollowUp
- بدون migration مخرب
- no read-time rewrite
- safe-write + tmp/bak recovery
- Backup/Restore validation
- unsupported newer schema برای نسخه قدیمی fail-closed می‌شود

## موج‌های اصلی تکمیل‌شده #121
- #122 / PR #124 — Foundation کار اصلی و پیگیری‌های persistent
- #126 / PR #130 — Jalali picker + اعداد فارسی تاریخ/ساعت
- #129 / PR #133 — محاسبات مشترک مدت‌زمان فارسی
- #128 — flow نهایی ثبت/ویرایش پیگیری و semantics صحیح Home/Detail
- #125 / PR #138 + #139 — PDF فارسی + all/selected/single + share/print
- #140 / PR #141 + #142 — description در schema v5 + UI + PDF

PR #120 مربوط به polish مدل flat Timeline عمداً Superseded شد و با جهت canonical #121 ادغام نشد.

## Evidence نهایی #140 / #142
Final PR head:
`da362d2138df05b859468d36b52b61d1ac95192f`

Merged main:
`2c1f944f94de729037adc62939650863123786c3`

Pre-merge exact-head:
- CI `33179167525`: success
- UI Evidence `33179167522`: success
- Android `33179167509`: success full chain
- mergeability=true
- exact expected-head merge: success

Post-main روی SHA دقیق `2c1f944...`:
- CI `33179977417`: success
- Android `33179977437`: success full chain
  - Debug APK + verify/upload
  - Candidate APK + evidence
  - Emulator startup + storage recovery
  - Release Readiness
  - deterministic Release Draft
  - Approval/Rollback evidence

مشکل 320px فرم «کار جدید» نیز در Theme واقعی برنامه حل و تست شده است: Dialog inset افقی 20px است و هیچ محتوا یا typography عادی حذف/کوچک نشده است.

## بدهی قدیمی #117
#117 از نظر Product قبلاً کامل بوده و فقط بدهی Documentation داشت:
- product head `6d740ee26f48c9958d80b68c5c5f785af124d33c`
- merged main `8b1ff3912cca3c90f69dd2fcae4a98b3151049dd`
- pre CI `33119504206`: success
- pre Android `33119504472`: success full chain
- post CI `33120260013`: success
- post Android `33120260012`: success full chain

این قابلیت query-clear در ابزار Timeline قدیمی باقی مانده و با جهت اصلی tracked-task تعارض ندارد.

## Reminder / Release Safety
Reminder یک‌باره و recurring روزانه/هفتگی همچنان روی همان Timeline foundation فعال است و timezone محلی دستگاه را reuse می‌کند.

زنجیره Automation:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

وضعیت انتشار:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

هیچ production keystore/secret، Tag واقعی، GitHub Release یا Play Store publish ساخته نشده است.

## Automation — Issue #19
#19 عمداً باز می‌ماند. Ruleset `main-protection` PR را اجباری و deletion/non-fast-forward را مسدود می‌کند؛ اما required status checks هنوز Platform-level enforce نشده‌اند چون ابزار متصل Ruleset Write ندارد.

تا آن زمان قانون عملی Merge:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## مستندات نهایی
Branch:
`docs/tracked-task-canonical-final`

این branch تا پایان Product Gate بدون write نگه داشته شد و فقط بعد از Green کامل post-main، بدون Force به exact main `2c1f944...` fast-forward شد.

Scope نهایی فقط چهار سند canonical است:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

بعد از exact-head Fast CI، fresh compare، mergeability زنده و merge با expected-head، post-main Fast CI اجرا می‌شود؛ سپس #117 و parent #121 Completed بسته می‌شوند.

## Maximum Parallel
- Laneهای مستقل Product / Release / Automation / Docs موازی حرکت می‌کنند.
- Block یک Runner، Lane مستقل را متوقف نمی‌کند.
- Reuse قبل از Rebuild.
- PRها کوچک و rollback-friendly.
- Stacked preparation فقط با fresh scope.
- stale/fake evidence ممنوع.
- Historical Green برای Head جدید معتبر نیست.

## صف واقعی
از نظر محصول، قرارداد #121 تکمیل است. بعد از cleanup وضعیت Issueها، فقط #19 به‌عنوان مانع Platform-level باقی می‌ماند.

Backlog مصنوعی ساخته نشود. Slice بعدی فقط بعد از Fresh Audit و اثبات یک نیاز کوچک واقعی و reuse-first ایجاد شود.

## ادامه
1. Fresh compare branch مستندات با main دقیق `2c1f944...`.
2. PR Docs با scope دقیق چهار فایل.
3. exact-head Fast CI.
4. mergeability زنده + expected-head merge.
5. post-main Fast CI.
6. Close #117 و #121.
7. Fresh Audit برای نیاز محصولی بعدی؛ #19 باز بماند تا Ruleset Write واقعاً ممکن شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
