# YadNegar — Live AI Handoff

## مرجع حقیقت
`GitHub Reality > قرارداد تأییدشده مالک > Governance > اسناد canonical > حافظه گفتگو`

قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified product main: `9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

## کجا هستیم
جهت canonical محصول همان «کار ثابت + تاریخچه پیگیری‌های فرزند» است. یک root ثابت می‌ماند و هر FollowUp به همان root اضافه می‌شود. Repository/JSON/Reminder foundation موجود reuse شده و سیستم موازی ساخته نشده است.

Issueهای #117 و #121 قبلاً کامل و بسته شده‌اند و دیگر جزو کار آینده نیستند.

## رفتار اصلی فعلی
### خانه
- فقط کارهای اصلی/root نمایش داده می‌شوند.
- آخرین FollowUp واقعی مبنای تاریخ/ساعت دقیق جلالی/فارسی و متن نسبی است.
- تاریخ ساخت کار هرگز به‌عنوان «آخرین پیگیری» جا زده نمی‌شود.
- حالت بدون پیگیری واضح است.
- کارت‌ها compact باقی مانده‌اند.
- جستجو اکنون عنوان کار، شرح اختیاری کار و متن همه پیگیری‌های همان کار را پوشش می‌دهد.

### پیگیری
- دکمه `+` صفحه مستقل `ثبت پیگیری` را باز می‌کند.
- عنوان اختیاری است؛ خالی باشد `پیگیری` ذخیره می‌شود.
- تاریخ/ساعت پیش‌فرض از دستگاه است و قبل از ذخیره قابل تغییر است.
- ورودی تاریخ جلالی و ارقام نمایشی فارسی‌اند.
- ویرایش یک FollowUp، parent و sibling history را حفظ می‌کند.

### شرح و تاریخچه
- شرح/خلاصه چندخطی کار اختیاری است و create/edit/detail/PDF آن را پشتیبانی می‌کنند.
- جدیدترین FollowUp اول دیده می‌شود.
- elapsed time و فاصله بین پیگیری‌ها محاسباتی‌اند و Persist نمی‌شوند.

### PDF / اشتراک / چاپ
PDF فارسی واقعی برای سه Scope وجود دارد:
1. همه کارها
2. کارهای انتخاب‌شده
3. یک کار با کل تاریخچه پیگیری‌ها

PDF از RTL، ارقام فارسی، تاریخ جلالی و Vazirmatn bundled استفاده می‌کند. Share و Print همان مسیر PDF را reuse می‌کنند. JSON Backup ویژگی جداگانه Data Safety است.

## Data Safety
Storage schema فعلی: **v5**  
Backward-compatible reads: **v1 تا v4**

- v4: `parentId` اختیاری برای root→FollowUp
- v5: `description` اختیاری برای root
- یک Repository/Storage واحد
- بدون migration مخرب
- بدون read-time rewrite
- safe-write + tmp/bak recovery
- Backup/Restore validation
- newer unsupported schema => fail-closed

## آخرین Slice تکمیل‌شده — #144 / PR #145
Fresh Audit نشان داد متن کادر جستجو قول جستجو در «کارها و پیگیری‌ها» می‌دهد ولی قبلاً فقط title را بررسی می‌کرد.

اصلاح نهایی:
- title match
- description-only match
- FollowUp-only match
- بدون root تکراری
- بدون disk/repository query هنگام تایپ
- بدون تغییر schema/model/store/scheduler/dependency

Final PR head:
`b876bade5c89d5215d7955c8b1ffc250bd8f627e`

Pre-merge exact-head:
- CI `33183658883`: success
- UI Evidence `33183658891`: success
- Android `33183658875`: success full chain

Merged main:
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

Post-main exact SHA:
- CI `33185558030`: success
- Android `33185558017`: success full chain
  - Debug APK
  - Candidate APK
  - Emulator startup + storage recovery
  - Readiness
  - Release Draft
  - Approval/Rollback

#144 اکنون Completed است.

## Release Safety
Automation موجود:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

وضعیت انتشار:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

production keystore/secret، Tag واقعی، GitHub Release یا Play Store publish ساخته نشده است.

## Issue #19
#19 تنها Issue شناخته‌شده باز است و Platform-limited محسوب می‌شود.

Ruleset `main-protection` فعال است:
- PR required
- deletion blocked
- non-fast-forward blocked

اما required status checks هنوز Platform-level enforce نشده‌اند چون ابزار متصل Ruleset Write ندارد.

قانون عملی Merge:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## Lane مستندات فعلی
Branch:
`docs/tracked-subject-search-content`

این branch تا پایان post-main #145 بدون write نگه داشته شد و سپس بدون Force روی exact main `9b577cc...` قرار گرفت.

Scope مورد انتظار فقط چهار سند canonical است:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

بعد از Fast CI exact-head و fresh compare چهار‌فایلی، با expected-head merge شود و post-main Fast CI گرفته شود.

## Maximum Parallel
- Laneهای مستقل Product / Release / Automation / Docs موازی‌اند.
- Block یک Runner فقط همان Lane را نگه می‌دارد.
- Reuse قبل از Rebuild.
- PR کوچک و rollback-friendly.
- stale/fake evidence ممنوع.
- Green تاریخی برای Head جدید معتبر نیست.

## صف واقعی
- Product PR باز: ندارد
- Product Issue شناخته‌شده باز: ندارد
- تنها Issue باز: #19، محدودیت Platform-level

Backlog مصنوعی ایجاد نشود. Slice محصولی بعدی فقط بعد از Fresh Audit و اثبات یک نیاز واقعی کوچک و reuse-first باز شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
