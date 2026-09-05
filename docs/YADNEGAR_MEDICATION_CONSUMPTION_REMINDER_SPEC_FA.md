# YadNegar — مشخصات مرجع قابلیت «یادآور مصرف دارو»

**نسخه:** MCR-1.0  
**وضعیت:** Canonical / Ready for Implementation  
**دسته:** یادآور پیگیری  
**نوع:** یادآور مصرف  
**نام فنی:** Medication Consumption Reminder / Medication Interval Scheduling

## 1. تصمیم محصول

«یادآور مصرف دارو» یک سیستم Reminder مستقل نیست؛ بلکه زیرمجموعه «یادآور پیگیری» و متصل به زیرساخت موجود Reminder/Notification است.

ساختار:

- یادآور معمولی
- یادآور پیگیری
  - پیگیری عادی
  - یادآور مصرف
    - مصرف دارو

Action اصلی کاربر: **«مصرف کردم»**.

## 2. هدف

کاربر هنگام ایجاد یادآور مصرف، نام دارو، میزان مصرف، واحد، فاصله مصرف و زمان اولین نوبت را وارد می‌کند. هر بار که واقعاً دارو را مصرف کرد، «مصرف کردم» را انتخاب می‌کند. زمان واقعی مصرف ثبت می‌شود و در حالت فاصله‌ای، نوبت بعدی از همان زمان محاسبه می‌شود.

### قانون اصلی

`nextDueAt = actualTakenAt + intervalDuration`

مثال: اگر فاصله ۶ ساعت و زمان واقعی مصرف ۰۸:۳۷ باشد، نوبت بعدی ۱۴:۳۷ است؛ حتی اگر نوبت اولیه ۰۸:۰۰ بوده باشد.

## 3. فرم ایجاد

فیلدها:

- نام دارو
- میزان مصرف
- واحد
- فاصله مصرف
- زمان اولین نوبت
- توضیحات اختیاری

فاصله‌های سریع پیشنهادی: ۴، ۶، ۸، ۱۲ و ۲۴ ساعت؛ همراه با امکان فاصله سفارشی در صورت پشتیبانی نسخه اجرا.

میزان مصرف باید دستی توسط کاربر وارد شود. نمونه: ۱ قرص، ۲ کپسول، ۵ میلی‌لیتر، ۲۰ قطره یا ۵۰۰ میلی‌گرم.

YadNegar مقدار یا فاصله تجویزی را تعیین، اصلاح یا پیشنهاد پزشکی نمی‌کند.

## 4. مدل داده پیشنهادی

### MedicationSchedule

- id
- medicationName
- doseAmount
- doseUnit
- intervalDuration
- startAt
- lastTakenAt
- nextDueAt
- enabled
- notes
- createdAt
- updatedAt

### DoseRecord

- id
- medicationScheduleId
- doseAmount
- doseUnit
- scheduledAt
- actualTakenAt
- status
- createdAt

وضعیت‌های پیشنهادی: `SCHEDULED`, `TAKEN`, `OVERDUE`, `CANCELLED`.

`scheduledAt` و `actualTakenAt` باید مستقل بمانند.

## 5. معماری

Clean Architecture + Feature-Based.

لایه Domain مالک قانون فاصله است؛ UI و Notification Scheduler نباید مالک Business Rule باشند.

Feature باید از زیرساخت موجود YadNegar برای Reminder، Persistence، Notification Scheduler، Reconciliation و Backup/Restore استفاده کند.

**ممنوع:** ایجاد Medication Scheduler، Notification Engine یا Reminder Store موازی.

اصل معماری: **ONE REMINDER ENGINE**.

## 6. جریان کار

Create Reminder → Follow-up Reminder → Consumption Reminder → Persist → Schedule Initial Reminder → Notification → «مصرف کردم» → Persist DoseRecord → Calculate nextDueAt → Reschedule Existing Reminder → Next Notification.

ثبت مصرف باید ابتدا پایدار شود و سپس Scheduler به‌روزرسانی گردد؛ شکست Scheduler نباید DoseRecord را از بین ببرد.

## 7. UI

کارت نمونه:

> 💊 نام دارو  
> یادآور مصرف  
> میزان مصرف: ۱ کپسول  
> فاصله مصرف: هر ۶ ساعت  
> آخرین مصرف: ۰۸:۳۷  
> نوبت بعدی: ۱۴:۳۷  
> **[ مصرف کردم ]**

برای نوبت گذشته، وضعیت «عقب افتاده» نمایش داده می‌شود؛ اما سیستم دوز جبرانی ایجاد یا پیشنهاد نمی‌کند.

## 8. رفتار زمانی

- مصرف دیرتر از برنامه: نوبت بعد از زمان واقعی مصرف محاسبه می‌شود.
- مصرف زودتر از برنامه: نوبت بعد نیز از زمان واقعی مصرف محاسبه می‌شود.
- نوبت گذشته: فقط وضعیت Overdue؛ بدون Catch-up Dose خودکار.
- Restart: وضعیت و زمان‌بندی پایدار باقی می‌ماند.
- Restore: داده‌ها بازیابی و Reminder Reconciliation اجرا می‌شود.
- Timezone: محاسبات با زمان محلی دستگاه سازگار هستند.

## 9. Acceptance Criteria

- [ ] گزینه «یادآور مصرف» زیر «یادآور پیگیری» وجود دارد.
- [ ] نام دارو قابل ثبت است.
- [ ] میزان مصرف دستی قابل ثبت است.
- [ ] واحد قابل انتخاب/ثبت است.
- [ ] فاصله مصرف قابل تعیین است.
- [ ] زمان اولین نوبت قابل تعیین است.
- [ ] Action اصلی «مصرف کردم» است.
- [ ] actualTakenAt هنگام ثبت مصرف ذخیره می‌شود.
- [ ] scheduledAt و actualTakenAt جداگانه حفظ می‌شوند.
- [ ] nextDueAt از actualTakenAt + intervalDuration محاسبه می‌شود.
- [ ] Reminder موجود پس از ثبت مصرف به زمان جدید تنظیم می‌شود.
- [ ] Duplicate Reminder ایجاد نمی‌شود.
- [ ] Restart داده‌ها را حفظ می‌کند.
- [ ] Backup/Restore تاریخچه و برنامه را حفظ می‌کند.
- [ ] Overdue باعث ایجاد دوز جبرانی نمی‌شود.
- [ ] سیستم مقدار یا فاصله مصرف را تغییر نمی‌دهد.
- [ ] UI فارسی و RTL است.
- [ ] قابلیت‌های موجود Reminder/Recurrence/Task/Follow-up دچار Regression نمی‌شوند.
- [ ] CI Quality Gate سبز است.

## 10. تست‌ها

### Domain

- ۶ ساعت + ۰۸:۰۰ = ۱۴:۰۰
- ۶ ساعت + ۰۸:۳۷ = ۱۴:۳۷
- ۱۲ ساعت + ۲۱:۱۵ = ۰۹:۱۵ روز بعد
- ۲۴ ساعت + ۲۳:۳۰ = ۲۳:۳۰ روز بعد
- Late dose و Early dose هر دو زمان بعدی را از actualTakenAt محاسبه کنند.
- فاصله صفر یا منفی رد شود.
- Dose بدون actualTakenAt نتواند TAKEN شود.
- scheduledAt و actualTakenAt مستقل بمانند.

### Persistence

Create/Read/Update/Delete برای Schedule، ایجاد و بازیابی DoseRecord، حفظ تاریخچه، nextDueAt و Backup/Restore.

### Scheduler

Initial scheduling، reschedule، cancel/update، جلوگیری از Duplicate، Startup Reconciliation و Restore Reconciliation.

### UI

ایجاد مسیر یادآور پیگیری، انتخاب یادآور مصرف، ورود میزان و واحد، فاصله، نمایش آخرین مصرف/نوبت بعد، Action «مصرف کردم»، حالت Overdue، RTL و Accessibility.

### Integration

سناریوی مرجع: فاصله ۶ ساعت، برنامه ۰۸:۰۰، مصرف واقعی ۰۸:۴۲ → nextDueAt=۱۴:۴۲؛ مصرف بعدی ۱۴:۵۰ → nextDueAt=۲۰:۵۰.

## 11. Non-Goals و مرز ایمنی

این Feature سیستم تصمیم‌گیری پزشکی نیست و شامل موارد زیر نیست:

- تشخیص بیماری
- توصیه یا محاسبه دوز
- تغییر مقدار مصرف
- تغییر فاصله تجویزی
- پیشنهاد دوز جبرانی
- بررسی تداخل دارویی
- Drug Database
- OCR نسخه
- AI Medical Advisor
- تحلیل بالینی

YadNegar فقط داده واردشده توسط کاربر را ثبت، پیگیری و یادآوری می‌کند.

## 12. Definition of Done

Feature فقط پس از تکمیل Domain، Persistence/Migration در صورت نیاز، اتصال به Reminder Scheduler موجود، UI، تاریخچه، Backup/Restore، تست‌های Unit/Repository/Scheduler/UI/Integration، Regression، RTL، مستندسازی و CI Quality Gate سبز، آماده Merge است.

هیچ تغییر مستقیمی در `main` برای اجرای Feature مجاز نیست؛ توسعه باید روی Branch و از مسیر Issue/PR انجام شود.
