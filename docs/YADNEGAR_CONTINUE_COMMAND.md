# فرمان اجرایی جامع «ادامه یادنگار»

## نسخه عملیاتی — PRODUCT FIRST + FACTORY MINIMAL

### فرمان فعال

**ادامه یادنگار**

این فرمان یعنی:

> ادامه اجرای واقعی `mobinpda-lab/YadNegar` از آخرین وضعیت معتبر GitHub؛ نه صرفاً تهیه گزارش.

اصول حاکم:

> **PRODUCT FIRST + FACTORY MINIMAL**  
> **DATA SAFE + EVIDENCE BASED + RELEASE FOCUSED**

یادنگار محصول نهایی است و کارخانه فقط وسیله‌ای برای تولید، کنترل کیفیت، ایمنی داده، آزمایش و Release است.

چرخه اصلی:

**GitHub واقعی → بررسی → تشخیص → اولویت محصول → اجرای واقعی → موازی‌سازی کنترل‌شده → تست → شواهد → ساده‌سازی کارخانه → ادامه**

گزارش هرگز جای اجرای واقعی را نمی‌گیرد.

---

## 1. منبع حقیقت

GitHub منبع حقیقت است.

در هر اجرای «ادامه یادنگار» ابتدا این موارد از وضعیت واقعی GitHub بررسی شوند:

- Repository
- Branch
- `main` و HEAD واقعی
- PRهای مرتبط
- Issueهای مرتبط
- Workflowها و CI
- Commitهای اخیر
- Artifactها
- Test و Build
- Android Smoke
- Device Evidence
- مستندات قراردادی
- وضعیت کارهای قبلی

اطلاعات قدیمی بدون تأیید مجدد معتبر نیستند.

هر مورد غیرقابل‌تأیید:

> ❓ نامشخص

هرگز حدس زده نشود.

---

## 2. Product First

هر کار با این سؤال ارزیابی شود:

> «آیا این کار مستقیماً یادنگار را بهتر، امن‌تر، قابل‌آزمایش‌تر یا قابل‌انتشارتر می‌کند؟»

اگر بله، انجام شود.

اگر زیرساخت ضروری است، فقط به اندازه لازم انجام شود.

اگر ارزش مشخصی ندارد:

> حذف، ادغام، توقف یا سبک‌سازی.

---

## 3. تعریف محصول یادنگار

یادنگار یک محصول مستقل برای مدیریت پیگیری‌های واقعی است.

هسته محصول:

> **موضوع → پیگیری‌ها → آخرین وضعیت → اقدام بعدی → توجه امروز**

مسیرهای اصلی:

- موضوع
- FollowUp
- Timeline
- آخرین وضعیت
- اقدام بعدی
- توجه امروز
- Waiting / `waiting_for_response`
- Project
- Category
- Tag
- Search
- Quick Add
- Detail
- Reminder
- Recurrence
- Notification
- Widget
- Jalali / Iran Time
- Persistence
- Migration
- Backup / Restore
- PDF
- Share
- Print

یادنگار نباید به نسخه دوم آروین تبدیل شود.

> **Arvin Lessons, not Arvin Code.**

از تجربه آروین استفاده شود، اما هیچ وابستگی کدی، معماری، مدل یا Storage بین دو محصول ایجاد نشود.

---

## 4. اولویت کارها

### P0 — حیاتی

- Data Loss
- Storage
- Persistence
- Migration
- Crash
- Backup/Restore بحرانی
- Release Blocker

### P1 — محصول

- هسته موضوع و پیگیری
- FollowUp
- Timeline
- آخرین وضعیت
- اقدام بعدی
- توجه امروز
- Search
- Waiting
- Home
- Quick Add
- Detail
- Project
- Category
- Tag
- Reminder
- Recurrence
- Notification
- Widget

### P2 — کیفیت

- Unit Test
- Widget Test
- Integration Test
- Device Smoke
- CI ضروری
- Documentation ضروری
- Automation ضروری

### P3 — بهینه‌سازی

- Factory Cleanup
- Refactor غیرضروری
- Automation بدون گلوگاه
- بهینه‌سازی‌های غیرضروری

> P3 قبل از P0/P1/P2 انجام نشود، مگر اینکه خود P3 یک گلوگاه واقعی را رفع کند.

---

## 5. Product Value

هر Task باید حداقل یک ارزش مشخص داشته باشد:

- قابلیت محصول بهتر می‌شود.
- خطای محصول رفع می‌شود.
- داده امن‌تر می‌شود.
- تست واقعی اضافه می‌شود.
- مانع Release برداشته می‌شود.

اگر هیچ‌کدام مشخص نیست:

> کار متوقف و بازبینی شود.

---

## 6. اجرای واقعی

اگر کاری مشخص، مستقل، کم‌ریسک، قابل‌تأیید، دارای ارزش محصول و قابل انجام از طریق GitHub باشد:

> **کار انجام شود، نه اینکه فقط درباره آن گزارش نوشته شود.**

اگر نیازمند تصمیم مالک محصول است:

> فقط همان تصمیم مشخص درخواست شود.

---

## 7. موازی‌سازی

- کارهای مستقل: موازی.
- کارهای وابسته: پس از پیش‌نیاز.
- کارهای پرریسک/معماری: ابتدا بررسی عمیق.

اصل:

> **سریع + همزمان + موازی + کنترل‌شده**

سرعت نباید باعث تداخل، دوباره‌کاری، Data Loss یا کاهش پوشش شود.

---

## 8. جلوگیری از Duplicate Work

پیش از ایجاد کار جدید، Branch، PR، Issue، Worker، فایل‌های درگیر، کار انجام‌شده و PRهای قدیمی بررسی شوند.

اگر کار مشابه وجود دارد:

> کار جدید ایجاد نشود مگر با دلیل واقعی.

---

## 9. Branch و Main

هیچ تغییر مستقیم و کنترل‌نشده‌ای روی `main` انجام نشود.

مسیر استاندارد:

> **Issue → Branch → Change → Test → PR → CI → Validation → Merge**

هر تغییر کوچک، مشخص، قابل بررسی، قابل بازگشت و هدفمند باشد.

---

## 10. Factory Minimal

کارخانه فقط برای این موارد فعال بماند:

1. Product Quality
2. Data Safety
3. Real Testing
4. Release

هر Workflow، Worker، Job، Queue، Script یا Automation بدون ارزش مشخص در این حوزه‌ها:

> حذف، ادغام، سبک‌سازی یا غیرفعال شود.

هدف:

> **کمترین کارخانه‌ای که بیشترین اطمینان لازم برای محصول را ایجاد کند.**

---

## 11. Factory Minimal Gate

پیش از Automation جدید:

1. آیا ارزش مستقیم محصول دارد؟
2. آیا کیفیت، Data Safety یا Release را تضمین می‌کند؟
3. آیا گلوگاه واقعی را رفع می‌کند؟
4. آیا راه ساده‌تری وجود دارد؟
5. آیا خودش پیچیدگی بیشتری ایجاد می‌کند؟

اگر 1 تا 3 منفی و 4 مثبت باشد:

> **Automation ایجاد نشود.**

---

## 12. CI

CI باید حداقل مؤثر باشد.

مسیر پایه:

```
Analyze
   ‖
Unit / Widget Test
   ‖
Build
   ‖
Android Smoke
```

در صورت استقلال واقعی، موازی اجرا شوند.

هیچ Job بدون دلیل محصولی یا کیفی حفظ نشود.

---

## 13. سریع‌سازی CI

مجاز:

- Parallel Execution
- Matrix
- Cache
- Sharding
- Artifact Reuse معتبر
- حذف Build تکراری
- حذف Analyze تکراری
- Setup بهینه

غیرمجاز:

- حذف تست محصول
- حذف Smoke
- حذف Build ضروری
- حذف Validation
- نادیده گرفتن Failure
- استفاده از Artifact مربوط به Commit دیگر
- سبزسازی مصنوعی CI

---

## 14. Android Smoke

تمرکز Smoke بر رفتار واقعی محصول باشد.

سناریوهای اصلی:

```
Home
‖
Quick Add
‖
Persistence
‖
Migration
‖
Backup / Restore
‖
Notification
‖
Widget
‖
Search
‖
FollowUp
```

هر سناریو باید Failure قابل تشخیص داشته باشد.

---

## 15. Exact-Head Validation

هر شواهد باید به Commit دقیق متصل باشد.

حداقل:

- `MAIN_SHA`
- `HEAD_SHA`
- `WORKFLOW_RUN`
- `JOB`
- `RESULT`
- `ARTIFACT`

موفقیت Commit قدیمی اثبات موفقیت Commit جدید نیست.

---

## 16. Release Validation

Release-Ready فقط با CI سبز اثبات نمی‌شود.

زنجیره:

```
Code
 ↓
Analyze
 ↓
Tests
 ↓
Build
 ↓
Android Smoke
 ↓
Persistence / Migration
 ↓
Backup / Restore
 ↓
UI / UX
 ↓
Real Device Evidence
 ↓
Release Artifact
```

هر حلقه بدون شواهد:

> ❓ نامشخص

---

## 17. Storage و Migration

هیچ Storage یا Model موازی ایجاد نشود.

مسیر canonical:

```
UI
 ↓
Application Service
 ↓
Repository
 ↓
DAO
 ↓
Storage
```

Migration باید:

- Data Loss نداشته باشد.
- Duplicate ایجاد نکند.
- IDها را تا حد امکان حفظ کند.
- Timeline و تاریخچه را حفظ کند.
- Archive/Trash را حفظ کند.
- Backup/Restore را سالم نگه دارد.
- قابل بازیابی باشد.

ساختار UI قدیمی داده Migration نیست؛ اما وابستگی‌های کد و تست به مسیر قدیمی باید در همان جریان شناسایی و اصلاح شوند.

هدف:

> **No Data Loss + No Parallel Storage + No Parallel Model**

---

## 18. Search

Search یکی از قابلیت‌های اصلی است.

اولویت فعلی:

> **Search v2**

پیش از اجرای هر کار جدید، کد فعلی، Branch، PR، Issue، Test، CI و قابلیت موجود بررسی شوند تا دوباره‌کاری ایجاد نشود.

---

## 19. Waiting

`waiting_for_response` بخشی از جریان واقعی FollowUp است.

باید:

- وضعیت انتظار را مشخص کند.
- ارتباط با پیگیری را حفظ کند.
- اقدام بعدی را مشخص نگه دارد.
- پیگیری‌های منتظر پاسخ را قابل مشاهده کند.

---

## 20. QA محصول

مسیرهای اصلی QA:

- Home
- Quick Add
- موضوع
- FollowUp
- Timeline
- آخرین وضعیت
- اقدام بعدی
- توجه امروز
- Waiting
- Project
- Category
- Tag
- Reminder
- Recurrence
- Search
- Detail
- Persistence
- Migration
- Backup/Restore
- RTL
- Jalali / Iran Time
- Notification
- Widget
- Swipe
- PDF
- Share
- Print

---

## 21. Device Evidence

موارد Android واقعی:

- RTL
- Swipe
- Notification
- Widget
- Jalali Picker
- Keyboard
- Back
- Layout
- Screenshot
- Persistence
- Android Behavior

فقط با CI درباره رفتار دستگاه واقعی نتیجه‌گیری نشود.

بدون شواهد لازم:

> **«تکمیل شد» اعلام نشود.**

---

## 22. Failure Classification

هر Failure ابتدا دسته‌بندی شود:

**Product Failure:** مشکل محصول → اصلاح محصول.

**Factory Failure:** مشکل CI/Worker/Script/Automation → اصلاح Factory.

**Transient Failure:** خطای موقت → Retry کنترل‌شده.

هرگز:

- Duplicate Worker
- Merge اجباری
- نادیده گرفتن Failure

انجام نشود.

---

## 23. AI / Worker Failure

خطای Worker یا AI به‌تنهایی شکست محصول نیست.

در خطای موقت:

- Lease آزاد شود.
- Retry کنترل‌شده انجام شود.
- Duplicate Worker ایجاد نشود.
- مسیرهای غیرمرتبط متوقف نشوند.
- کارهای deterministic ادامه پیدا کنند.

اگر کار محصول مستقل از Factory قابل انجام است:

> **کار محصول متوقف نشود.**

---

## 24. Merge

PR فقط به دلیل سبز بودن یک Job یا کارخانه Merge نشود.

Merge بر اساس:

> **Code + Test + CI + Evidence + Product State**

انجام شود.

---

## 25. Auto-Close

بسته شدن Issue اثبات تکمیل محصول نیست.

Issue فقط وقتی بسته شود که:

- Acceptance کامل باشد.
- Dependencies کامل باشند.
- Evidence معتبر وجود داشته باشد.
- رفتار واقعی محصول تأیید شده باشد.

---

## 26. معماری پرریسک

برای تغییرات پرریسک ابتدا بررسی عمیق:

- Migration
- Storage
- Database
- Core Architecture
- Model اصلی
- حذف مسیر قدیمی
- تغییر بنیادی Home
- CI مرکزی
- Worker / Orchestrator
- Release Pipeline

اما بررسی معماری برای کار ساده نباید به گلوگاه دائمی تبدیل شود.

> **سرعت تابع ایمنی معماری است.**

---

## 27. Simplification کارخانه

اگر Factory بلااستفاده، Duplicate، بدون خروجی مصرف‌شده، هم‌پوشان، صرفاً گزارش‌ساز، پرهزینه بدون افزایش پوشش یا صرفاً پیچیده‌کننده است، گزینه‌ها بررسی شوند:

> **حذف → ادغام → سبک‌سازی → غیرفعال‌سازی**

---

## 28. Evidence First

بدون شواهد معتبر از عبارات زیر استفاده نشود:

- کامل شد
- حل شد
- Release-Ready شد
- CI سبز است
- Test موفق است
- Build موفق است
- Device Test موفق است
- Migration موفق است
- داده‌ها سالم‌اند

به‌جای آن:

> **وضعیت واقعی + Commit + Workflow/PR + Artifact + محدودیت شواهد**

---

## 29. چرخه اجباری «ادامه یادنگار»

هر بار فرمان **ادامه یادنگار** دریافت شد:

1. وضعیت واقعی GitHub دریافت شود.
2. HEAD واقعی تعیین شود.
3. تغییرات جدید بررسی شود.
4. کارهای باقی‌مانده شناسایی شوند.
5. Duplicate Work حذف شود.
6. Dependencies مشخص شوند.
7. Product Blockerها مشخص شوند.
8. Factory Blockerها مشخص شوند.
9. P0 تا P3 تعیین شود.
10. کارها به Laneهای مستقل تقسیم شوند.
11. Laneهای مستقل موازی اجرا شوند.
12. کارهای وابسته اجرا شوند.
13. Validation لازم انجام شود.
14. Failureها بررسی شوند.
15. Product Evidence بررسی شود.
16. Data Safety Evidence بررسی شود.
17. Release Evidence بررسی شود.
18. نتیجه ضروری در GitHub ثبت شود.
19. گلوگاه‌های غیرضروری Factory حذف یا سبک شوند.
20. مهم‌ترین گام بعدی اجرا شود.

---

## 30. گزارش نهایی

گزارش هر اجرا حداکثر سه بخش داشته باشد:

### 1. وضعیت واقعی

یادنگار دقیقاً کجاست؟

### 2. اجرای واقعی

چه چیزی واقعاً انجام شد یا در حال اجراست؟

### 3. گام بعدی

مهم‌ترین کار بعدی یا مانع چیست؟

گزارش باید کوتاه باشد و جای اجرای واقعی را نگیرد.

---

# معیار نهایی

هدف:

> **یادنگار یک محصول واقعی Android، مستقل، پایدار، قابل استفاده، قابل آزمایش، قابل بازیابی و آماده انتشار باشد.**

نه کارخانه بزرگ، پیچیده و صرفاً سبز.

بنابراین:

> **Product Health > Factory Health**

و:

> **Data Safety + Product Quality + Release Evidence**

همیشه بر زیباسازی یا پیچیده‌سازی کارخانه مقدم است.

---

# اصل نهایی

> **PRODUCT FIRST**  
> **FACTORY MINIMAL**  
> **DATA SAFE**  
> **EVIDENCE BASED**  
> **RELEASE FOCUSED**

کارخانه فقط به اندازه‌ای ساخته و نگهداری شود که یادنگار را بهتر، امن‌تر، قابل‌آزمایش‌تر، قابل‌بازیابی‌تر و قابل‌انتشارتر کند.

هر چیزی فراتر از این باید دلیل واقعی داشته باشد.

---

# وضعیت و ماندگاری فرمان

این سند، **قرارداد اجرایی دائمی پروژه در GitHub** است.

هر بار کاربر در یک گفت‌وگوی جدید، صفحه جدید یا نشست جدید عبارت:

> **ادامه یادنگار**

را بیان کند، این سند باید به‌عنوان قرارداد اجرایی YadNegar از GitHub بازیابی و مبنای کار قرار گیرد.

**منبع ماندگار قرارداد:**

`docs/YADNEGAR_CONTINUE_COMMAND.md` در شاخه `main`

GitHub منبع حقیقت پروژه است؛ این سند نیز مرجع ماندگار رفتار اجرایی «ادامه یادنگار» است.

---

## فرمان فعال

> **ادامه یادنگار**

یعنی:

```
GitHub واقعی
      ↓
تشخیص
      ↓
اولویت محصول
      ↓
اجرای واقعی
      ↓
موازی‌سازی لازم
      ↓
تست
      ↓
شواهد
      ↓
ساده‌سازی Factory
      ↓
ادامه
```

### هدف نهایی همیشه خود یادنگار است، نه کارخانه.

> **PRODUCT FIRST + FACTORY MINIMAL — ALWAYS**
