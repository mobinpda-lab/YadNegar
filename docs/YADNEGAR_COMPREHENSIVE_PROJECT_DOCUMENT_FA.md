# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.1 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Product Direction:** Persian RTL, Timeline-oriented personal memory/activity capture  
**Technology:** Flutter / Dart  
**Architecture Target:** Clean Architecture + Feature-Based Architecture  
**Reality Authority:** GitHub Repository State  
**Canonical Governance:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
**Current Execution Plan:** `docs/YADNEGAR_OPERATION_PLAN.md`

---

## 1. هدف این سند
این سند تصویر جامع و متمرکز YadNegar را نگه می‌دارد: محصول، وضعیت واقعی GitHub، معماری، مسیرهای توسعه، CI و Automation، مستندسازی، کنترل کیفیت، مدیریت ریسک، Release و روش ادامه توسط AI یا توسعه‌دهنده دیگر.

این سند Snapshot/Reference است؛ جای GitHub Reality را نمی‌گیرد.

ترتیب اعتبار:

`GitHub Reality > Approved ADR/Architecture Decisions > Canonical Operating Package > Comprehensive Project Document > Current State/Handoff > Conversation Memory`

وقتی منابع اختلاف دارند، حدس ممنوع است:

`Verify GitHub → identify discrepancy → update current docs → preserve history`

---

## 2. تجربه‌های قابل انتقال از پروژه Arvin
YadNegar پروژه مستقل است و کد/مدل Arvin نباید بدون Audit وارد آن شود؛ اما چند اصل اجرایی Arvin به‌عنوان تجربه مهندسی منتقل می‌شود:

1. GitHub منبع حقیقت، نه حافظه گفتگو.
2. هر Session مهم با Audit واقعی شروع شود.
3. Workstreamهای مستقل به‌صورت موازی اجرا شوند.
4. Fast Lane CI برای بازخورد سریع و Full Gate برای Integration/Build از هم جدا شوند.
5. Runهای stale با `concurrency/cancel-in-progress` متوقف شوند.
6. Evidence فقط برای SHA دقیق معتبر است.
7. قابلیت موجود قبل از ساخت نمونه جدید Audit شود.
8. مستندسازی همزمان با Implementation انجام شود.
9. یک Canonical governance فعال وجود داشته باشد و اسناد رقیب ساخته نشوند.
10. Progress از Working Software و Definition of Done محاسبه شود، نه تعداد Commit/PR.
11. PRها کوچک، قابل Review و قابل Rollback باشند.
12. یک Lane مسدود نباید Lane مستقل دیگر را متوقف کند.

### چیزی که از Arvin کپی نمی‌شود
- مدل محصول
- Storage contract
- Feature list
- UI contract اختصاصی
- Backup/Sync implementation
- Workflow خاصی که به ساختار فعلی YadNegar نمی‌خورد

اصل انتقال:
`Reuse execution lessons, not unverified implementation assumptions.`

---

## 3. وضعیت واقعی Verify‌شده در 2026-08-26
### Repository و main
- Repository: `mobinpda-lab/YadNegar`
- Default branch: `main`
- دسترسی GitHub متصل: Read/Write
- `main` HEAD: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Message: `ci: add initial build workflow skeleton`
- Date: 2026-08-17

### Root فعلی main
در Snapshot تأییدشده:
- `.github/`
- `README.md`

در `main` هنوز وجود ندارد:
- `pubspec.yaml`
- `lib/`
- `test/`

بنابراین Flutter Foundation هنوز روی `main` Merge نشده است.

### Workflowهای فعلی main
- `.github/workflows/build.yml` — Placeholder
- `.github/workflows/test.yml` — Placeholder

این Workflowها فقط Checkout + Echo را اجرا می‌کنند. سبز بودنشان Flutter quality evidence نیست.

---

## 4. وضعیت Pull Requestهای واقعی
### PR #3 — Documentation Baseline
**State:** Open  
**Branch:** `docs/yadnegar-documentation-baseline`  
**Purpose:** Canonical docs + comprehensive reference + current state + handoff + operational plan + README map

این PR باید Documentation/README-only باقی بماند و مسیر Governance پروژه را تثبیت کند.

### PR #2 — Flutter Foundation
**State:** Open / Draft / Mergeable  
**Branch:** `feat/foundation-flutter`  
**Verified Head:** `e614343a80f9c30e7a171ef7aeb1eaebc852a8be`

محتوا:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`
- Flutter app shell فارسی/RTL حداقلی

Exact-head Evidence:
- `flutter pub get`: success
- `flutter analyze`: success
- `flutter test`: success
- `Flutter CI`: success

**مهم:** Build APK/Release برای این Head به‌عنوان Evidence فعلی تأیید نشده است.

### PR #1 — Parallel CI path experiment
PR آزمایشی قدیمی بود و در 2026-08-26 بدون Merge بسته شد؛ چون PR #3 مستندسازی واقعی و PR #2 Flutter CI واقعی را جایگزین آن کردند.

این تاریخچه حفظ می‌شود، اما Workstream فعال نیست.

---

## 5. Work Queue فعال
### Issue #4 — Foundation integration
هدف: Review و Integration PR #2؛ Foundation جدید ساخته نشود.

### Issue #5 — RTL App Shell / Timeline Contract
هدف: توسعه UI بر پایه موجود، بدون `MaterialApp`/Router/Foundation دوم.

### Issue #6 — CI Consolidation
هدف: reuse از Flutter CI موجود و حذف ابهام Placeholderها؛ سپس Fast Lane + Full Gate.

این سه Issue اولین Wave عملیاتی هماهنگ را تشکیل می‌دهند.

---

## 6. هویت و مأموریت محصول
یادنگار اپلیکیشنی فارسی، سریع و کم‌اصطکاک برای ثبت و مرور اطلاعات روزمره است.

چرخه اصلی تجربه:

`Capture quickly → Organize minimally → Review in Timeline → Find/Edit later`

گروه‌های محتوای هدف:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت روزانه

ارزش اصلی:
- ثبت در چند ثانیه
- Timeline واضح
- RTL واقعی
- حداقل فرم و اصطکاک
- ذخیره قابل اعتماد
- قابلیت توسعه بدون بازنویسی Foundation

---

## 7. اصول طراحی محصول
### Capture-first
ثبت سریع بر طبقه‌بندی پیچیده مقدم است.

### Timeline-first
مرور زمانی، ستون اصلی تجربه است.

### RTL-native
RTL از Foundation UI شروع می‌شود، نه Patch نهایی.

### Progressive complexity
Search/Reminder/Backup و قابلیت‌های سنگین بعد از Vertical Slice اصلی.

### Shared foundation
Featureهای Note/Event/Call/Idea/Activity تا حد امکان بر Contract مشترک Timeline سوار شوند.

### No fake architecture
Folder/Service/Repository/Model بدون مصرف واقعی فقط برای «تمیز به نظر رسیدن» ساخته نشود.

### Data recoverability
Storage باید Migration/Backup/Recovery آینده را ممکن نگه دارد.

---

## 8. Scope نسخه اولیه واقعی
نسخه اولیه زمانی معنا دارد که یک Flow واقعی End-to-End کار کند:

`Quick Capture → Local Persistence → Timeline → Detail/Edit`

حداقل قابلیت:
- App اجرا شود.
- فارسی/RTL باشد.
- Item ثبت شود.
- Item بعد از restart باقی بماند.
- Timeline آن را نمایش دهد.
- Edit حفظ شود.
- Test/CI واقعی داشته باشد.

Featureهای متعدد قبل از این Vertical Slice اولویت پایین‌تری دارند.

---

## 9. معماری هدف
### Dependency Direction
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

### ساختار هدف اولیه
```text
lib/
  app/
    app.dart
    theme/
    navigation/
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

این ساختار باید Incremental باشد. پوشه خالی بدون Implementation واقعی ایجاد نشود.

### قوانین
- Domain وابستگی مستقیم به Flutter UI/Storage نداشته باشد.
- Repository contract در Boundary مناسب باشد.
- Data implementation بیرون Domain باشد.
- Shared core کوچک بماند.
- Feature foundation موازی ممنوع مگر ADR.

---

## 10. Foundation موجود در PR #2
PR #2 اولین پایه واقعی Flutter را ایجاد کرده است؛ بنابراین ادامه پروژه باید آن را reuse کند.

### App Shell موجود
- `MaterialApp`
- title فارسی `یادنگار`
- `locale: fa`
- `Directionality` RTL
- Scaffold/Center/Text کمینه

### Test موجود
Smoke/widget test وجود عنوان و Directionality مؤثر RTL را بررسی می‌کند.

### CI موجود
`flutter-ci.yml`:
- Flutter setup
- pub get
- analyze
- test

### قاعده توسعه بعدی
به‌جای ساخت App/CI Foundation جدید:
`Audit PR #2 → integrate → extend`

---

## 11. قرارداد مفهومی Timeline Item
Schema نهایی هنوز تصمیم معماری تأییدشده نیست.

مدل مفهومی باید احتمالاً این مفاهیم را پوشش دهد:
- `id`
- `type`
- `title/text`
- `createdAt`
- `occurredAt/scheduledAt` حسب نوع
- metadata خاص Feature
- lifecycle/status در صورت نیاز

### تصمیم قبل از کدنویسی Persistence
باید بررسی شود:
- یک Shared Timeline Item + Variant؟
- یا Entityهای مستقل با Contract مشترک؟

تا قبل از این تصمیم، Storage schema نباید روی حدس تثبیت شود.

---

## 12. Persistence Strategy
Storage فعلی هنوز روی main وجود ندارد و فناوری نهایی انتخاب نشده است.

معیار تصمیم:
- offline/local reliability
- Timeline queries
- migration
- search/filter
- performance
- testability
- backup/restore
- platform compatibility
- maintenance cost

### Data Safety Contract
هر Schema change مهم حسب مورد:
`Schema Version + Migration Path + Backward Compatibility + Validation + Recovery/Rollback`

---

## 13. UI/UX Contract
### اصول
- فارسی/RTL-first
- hierarchy آرام
- low visual noise
- capture قابل دسترس
- Timeline قابل Scan
- تاریخ/زمان واضح
- Navigation ساده
- Empty/Error/Loading state واقعی
- Accessibility پایه

### Surfaceهای اولیه
- App Shell
- Timeline
- Quick Capture
- Item Card
- Item Detail/Edit
- Settings در زمان نیاز واقعی

### قانون reuse
UI بعدی باید `YadNegarApp` موجود PR #2 را گسترش دهد، نه Foundation دوم بسازد.

---

## 14. مدل تولید نرم‌افزار: ساعت‌ها به‌جای روزها
YadNegar یک صف خطی نیست.

چرخه:

`Audit → Reuse → Decompose → Parallelize → Execute → Fast Feedback → Full Gate → Evidence → Document → Integrate`

سرعت از این‌ها می‌آید:
- کار مستقل همزمان
- PR کوچک
- reuse
- CI سریع
- cancel stale runs
- test focused
- documentation parallel

سرعت از این‌ها نمی‌آید:
- حذف تست
- Merge بی‌Evidence
- کار مستقیم پرریسک روی main
- Feature/Storage موازی تکراری
- بازنویسی تاریخچه

---

## 15. Parallel Workstream Governance
### Lane A — Foundation / Core / Domain
- Foundation integration
- Timeline Item contract
- Repository contract
- Persistence foundation

### Lane B — UI / Product
- RTL shell extension
- Theme
- Timeline UI
- Quick Capture

### Lane C — CI / Automation / Documentation
- CI consolidation
- Fast Lane
- Full Gate
- Artifact validation
- Current State/Handoff

### Rule
- Shared files یک Owner در هر Wave.
- Lane مستقل همزمان.
- Blocked lane دیگران را متوقف نکند.
- Integration point از قبل مشخص شود.

---

## 16. GitHub Branching Model
Branch naming پیشنهادی:
- `foundation/**`
- `core/**`
- `ui/**`
- `feature/**`
- `ci/**`
- `docs/**`
- `fix/**`

Contract اصلی اسم نیست؛ Scope روشن و عدم overlap است.

---

## 17. Pull Request Policy
هر PR:
- یک هدف اصلی
- diff کوچک
- Out-of-scope روشن
- Validation مشخص
- exact-head Evidence
- docs impact
- rollback consideration

PR چندمنظوره Architecture + Feature + CI + UI غیرمرتبط باید Decompose شود.

---

## 18. GitHub Automation Architecture
### Phase 1 — موجود
PR #2 Flutter CI واقعی Analyze/Test دارد.

### Phase 2 — Consolidation
پس از Foundation merge:
- Placeholder `build.yml/test.yml` Audit شوند.
- یک Quality Gate روشن ساخته شود.
- Workflow تکراری حذف/تبدیل شود.

### Fast Lane
هدف: Feedback سریع روی PR/working branch.

Contract پیشنهادی:
- branch/PR concurrency
- `cancel-in-progress: true`
- Flutter cache
- pub get
- analyze
- test

### Full Gate
برای Integration/Ready PR/main:
- full tests
- build وقتی Platform foundation وجود دارد
- verify artifact
- upload artifact در مرحله RC/Release

### Surface Matrix
با رشد پروژه:
- timeline
- capture
- persistence
- ui

تست‌های مستقل می‌توانند موازی شوند.

### Automation Rule
Workflow فقط وقتی اضافه شود که انتظار، خطای انسانی یا Evidence مبهم را کم کند.

---

## 19. Evidence Policy
Evidence فقط برای Ref دقیق معتبر است.

صحیح:
- Analyze passed on SHA X
- Test passed on SHA X
- Build passed on SHA X

غلط:
- «CI سبز است» چون Placeholder سبز بود.
- نسبت‌دادن Build یک SHA به SHA دیگر.
- ادعای Build برای PR #2 وقتی فعلاً فقط Analyze/Test Verify شده است.

---

## 20. Quality Chain
زنجیره هدف:

`flutter pub get → flutter analyze → flutter test → integration validation → flutter build → artifact verification`

همه مراحل در هر PR الزامی نیستند؛ Gate متناسب با Risk/Stage انتخاب می‌شود.

### Test types با رشد پروژه
- Unit
- Widget
- Integration
- RTL behavior
- Golden پس از Design stabilization
- Migration tests
- persistence/recovery tests

---

## 21. Definition of Ready
کار زمانی Ready است که:
- Objective روشن
- Existing work Audit شده
- Scope/Out-of-scope روشن
- Dependency روشن
- Parallel safety معلوم
- Validation تعریف‌شده
- Evidence موردنیاز معلوم
- integration point مشخص

---

## 22. Definition of Done
حسب نوع کار:

`Working Change + Tests + Exact CI Evidence + Documentation + Review + Safe Integration`

کد نوشته‌شده به‌تنهایی Done نیست.

مستند نوشته‌شده تا وقتی در GitHub ثبت/Review نشده Done نیست.

---

## 23. Documentation-as-Code
### Canonical Governance
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

### Comprehensive Project Reference
`docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

### Single Active Execution Plan
`docs/YADNEGAR_OPERATION_PLAN.md`

### Current State
`docs/AI_CONTINUATION_STATE.md`

### Handoff
`docs/AI_HANDOFF_CURRENT_FA.md`

### Technical/Product Detail
`PROJECT_DOCUMENTATION_FA.md`

### Compatibility Pointer
`docs/YADNEGAR_DEVELOPMENT_PROTOCOL.md`

قاعده: سند اجرایی موازی رقیب ساخته نشود؛ Current State باید پس از تغییر معنی‌دار تازه شود.

---

## 24. برنامه عملیاتی سطح بالا
### Wave 0 — Documentation Baseline
PR #3

### Wave 1 — Foundation Integration
Issue #4 / PR #2

### Wave 2 — Parallel Expansion
A: Timeline Domain Contract  
B: RTL App Shell/Timeline Surface  
C: CI Consolidation/Fast Lane

### Wave 3 — First Vertical Slice
`Capture → Persist → Timeline → Edit`

### Wave 4 — Item Types
Note / Event / Call / Idea / Activity

### Wave 5 — Search & Reliability
Search/Filter + persistence hardening + migration

### Wave 6 — Reminder / Backup / Export
پس از Data Contract پایدار

### Wave 7 — Release
E2E + build + artifact + smoke + recovery

جزئیات: `docs/YADNEGAR_OPERATION_PLAN.md`

---

## 25. ریسک‌های فعلی
### R1 — Foundation هنوز روی main نیست
اقدام: reuse و Integration PR #2؛ Foundation جدید ممنوع.

### R2 — CI چندمسیره و مبهم
main دو Placeholder دارد و PR #2 Flutter CI واقعی اضافه می‌کند.  
اقدام: Issue #6 برای consolidation.

### R3 — Draft Foundation PR ممکن است بی‌دلیل متوقف بماند
Evidence Analyze/Test سبز است.  
اقدام: Review دقیق و Ready کردن پس از Verify نهایی.

### R4 — Over-engineering قبل از Vertical Slice
اقدام: اول Capture→Persist→Timeline.

### R5 — Duplicate documentation
اقدام: یک Operational Plan فعال، یک Canonical governance.

### R6 — Stale current state
اقدام: refresh بعد از Mergeهای معنی‌دار.

---

## 26. Recovery و Failure Handling
چرخه:

`Detect → Classify → Contain → Recover → Validate → Document → Improve`

برای Foundation/Data changes:
- rollback روشن
- history preservation
- migration/recovery قبل از تغییر مخرب

---

## 27. Release Governance
وقتی Platform/Build واقعی شکل گرفت:

`Development → Validation → Release Candidate → Approval → Artifact → Smoke Test → Release → Monitor`

Release باید:
- version/tag
- exact SHA
- validation evidence
- release notes
- rollback/recovery

داشته باشد.

---

## 28. گزارش مالک پروژه
گزارش پروژه باید کوتاه و غیر فنی باشد:

`کجا هستیم | چه انجام شد | وضعیت | مانع | قدم بعد`

جزئیات فنی در GitHub Evidence باقی می‌ماند.

برچسب‌ها:
- **واقعیت** — Verify شده
- **برنامه** — هنوز اجرا نشده
- **مسدود** — blocker واقعی
- **نیاز به تصمیم** — تصمیم Owner

---

## 29. Metrics بعد از شکل‌گیری CI
- PR lead time
- Fast Lane feedback time
- Full Gate duration
- stale-run cancellation benefit
- rework rate
- regression escape count

Metric برای کاهش اتلاف است، نه نمایش درصد مصنوعی.

---

## 30. نزدیک‌ترین اقدامات واقعی
1. PR #3: تکمیل/Review Documentation baseline.
2. PR #2: Verify مجدد exact-head CI و Audit diff.
3. PR #2: Mark Ready for Review در صورت سالم بودن.
4. Merge Foundation پس از Review.
5. Issue #6: CI consolidation.
6. Issue #5 و Timeline Core Contract در Branchهای مستقل و موازی.
7. First Vertical Slice.

---

## 31. پروتکل «ادامه یادنگار»
Trigger:

`ادامه یادنگار`

فرآیند:
1. Verify GitHub access.
2. Verify main HEAD.
3. Read open PRs/Issues.
4. Verify exact-head workflows.
5. Read Canonical + Comprehensive + Current State + Operation Plan.
6. Audit implementation before creating work.
7. Reuse existing work.
8. Find nearest real gap.
9. Parallelize independent lanes.
10. Execute reversible work.
11. Validate exact ref.
12. Update documentation/evidence.
13. Commit/PR/integrate.
14. Report briefly and non-technically.

---

## 32. اصل نهایی
**کار واقعی، نه گزارش‌سازی.**

**Reuse قبل از Rebuild.**

**موازی، هماهنگ و سریع، بدون حذف کنترل کیفیت.**

**GitHub Automation برای کاهش زمان انتظار و ابهام.**

**مستندسازی همزمان با Implementation.**

**GitHub Reality همیشه بالاتر از حافظه و Snapshot است.**
