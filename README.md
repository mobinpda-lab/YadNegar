# YadNegar / یادنگار

اپلیکیشن فارسی و RTL برای ثبت سریع یادداشت‌ها، رویدادها، تماس‌ها، ایده‌ها و فعالیت‌های روزانه با رویکرد Timeline.

## وضعیت فعلی
پروژه در مرحله Documentation / Foundation integration است.

در Snapshot تأییدشده `main` در 2026-08-26، Flutter Foundation هنوز Merge نشده بود؛ اما Foundation واقعی در PR #2 ایجاد شده و برای Head دقیق آن Flutter Analyze/Test موفق شده است. تا زمان Merge شدن PR #2، Foundation هنوز وضعیت `main` محسوب نمی‌شود.

## معماری هدف
- Flutter / Dart
- Clean Architecture
- Feature-Based Architecture
- Persian RTL-first UI
- Timeline-oriented product experience

## مستندات اصلی
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — مرجع Canonical عملیات و توسعه
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md` — سند جامع پروژه
- `docs/YADNEGAR_OPERATION_PLAN.md` — برنامه عملیاتی فعال، شتاب‌یافته و موازی
- `docs/AI_CONTINUATION_STATE.md` — وضعیت جاری و نقطه ادامه
- `docs/AI_HANDOFF_CURRENT_FA.md` — Handoff فشرده برای Session جدید
- `PROJECT_DOCUMENTATION_FA.md` — مستند فنی و محصولی
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md` — ارجاع سازگاری به Canonical document
- `docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md` — فقط ارجاع سازگاری تاریخی به برنامه فعال

## اصل توسعه
`Audit → Understand → Plan → Parallelize → Execute → Validate → Document → Report`

GitHub مرجع اصلی واقعیت پروژه است. تغییرات باید کوچک، قابل Rollback و دارای Evidence باشند و کارهای مستقل تا حد امن به‌صورت موازی انجام شوند.

## اصل سرعت
هدف تولید نرم‌افزار واقعی در چند ساعت به‌جای چند روز است؛ با کار موازی هماهنگ، GitHub Automation، بازخورد سریع، کنترل کیفیت و مستندسازی همزمان.

## ادامه پروژه
Trigger استاندارد:

`ادامه یادنگار`
