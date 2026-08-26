# YadNegar / یادنگار

یادنگار یک اپلیکیشن فارسی و RTL برای ثبت سریع و مرور زمانی یادداشت‌ها، رویدادها، تماس‌ها، ایده‌ها و فعالیت‌های روزانه است.

## وضعیت فعلی
مرجع واقعیت، GitHub زنده است؛ SHA و وضعیت Workflowها قبل از هر Merge باید Fresh Audit شوند.

محصول روی `main` اکنون یک Flow واقعی و مشترک دارد:

`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo`

قابلیت‌های موجود:
- Note / Event / Call / Idea / Activity روی یک `TimelineItem`
- فارسی و RTL-first
- Quick Capture واقعی
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Timeline با زمان ثبت/رخداد
- Search + Type + Date Range
- ثبت و ویرایش `occurredAt` برای Event/Activity
- اصلاح Type در Edit flow موجود
- حذف با تأیید فارسی
- بازگردانی بعد از حذف با محافظت در برابر overwrite آیتم جدیدتر
- Fast CI: `flutter analyze + flutter test`
- Android debug APK build + verify + artifact upload

Foundation موازی برای Timeline Model / Repository / Storage / App Shell وجود ندارد و نباید بدون نیاز معماری ساخته شود.

## معماری
- Flutter / Dart
- Clean Architecture + Feature-Based Architecture به‌صورت incremental
- Persian RTL-first UI
- Timeline-oriented experience
- یک Repository/Storage مشترک برای Timeline

## GitHub Automation
قاعده Merge محصول:

`exact current head → Fast CI Green → Android Green → live mergeability → expected_head_sha lock → post-main proof`

Ruleset فعلی Pull Request را الزام می‌کند، اما required status check هنوز Platform-level فعال نشده است؛ Issue #19 این Gap را دنبال می‌کند.

## مستندات اصلی
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — Canonical governance
- `docs/YADNEGAR_OPERATION_PLAN.md` — برنامه عملیاتی فعال
- `docs/AI_CONTINUATION_STATE.md` — نقطه ادامه زنده
- `docs/AI_HANDOFF_CURRENT_FA.md` — Handoff فشرده
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md` — مرجع جامع/تاریخی؛ برای وضعیت جاری به Current State رجوع شود
- `PROJECT_DOCUMENTATION_FA.md` — جزئیات فنی/محصولی

## مدل توسعه
`Audit → Reuse → Decompose → Parallelize → Execute → Validate → Document → Integrate → Report`

هدف تولید نرم‌افزار Verify‌شده در چند ساعت به‌جای چند روز است؛ با کار موازی هماهنگ، Automation، PRهای کوچک، تست واقعی و مستندسازی هم‌زمان—not با حذف کنترل کیفیت.

## موج بعدی محصول
طبق سند جامع، پس از Search/Reliability وارد Wave 6 می‌شویم:
- Reminder
- Backup
- Export

قبل از شروع هرکدام، Fresh Gap Audit انجام می‌شود و کوچک‌ترین Vertical Slice واقعی انتخاب می‌شود؛ Foundation حدسی ساخته نمی‌شود.

## ادامه پروژه
Trigger استاندارد:

`ادامه یادنگار`
