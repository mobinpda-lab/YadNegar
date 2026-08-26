# YadNegar / یادنگار

اپلیکیشن فارسی و RTL برای ثبت سریع یادداشت‌ها، رویدادها، تماس‌ها، ایده‌ها و فعالیت‌های روزانه با رویکرد Timeline.

## وضعیت فعلی
Flutter Foundation واقعی در `main` Merge شده است.

Snapshot تأییدشده 2026-08-26:
- `main`: `c632570a8d09fffecc3ae27e9747f417888b9c5f`
- Flutter/Dart foundation: موجود
- RTL shell پایه: موجود
- baseline widget test: موجود
- CI consolidation: در PR #7
- RTL Timeline shell: در PR #8
- Canonical documentation baseline: در PR #3

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

## موج جاری
- Lane A: Foundation تثبیت شده؛ Timeline/Core contract مرحله بعد است.
- Lane B: RTL Timeline shell در PR #8.
- Lane C: CI consolidation در PR #7 و مستندات Canonical در PR #3.

## ادامه پروژه
Trigger استاندارد:

`ادامه یادنگار`
