# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.0 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Product Direction:** Persian RTL, Timeline-oriented personal memory/activity capture  
**Technology Target:** Flutter / Dart  
**Architecture Target:** Clean Architecture + Feature-Based Architecture  
**Reality Authority:** GitHub Repository State  
**Canonical Governance:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

---

## 1. هدف این سند
این سند تصویر جامع پروژه یادنگار را در یک نقطه جمع می‌کند: هویت محصول، وضعیت واقعی Repository، معماری هدف، شیوه توسعه، برنامه موازی، CI و GitHub Automation، کنترل کیفیت، مستندسازی، Release و تداوم بین Sessionهای AI.

این سند جایگزین GitHub Reality نیست. هر ادعای «وضعیت فعلی» باید با Repository و Ref دقیق Verify شود.

ترتیب اعتبار:

`GitHub Reality > Approved ADR/Architecture Decisions > Canonical Operating Package > Comprehensive Project Document > Current-State/Handoff > Conversation Memory`

---

## 2. وضعیت واقعی Verify‌شده در 2026-08-26
در زمان تدوین این نسخه، `main` مجدداً بررسی شد.

### Repository
- Repository: `mobinpda-lab/YadNegar`
- Default branch: `main`
- دسترسی متصل GitHub: Read/Write فعال
- Repository عمومی و قابل Push است.

### HEAD تأییدشده main
- SHA: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Message: `ci: add initial build workflow skeleton`
- Date: 2026-08-17

### ساختار Root تأییدشده main
در Snapshot فوق فقط موارد زیر در Root وجود داشت:
- `.github/`
- `README.md`

در `main` تأییدشده موارد زیر وجود نداشت:
- `pubspec.yaml`
- `lib/`
- `test/`

**نتیجه:** Flutter Foundation هنوز در `main` ایجاد نشده است. هر سندی که Flutter/Clean Architecture را ذکر می‌کند، در حال حاضر «هدف» را بیان می‌کند نه Implementation موجود را.

### CI تأییدشده
Workflowهای موجود:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

هر دو Placeholder هستند و فقط Checkout + Echo اجرا می‌کنند. Runهای آن‌ها موفق بوده‌اند، اما این موفقیت فقط Placeholder را اثبات می‌کند و معادل `flutter analyze/test/build` نیست.

---

## 3. وضعیت کار مستندسازی جاری
برای جلوگیری از تغییر مستقیم روی `main`، Branch زیر ایجاد شده است:

`docs/yadnegar-documentation-baseline`

PR فعال:

`#3 — docs: establish YadNegar canonical project documentation`

این PR فقط Documentation/README را تغییر می‌دهد و هیچ کد برنامه یا رفتار Workflow را تغییر نمی‌دهد.

مستندات فعال این Branch:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`
- `docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md`
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `PROJECT_DOCUMENTATION_FA.md`
- `docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md`

---

## 4. هویت و مأموریت محصول
یادنگار یک اپلیکیشن فارسی، سریع و کم‌اصطکاک برای ثبت و مرور چیزهایی است که کاربر در طول روز نمی‌خواهد فراموش کند.

محور تجربه:

`Capture quickly → Organize minimally → Review through Timeline → Find later`

گروه‌های اصلی محتوای هدف:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت روزانه

ارزش اصلی محصول:
- ثبت سریع بدون فرم‌های سنگین
- نمایش زمانی و قابل‌فهم
- فارسی و RTL از پایه
- نگهداری منظم اطلاعات روزمره
- پایه‌ای قابل‌توسعه برای Search، Reminder، Backup و قابلیت‌های بعدی

---

## 5. اصول طراحی محصول
1. **Capture-first:** ثبت باید سریع‌تر از سازمان‌دهی باشد.
2. **Timeline-first:** Timeline نمای اصلی مرور رخدادهای روزانه است.
3. **Low friction:** تعداد Tap و تصمیم‌های اجباری حداقل باشد.
4. **RTL-native:** RTL یک Patch نهایی نیست؛ بخشی از Foundation UI است.
5. **Progressive complexity:** قابلیت‌های پیچیده فقط بعد از تثبیت Core اضافه شوند.
6. **No fake structure:** Feature یا مدل خالی فقط برای پرکردن معماری ساخته نشود.
7. **Offline-ready by design:** تصمیم Persistence باید امکان استفاده روزمره بدون وابستگی دائمی به شبکه را در نظر بگیرد.
8. **Recoverable data:** هر تصمیم Storage باید Migration/Backup/Recovery آینده را ممکن نگه دارد.

---

## 6. Scope اولیه محصول
### Core MVP واقعی
- اجرای سالم Flutter app
- App Shell فارسی/RTL
- ثبت سریع یک Timeline Item
- ذخیره محلی معتبر
- Timeline مرتب‌شده بر اساس زمان
- مشاهده جزئیات
- ویرایش
- حذف امن/قابل‌کنترل
- تست‌های پایه
- CI واقعی

### Feature Expansion
پس از Core:
- Note
- Event
- Call
- Idea
- Daily Activity
- Search/Filter
- Tags/Categories در صورت نیاز واقعی
- Reminder/Notification در صورت تعریف Contract روشن
- Backup/Restore
- Export/Share در مرحله مناسب

Featureهای آینده نباید باعث ایجاد Storage یا Domain foundation موازی شوند.

---

## 7. معماری هدف
### جهت وابستگی

`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

### ساختار هدف اولیه
```text
lib/
  app/
    app.dart
    routing/
    theme/
  core/
    error/
    time/
    utils/
  features/
    timeline/
      domain/
      application/
      data/
      presentation/
    capture/
      ...
test/
```

این ساختار یک هدف است. Foundation اولیه باید کوچک بماند و فقط پوشه‌هایی ایجاد شوند که استفاده واقعی دارند.

### قوانین معماری
- Domain به UI/Storage وابستگی مستقیم نداشته باشد.
- Repository interface در Boundary مناسب تعریف شود.
- Implementation ذخیره‌سازی بیرون Domain باشد.
- Shared Core کوچک و با مسئولیت روشن بماند.
- هیچ Service عمومی بدون مصرف واقعی ساخته نشود.
- Featureها از Shared Foundation استفاده کنند، نه Foundation موازی.

---

## 8. قرارداد مفهومی Timeline Item
Schema نهایی هنوز تصمیم تأییدشده نیست؛ با این حال مدل مفهومی باید امکان این مفاهیم را بدهد:
- `id`
- `type`
- `title/text`
- `createdAt`
- `occurredAt/scheduledAt` در صورت نیاز
- metadata خاص Feature
- lifecycle/status در صورت نیاز واقعی

قاعده مهم:
از ساخت پنج مدل کاملاً جدا برای Note/Event/Call/Idea/Activity قبل از مشخص‌شدن اشتراک واقعی آن‌ها خودداری شود. ابتدا Contract مشترک Timeline Item بررسی شود، سپس Extensionهای Feature طراحی شوند.

---

## 9. Persistence Strategy
در Snapshot فعلی هیچ Persistence واقعی وجود ندارد و فناوری نهایی انتخاب نشده است.

انتخاب Storage باید بر اساس Audit و معیارهای زیر انجام شود:
- query مناسب Timeline
- Migration
- local/offline behavior
- testability
- performance در حجم روزمره
- search/filter support
- Backup/Restore
- platform compatibility
- maintenance cost

هیچ پکیج یا Database صرفاً بر اساس محبوبیت انتخاب نشود.

### Contract ایمنی داده
هر تغییر Schema در آینده حسب مورد باید داشته باشد:
`Schema Version + Migration Path + Backward Compatibility + Validation + Recovery/Rollback`

---

## 10. UI/UX Contract
### اصول
- فارسی و RTL از اولین Screen
- Material با شخصی‌سازی کنترل‌شده
- hierarchy آرام و کم‌نویز
- ثبت سریع در دسترس
- Timeline قابل اسکن
- تاریخ/زمان خوانا
- رفتارهای ثابت و قابل‌پیش‌بینی
- Accessibility پایه

### Surfaceهای اولیه
- App Shell
- Timeline Screen
- Quick Capture
- Item Card
- Item Detail/Edit
- Empty/Loading/Error states
- Settings پایه در زمان نیاز

### ضد بدهی UI
UI mock بزرگ قبل از Domain/Foundation ساخته نشود. در عین حال UI مستقل مثل Theme/RTL shell می‌تواند پس از Flutter bootstrap و با Boundary روشن موازی پیش برود.

---

## 11. مدل تولید نرم‌افزار: ساعت‌ها به‌جای روزها
هدف پروژه صف خطی نیست؛ یک Software Production System است.

فرمول:

`Audit → Decompose → Identify Dependencies → Parallel Workstreams → Fast Feedback → Evidence → Controlled Integration`

سرعت از این موارد می‌آید:
- کارهای مستقل همزمان
- PRهای کوچک
- reuse
- automation
- cancel کردن CI قدیمی
- testهای focused برای Fast Lane
- Full Gate فقط در نقطه مناسب
- ثبت تصمیم و وضعیت همزمان با کار

سرعت از این موارد **نمی‌آید**:
- حذف تست
- Commit مستقیم پرریسک روی main
- ساخت Feature موازی تکراری
- merge بدون evidence
- پنهان‌کردن failure
- بازنویسی تاریخچه

---

## 12. Workstream Governance
### Lane A — Foundation / Core / Domain
خروجی‌ها:
- Flutter bootstrap
- dependency baseline
- app entry
- Domain contracts
- Timeline Item contract
- Persistence boundary
- core tests

### Lane B — UI / Feature
خروجی‌ها:
- RTL shell
- theme
- Timeline presentation
- Quick Capture UI
- Item screens

### Lane C — CI / Automation / Documentation
خروجی‌ها:
- Fast Lane workflow
- Full Build workflow
- concurrency policy
- test/analyze automation
- PR/Issue discipline
- Current State/Handoff updates
- evidence records

### قانون استقلال
هر Lane باید Scope، فایل‌ها، dependency، branch و validation روشن داشته باشد. Lane مسدود، Lane مستقل را متوقف نمی‌کند.

---

## 13. GitHub Operating Model
### Branching
- `foundation/**` برای Foundation
- `feature/**` برای Feature
- `ui/**` برای UI مستقل
- `ci/**` برای Automation
- `docs/**` برای Documentation
- `fix/**` برای اصلاحات

نام Branch قرارداد مطلق نیست، اما Scope باید واضح باشد.

### PR
هر PR:
- یک هدف اصلی
- Diff کوچک
- توضیح Scope
- Validation/Evidence
- ریسک/rollback در صورت نیاز
- عدم مخلوط‌کردن معماری + UI + CI نامرتبط

### Main
`main` باید تا حد امکان فقط از طریق PRهای Validate‌شده تغییر کند.

---

## 14. GitHub Automation Target
تجربه موفق Arvin به یادنگار با تطبیق، نه Copy کور، منتقل می‌شود.

### Fast Lane
پس از Flutter Foundation:
- Trigger روی PR و Branchهای کاری
- `concurrency` بر اساس Branch/PR
- `cancel-in-progress: true`
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- در صورت رشد تست‌ها، Matrix بر اساس Surfaceهای مستقل

هدف: feedback سریع و جلوگیری از مصرف زمان روی Runهای قدیمی.

### Full Gate
برای PR آماده Merge و Push به main:
- dependencies
- analyze
- full tests
- build target
- verify artifact
- upload artifact در مرحله مناسب

### Documentation Automation
در مرحله بعد:
- validate links/required docs
- check Current-State freshness rules در صورت ارزش واقعی
- progress score فقط وقتی Definition-of-Done قابل‌اندازه‌گیری باشد

اتوماسیون نباید قبل از وجود ورودی واقعی به نمایش مصنوعی کیفیت تبدیل شود.

---

## 15. CI Evidence Policy
CI فقط برای SHA دقیق معتبر است.

گزارش صحیح:
- `Analyze passed on <sha>`
- `Tests passed on <sha>`
- `Build passed on <sha>`

گزارش غیرمجاز:
- «CI سبز است» وقتی فقط Placeholder اجرا شده است.
- نسبت‌دادن Run یک Commit به Commit دیگر.

---

## 16. Definition of Ready
Task زمانی Ready است که:
- خروجی مشخص باشد
- وضعیت موجود Audit شده باشد
- Scope روشن باشد
- Dependency معلوم باشد
- فایل/Boundary مشخص باشد
- Validation تعریف شده باشد
- integration point معلوم باشد

---

## 17. Definition of Done
برای کار محصول، حسب مورد:

`Implementation + Unit/Widget Test + Analyze + Integration Check + Build/CI + Evidence + Documentation + Review + Merge`

Code written ≠ Done.

Documentation written ≠ Done تا وقتی در GitHub ثبت/Review نشده باشد.

---

## 18. Documentation-as-Code
مستندسازی باید همزمان و موازی با کار عملی انجام شود.

### Canonical
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

### Comprehensive
`docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

### Operational Plan
`docs/YADNEGAR_ACCELERATED_OPERATION_PLAN_FA.md`

### Current State
`docs/AI_CONTINUATION_STATE.md`

### Handoff
`docs/AI_HANDOFF_CURRENT_FA.md`

### Technical/Product Detail
`PROJECT_DOCUMENTATION_FA.md`

قاعده:
- تاریخچه حفظ شود.
- Current State stale نماند.
- Governance سند موازی متعدد تولید نکند.
- Feature docs فقط وقتی ارزش واقعی دارند ساخته شوند.

---

## 19. گزارش‌دهی به مالک پروژه
گزارش‌ها کوتاه، غیر فنی و نتیجه‌محور باشند.

قالب استاندارد:

`کجا هستیم | چه انجام شد | وضعیت | مانع/ریسک | قدم بعد`

برچسب‌ها:
- **واقعیت**: Verify شده
- **برنامه**: هنوز اجرا نشده
- **مسدود**: مانع واقعی
- **نیاز به تصمیم**: تصمیم مالک لازم است

جزئیات فنی در GitHub باقی می‌ماند مگر برای تصمیم کاربر ضروری باشد.

---

## 20. Failure / Recovery
چرخه استاندارد:

`Detect → Classify → Contain → Recover → Validate → Document → Improve`

برای تغییرات Foundation/Data:
- rollback روشن
- migration/recovery consideration
- عدم overwrite مخرب
- حفظ تاریخچه

---

## 21. Release Governance
پس از رسیدن به مرحله Build واقعی:

`Development → Validation → Release Candidate → Approval → Artifact → Smoke Test → Release → Monitor`

Release باید Ref/Version/Evidence روشن داشته باشد.

---

## 22. ریسک‌های فعلی پروژه
### R1 — Foundation هنوز وجود ندارد
اثر: تمام Feature/CI واقعی به آن وابسته‌اند.  
اقدام: Flutter bootstrap کمینه اولین مسیر کدنویسی باشد.

### R2 — CI فعلی ظاهر سبز ولی Placeholder است
اثر: امکان برداشت اشتباه از کیفیت.  
اقدام: مستندسازی صریح فعلی + تبدیل به CI واقعی فقط پس از Foundation.

### R3 — Over-engineering قبل از اولین Vertical Slice
اثر: تأخیر و دوباره‌کاری.  
اقدام: ساخت کمترین Foundation لازم، سپس یک Slice واقعی Capture→Store→Timeline.

### R4 — تداخل Workstreamها
اثر: Merge conflict و دوباره‌کاری.  
اقدام: Ownership فایل/Foundation و PR کوچک.

### R5 — اسناد stale
اثر: AI Session بعدی از وضعیت غلط ادامه می‌دهد.  
اقدام: Current State در هر Merge مهم به‌روزرسانی شود.

---

## 23. Roadmap سطح بالا
### Wave 0 — Governance & Documentation Baseline
- Canonical docs
- comprehensive doc
- current state
- handoff
- operational plan

### Wave 1 — Flutter Foundation
- minimal Flutter project
- baseline app/test
- dependency resolution

### Wave 2 — Parallel Foundation Expansion
Lane A: Timeline/Domain contract  
Lane B: RTL App Shell  
Lane C: Fast Lane CI + Full Gate

### Wave 3 — First Vertical Slice
`Quick Capture → Persist → Timeline → Edit`

### Wave 4 — Item Types
Note / Event / Call / Idea / Activity بر Foundation مشترک

### Wave 5 — Retrieval & Reliability
Search/Filter + persistence hardening + migration tests

### Wave 6 — Reminder / Backup / Export
فقط پس از تثبیت Contractهای قبلی

### Wave 7 — Release Readiness
E2E + artifact + smoke + recovery + release documentation

---

## 24. معیار موفقیت نسخه اولیه قابل‌استفاده
- برنامه Flutter واقعی اجرا شود.
- UI فارسی RTL باشد.
- کاربر در چند ثانیه Item ثبت کند.
- Item بعد از بسته/باز شدن باقی بماند.
- Timeline درست نمایش دهد.
- ویرایش درست کار کند.
- تست‌های Core و UI کلیدی سبز باشند.
- CI واقعی روی SHA دقیق سبز باشد.
- Build قابل نصب تولید شود.
- Current State و Handoff با همان وضعیت همگام باشند.

---

## 25. پروتکل «ادامه یادنگار»
وقتی کاربر می‌گوید:

`ادامه یادنگار`

معنی اجرایی:
1. Verify GitHub access.
2. Verify `main` HEAD.
3. Verify open PRs and active branches.
4. Verify exact workflow evidence.
5. Read Canonical + Current State + Operational Plan.
6. Audit existing implementation.
7. Select nearest real unfinished work.
8. Parallelize independent lanes.
9. Execute low-risk reversible work.
10. Validate.
11. Update documentation/evidence.
12. Commit/PR.
13. Report briefly and non-technically.

---

## 26. اصل نهایی
**کار واقعی، نه گزارش‌سازی.**

**موازی، هماهنگ و سریع، بدون حذف کنترل کیفیت.**

**مستندسازی همزمان با Implementation.**

**GitHub Automation برای کاهش زمان انتظار، نه برای نمایش مصنوعی پیشرفت.**

**GitHub Reality همیشه بالاتر از حافظه و Snapshot است.**
