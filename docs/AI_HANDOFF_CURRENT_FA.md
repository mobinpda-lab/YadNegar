# YadNegar — Live AI Handoff

## قانون اصلی
مرجع فعال عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

این فایل فقط Handoff فشرده است و مرجع Governance موازی نیست.

## شروع کار
1. ابتدا Canonical Operating Package را بخوان.
2. GitHub زنده را بررسی کن: Repository، `main`، HEAD، Commitهای اخیر، PRهای باز و Workflowهای Ref دقیق.
3. `docs/AI_CONTINUATION_STATE.md` را با وضعیت واقعی تطبیق بده.
4. قبل از تغییر، ساختار واقعی فایل‌ها و قابلیت موجود را Audit کن.
5. نزدیک‌ترین Gap واقعی را انتخاب کن و از دوباره‌کاری جلوگیری کن.

## وضعیت پایه‌ای که باید دوباره Verify شود
در Snapshot تاریخ 2026-08-26:
- Repository: `mobinpda-lab/YadNegar`
- Default branch: `main`
- Main SHA: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Root فقط `.github/` و `README.md` داشت.
- `pubspec.yaml`، `lib/` و `test/` در Root وجود نداشتند.
- `build.yml` و `test.yml` Placeholder بودند.

این موارد Snapshot هستند؛ در Session بعد باید دوباره از GitHub Verify شوند.

## هویت محصول
YadNegar یک اپلیکیشن فارسی، RTL و Timeline-oriented برای ثبت سریع اطلاعات روزمره است.

حوزه‌های هدف:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت روزانه
- Timeline
- Quick Capture
- تاریخ و زمان

## معماری
Target:
- Flutter / Dart
- Clean Architecture
- Feature-Based Architecture
- Domain با وابستگی حداقلی به Infrastructure
- Shared Foundation پایدار
- Persian RTL-first UI

تا زمانی که کد واقعی وجود ندارد، Target را به‌عنوان وضعیت پیاده‌سازی‌شده گزارش نکن.

## توسعه موازی
Lane A: Core / Domain / Foundation  
Lane B: UI / Feature  
Lane C: CI / Automation / Documentation

کارهای مستقل همزمان انجام شوند. Foundation مشترک و فایل‌های مشترک باید مالکیت و ترتیب روشن داشته باشند.

## Validation
زنجیره هدف:
`flutter pub get → flutter analyze → flutter test → flutter build`

Evidence فقط برای Commit/Ref دقیق معتبر است. Placeholder Workflow معادل Flutter validation نیست.

## ادامه
Trigger کاربر:
`ادامه یادنگار`

معنی آن:
`Audit live GitHub → compare current state → select nearest real gap → execute safe work → validate → document → report`

## اصل Handoff
از حافظه گفتگو پروژه را بازسازی نکن. GitHub واقعی، Canonical document، Current State و Evidence دقیق مبنای ادامه هستند.
