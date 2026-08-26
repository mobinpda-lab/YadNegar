# YADNEGAR PROJECT OPERATING PACKAGE v1.0
## مرجع عملیاتی واحد پروژه یادنگار

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology Target:** Flutter / Dart  
**Architecture Target:** Clean Architecture + Feature-Based Architecture + RTL Persian UI  
**Reality Authority:** GitHub Repository State  
**Status:** Canonical operational reference

## 0. اصول غیرقابل مذاکره
1. GitHub مرجع عملیاتی حقیقت برای کد، Branch، Commit، PR، Workflow، CI و مستندات است.
2. این سند مرجع فعال قواعد توسعه یادنگار است. Snapshotها و گزارش‌های گفتگو جایگزین Audit واقعی Repository نیستند.
3. هدف، تولید نرم‌افزار سالم و قابل‌استفاده در ساعت‌ها به‌جای روزهاست؛ سرعت از موازی‌سازی، حذف انتظار و جلوگیری از دوباره‌کاری می‌آید، نه از حذف کنترل کیفیت.
4. کارهای مستقل به‌صورت موازی انجام می‌شوند؛ کار سریالی فقط در صورت وجود وابستگی واقعی مجاز است.
5. هیچ تغییر، تست، Build، Workflow یا Commit موفق تلقی نمی‌شود مگر مدرک مستقیم از همان Ref/Commit وجود داشته باشد.
6. قابلیت یا ساختار موجود قبل از ایجاد نمونه جدید بررسی می‌شود. Model، Repository، Storage، Workflow یا Foundation موازی بدون دلیل معماری ایجاد نمی‌شود.
7. تغییرات کوچک، قابل Review و قابل Rollback باشند.
8. توسعه عادی و پرریسک مستقیماً روی `main` انجام نشود؛ Branch/PR مسیر پیش‌فرض است.
9. معماری فقط پس از Audit و بررسی اثر تغییر می‌کند.
10. مستندات بخش مهندسی پروژه‌اند و باید همراه تغییرات مهم به‌روز شوند.

## 1. مدل مرجع حقیقت
ترتیب اعتبار منابع:

`GitHub Reality > ADR/Architecture Decision Approved > این سند Canonical > مستندات جاری و اجرایی > حافظه/گفتگو`

اگر دو منبع اختلاف داشتند:
`Verify GitHub → مشخص‌کردن اختلاف → اصلاح سند جاری → حفظ سوابق تاریخی`

## 2. پروتکل شروع و ادامه کار
هر Session یا ادامه‌ی مهم با این چرخه آغاز می‌شود:

`Observe → Audit → Understand → Plan → Parallelize → Execute → Validate → Document → Report`

پیش از تغییر باید بررسی شود:
- دسترسی واقعی GitHub: Read / Write / Actions
- Repository و Branch واقعی
- HEAD فعلی `main`
- Commitهای اخیر
- PRهای باز و Head دقیق آن‌ها
- Workflow و نتیجه CI برای Ref دقیق
- ساختار واقعی پروژه و فایل‌های موجود
- معماری و مستندات فعال
- کارهای در حال انجام و ریسک تداخل
- پیش‌نیازها و روش Validation

شروع از حافظه بدون Audit ممنوع است.

## 3. Trigger «ادامه یادنگار»
عبارت `ادامه یادنگار` یک دستور اجرایی است.

با دریافت آن:
1. GitHub زنده بررسی شود.
2. این سند و Current State خوانده شود.
3. نزدیک‌ترین Gap واقعی و ناتمام از Repository انتخاب شود.
4. کارهای مستقل تا حد امن موازی شوند.
5. تغییر کم‌ریسک و مشخص در Branch مناسب اجرا شود.
6. Analyze/Test/Build/Workflow حسب مورد بررسی شود.
7. نتیجه با مدرک گزارش و وضعیت جاری مستند شود.

این Trigger اجازه حدس، حذف تست، بازنویسی مخرب یا تغییر معماری بدون Audit را نمی‌دهد.

## 4. مدل توسعه موازی
سه Workstream اصلی پروژه:

### Lane A — Core / Domain / Foundation
مسئولیت:
- Foundation پروژه Flutter
- Domain entities/value objects
- Repository contracts
- Business rules
- Storage abstractions
- Shared utilities
- Architecture boundaries

### Lane B — UI / Feature
مسئولیت:
- RTL فارسی
- App Shell و Navigation
- Timeline
- Quick Capture
- صفحات و Featureهای کاربردی
- Accessibility و UX روزمره

### Lane C — CI / Automation / Documentation
مسئولیت:
- GitHub Actions
- Analyze/Test/Build
- Automation
- Quality gates
- مستندسازی
- Current-state و Handoff records

اگر دو Lane روی Foundation یا فایل مشترک تداخل ندارند، باید همزمان پیش بروند. یک Lane مسدود نباید Lane مستقل دیگر را متوقف کند.

## 5. مرزهای موازی‌سازی
پیش از اجرای همزمان بررسی شود:
- فایل‌های مشترک
- Interface/Contract مشترک
- مدل داده و Migration
- Storage و Persistence
- App Shell/Navigation foundation
- Workflowهای مشترک
- Branch/PRهای فعال

قاعده:
`Detect Conflict → Assign Ownership → Execute Without Overlap → Validate → Integrate`

## 6. مسیرهای تغییر
### Fast Path
برای تغییر کوچک و کم‌ریسک:
`Audit → Change → Focused Validation → Evidence → PR/Review → Merge`

### Parallel Feature Path
برای چند کار مستقل:
`Decompose → Define Boundaries → Execute Concurrently → Validate Independently → Integrate → Review`

### Foundation Path
برای معماری، Storage، Migration، Security یا تغییرات Cross-Feature:
`Audit → Impact Review → Design/ADR if needed → Implement → Recovery/Migration Plan → Validate → CI → Review → Document`

همیشه سریع‌ترین مسیر امن انتخاب شود، نه سریع‌ترین مسیر بدون کنترل.

## 7. Definition of Ready
کار زمانی Ready است که موارد زیر روشن باشند:
- خروجی موردنیاز
- دلیل و ارزش آن
- وضعیت موجود
- Scope و Boundary
- وابستگی‌ها
- Branch هدف
- روش Validation
- Evidence موردنیاز
- Integration point

ابهام کوچک نباید پروژه را متوقف کند؛ اما ابهام معماری یا داده‌ای باید قبل از تغییر پرریسک حل شود.

## 8. Definition of Done
یک Task فقط زمانی Done است که موارد قابل‌اعمال کامل باشند:

`Implementation + Validation + Evidence + Documentation + Safe Integration`

برای Product work معمولاً:
`Working Software + Tests + Analyze + Build/CI Evidence + Review + Merge`

نوشتن فایل به‌تنهایی تحویل محسوب نمی‌شود.

## 9. معماری هدف
هدف معماری یادنگار:
- Flutter / Dart
- Clean Architecture
- Feature-Based Architecture
- Domain مستقل از Infrastructure تا حد منطقی
- Dependency direction کنترل‌شده
- Shared foundation پایدار
- Persian RTL-first UI

این موارد «Target» هستند و فقط وقتی Implementation واقعی در GitHub وجود داشته باشد می‌توان آن‌ها را وضعیت فعلی دانست.

## 10. حوزه محصول
یادنگار برای ثبت و مرور سریع اطلاعات روزمره با محور Timeline طراحی می‌شود.

حوزه‌های اولیه محصول:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت روزانه
- Timeline
- ثبت سریع (Quick Capture)
- تاریخ و زمان
- جستجو/فیلتر در مرحله مناسب

هر Feature جدید باید قبل از ایجاد مدل یا Storage مستقل، با Foundation مشترک تطبیق داده شود.

## 11. UI و تجربه کاربری
اصول UI:
- فارسی و RTL-first
- ساده، سریع و کم‌اصطکاک
- مناسب ثبت روزمره
- سلسله‌مراتب بصری آرام
- Navigation قابل پیش‌بینی
- Timeline به‌عنوان محور تجربه اصلی
- عدم ایجاد بدهی معماری برای رسیدن سریع به ظاهر

تغییر گسترده UI قبل از Foundation نباید قراردادهای معماری ناپایدار بسازد.

## 12. Data / Storage Governance
تا زمانی که Storage واقعی انتخاب و پیاده‌سازی نشده است، هیچ فناوری ذخیره‌سازی به‌عنوان تصمیم قطعی ثبت نمی‌شود.

هر تغییر آینده در Schema/Storage باید حسب مورد شامل این موارد باشد:
`Versioning + Migration Path + Backward Compatibility + Validation + Recovery/Rollback`

داده موجود کاربر نباید برای ساده‌سازی توسعه حذف یا بازنویسی مخرب شود.

## 13. CI و Quality
زنجیره هدف Validation برای Flutter:

`flutter pub get → flutter analyze → flutter test → flutter build`

در مراحل بعد، حسب نیاز:
- Unit tests
- Widget tests
- Integration tests
- RTL checks
- Golden tests برای UI حساس
- Performance checks
- Migration tests

GitHub Actions مدرک رسمی Repository است. اجرای محلی Feedback سریع است و جای Evidence مربوط به Ref دقیق را نمی‌گیرد.

Workflow موفق Placeholder به معنی Validation واقعی Flutter نیست.

## 14. Git و PR Governance
- Branch کوچک و هدفمند
- Commit کوچک و تک‌منظوره
- عدم Force update در روند عادی
- عدم Rewrite تاریخچه بدون ضرورت و تصمیم روشن
- PR با Scope مشخص
- Validation قبل از Merge
- Merge فقط وقتی Head دقیق بررسی شده باشد
- بازنویسی تغییر موجود بدون Audit ممنوع

## 15. مستندسازی
طبقه‌بندی مستندات:
1. **Canonical Governance:** قواعد عملیاتی پروژه؛ همین سند.
2. **Current-State Records:** Snapshot دقیق و تاریخ‌دار وضعیت واقعی.
3. **Architecture/ADR:** تصمیمات معماری تأییدشده.
4. **Product/Feature Records:** نیازها، قرارداد و Evidence هر Feature.
5. **Historical Records:** Auditهای قدیمی، Handoffها و سوابق تکامل.

هیچ سند فعال دیگری نباید مرجع Governance موازی با این سند ایجاد کند.

## 16. Continuity / AI Handoff
دانش پروژه باید مستقل از پایان یک گفتگو باقی بماند.

ترتیب ادامه:
`Read Canonical → Read Current State → Audit GitHub → Check Active Work → Check Decisions/Risks → Continue`

دانشی که فقط در Conversation باشد، مرجع عملیاتی امن محسوب نمی‌شود.

## 17. Evidence و گزارش
هر تغییر مهم باید Trace داشته باشد:

`Requirement → Change → Commit → Validation → Evidence → Documentation → Integration`

گزارش مدیریتی ترجیحاً شامل این موارد است:
`کجا هستیم | چه انجام شد | وضعیت | مدرک | مانع/ریسک | قدم بعد`

برچسب‌ها:
- **واقعیت:** مستقیم Verify شده
- **برنامه:** اقدام بعدی
- **مسدود:** وابستگی واقعی مانع است
- **نیاز به تصمیم:** تصمیم Owner لازم است

Inference نباید به‌عنوان Fact گزارش شود.

## 18. مرز تصمیم AI
AI می‌تواند کارهای Routine، کم‌ریسک، قابل Rollback و دارای Scope روشن را اجرا کند.

برای موارد زیر باید احتیاط ویژه و در صورت نیاز تصمیم Owner گرفته شود:
- تغییر جهت محصول
- تغییر عمده معماری
- Migration مخرب
- ریسک از دست‌رفتن داده
- تغییر امنیتی مهم
- بازطراحی گسترده UI
- Release behavior برگشت‌ناپذیر

## 19. Reliability و Recovery
برای تغییرات مهم:
`Detect → Classify → Contain → Recover → Validate → Document → Improve`

Rollback باید در طراحی تغییرات مهم در نظر گرفته شود. Backup بدون تست Recovery مدرک کافی برای قابلیت بازیابی نیست.

## 20. فرمول نهایی توسعه
**Fast Delivery = Parallel Independent Work + Automation + Fast Feedback + Controlled Integration + Evidence + Documentation**

**Professional Delivery = Speed + Quality + Architecture + Recovery + Traceability**

هدف نهایی: ساخت یادنگار واقعی، تمیز، قابل‌توسعه و قابل‌نگهداری، با خروجی معتبر در ساعت‌ها به‌جای روزها.

## 21. قانون Canonical
مسیر Canonical این سند:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

نسخه فعلی: `v1.0`

اگر وضعیت Implementation با این سند اختلاف داشت، GitHub برای واقعیت Implementation مقدم است و Current-State/این سند باید در بخش مربوط اصلاح شوند.
