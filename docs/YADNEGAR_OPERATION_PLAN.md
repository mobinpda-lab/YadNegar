# برنامه عملیاتی شتاب‌یافته پروژه YadNegar

**تاریخ مبنا:** 2026-08-26  
**وضعیت:** Current execution plan  
**مرجع حقیقت:** GitHub Repository State  
**مرجع قواعد:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

## 1. هدف
این برنامه برای تبدیل YadNegar از Repository اولیه به نرم‌افزار Flutter واقعی، قابل تست و قابل توسعه تدوین شده است؛ با اصل ثابت:

`کار موازی هماهنگ + تغییرات کوچک + Automation + Fast Feedback + Documentation همزمان + Evidence`

هدف سرعت، تولید خروجی معتبر در ساعت‌ها به‌جای کش‌دادن کار در چند روز است. سرعت نباید با حذف Audit، Test، Build، Review یا Recovery به دست آید.

## 2. وضعیت Verify‌شده هنگام تدوین برنامه
### main
- Repository: `mobinpda-lab/YadNegar`
- Default branch: `main`
- HEAD مبنا: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Root در main: `.github/` و `README.md`
- Flutter Foundation هنوز در `main` Merge نشده است.

### CI روی main
- `build.yml`: Placeholder
- `test.yml`: Placeholder
- سبز بودن Runهای main فقط اجرای `checkout + echo` را اثبات می‌کند.

### کارهای باز
#### PR #3 — Documentation baseline
Branch: `docs/yadnegar-documentation-baseline`

هدف:
- Canonical operating package
- Current state
- AI handoff
- Technical/product documentation
- README documentation map
- این برنامه عملیاتی

مسیر مستقل از Foundation است و باید Documentation-only باقی بماند.

#### PR #2 — Flutter Foundation
Branch: `feat/foundation-flutter`

محتوا:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`

Evidence قبلی:
- `flutter pub get`: موفق
- `flutter analyze`: موفق
- `flutter test`: ناموفق به‌علت Assertion تست که وجود دقیقاً یک `Directionality` را فرض کرده بود.

اصلاح کوچک تست در Commit `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` انجام شده است تا جهت مؤثر RTL روی متن بررسی شود، نه تعداد Widgetهای `Directionality`. نتیجه CI این Commit باید قبل از Ready/Merge بررسی شود.

#### PR #1 — CI path validation
Branch: `docs/parallel-development-status`

این PR فقط برای اعتبارسنجی مسیر Pull Request روی Workflow موجود ایجاد شده بود. پس از تثبیت مستندات Canonical و CI واقعی، باید به‌عنوان کار آزمایشی قدیمی ارزیابی و در صورت بی‌نیازی بدون Merge بسته شود تا Work Queue تمیز بماند.

## 3. مدل اجرای موازی
سه Lane همزمان مدیریت می‌شوند:

### Lane A — Foundation / Core
مالک محدوده:
- Flutter Foundation
- Domain contracts
- Timeline item model پس از تصمیم معماری
- Repository contracts
- Persistence foundation پس از ADR/تصمیم

### Lane B — UI / Feature
مالک محدوده:
- Persian RTL shell
- Timeline UI
- Quick Capture
- Item presentation/edit flows

### Lane C — CI / Automation / Documentation
مالک محدوده:
- GitHub Actions
- Analyze/Test/Build gates
- Artifact validation
- Canonical/current-state docs
- PR/work queue hygiene

قاعده اجرایی:
- Laneهای مستقل همزمان جلو می‌روند.
- فایل/Contract مشترک فقط یک مالک در هر Wave دارد.
- Block شدن یک Lane، Lane مستقل دیگر را متوقف نمی‌کند.
- قبل از هر Wave، PRهای باز و تغییرات مشترک دوباره Audit می‌شوند.

## 4. Wave 0 — تثبیت Governance و Reality
خروجی مورد انتظار:
- PR #3 شامل سند Canonical، Current State، Handoff، مستند فنی/محصولی و این برنامه باشد.
- اسناد صریحاً Target را از Implementation واقعی جدا کنند.
- PR #3 Documentation-only باقی بماند.
- CI Ref دقیق PR #3 بررسی شود.
- پس از Review، Merge کنترل‌شده انجام شود.

Definition of Done:
`Docs complete + no production code change + CI evidence + merge`

## 5. Wave 1 — بستن Foundation واقعی
مسیر فعال: PR #2

اقدامات:
1. بررسی CI Commit اصلاح تست.
2. در صورت Failure، فقط علت واقعی همان Failure اصلاح شود.
3. `pub get → analyze → test` روی Ref دقیق سبز شود.
4. ساختار Foundation از Over-engineering پاک بماند.
5. PR از Draft فقط پس از CI معتبر خارج شود.
6. Merge پس از Review و بدون ادعای Buildی که اجرا نشده است.

Definition of Done:
- Flutter project واقعی روی main
- RTL shell پایه
- baseline test سبز
- Flutter CI واقعی برای Analyze/Test
- Evidence مربوط به Commit دقیق

## 6. Wave 2 — یکپارچه‌سازی CI و حذف Placeholder
وابسته به Merge شدن Foundation.

اقدامات:
- Audit سه Workflow موجود پس از Merge.
- حذف یا تبدیل Workflowهای Placeholder، بدون نگه‌داشتن Quality Gate موازی و گیج‌کننده.
- تعریف یک مسیر روشن PR Validation.
- حداقل Gate:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`
- افزودن `flutter build` وقتی Platform foundation واقعی برای Build موجود باشد.
- Artifact فقط وقتی خروجی قابل نصب واقعی تولید می‌شود.

اصل Automation:
یک Check واقعی و قابل اعتماد بهتر از چند Workflow سبزِ ظاهری است.

## 7. Wave 3 — Core Contract و UI Skeleton به‌صورت موازی
پس از Foundation، دو مسیر مستقل ایجاد شود:

### A — Core contract
- تعریف نیاز واقعی Timeline item
- بررسی اینکه آیا یک Unified Item برای Note/Event/Call/Idea/Activity مناسب است یا Variantهای مستقل لازم‌اند.
- تصمیم قبل از Persistence.
- Repository contract حداقلی و تست‌پذیر.

### B — UI skeleton
- App shell پایدار RTL
- Timeline screen خالی/fixture-based بدون Storage جعلی
- Quick Capture entry point
- Navigation حداقلی

Lane C همزمان:
- Test conventions
- CI quality gate
- Current State update

Integration Gate:
UI نباید Schema یا Storage را از روی حدس تثبیت کند. Core نیز نباید UI را مجبور به ساختار غیرضروری کند.

## 8. Wave 4 — Persistence + Quick Capture + Timeline
فقط پس از Core decision.

اقدامات:
- انتخاب Persistence با معیار Offline، Migration، Query و Recovery.
- ثبت ADR در صورت تصمیم معماری مؤثر.
- پیاده‌سازی Repository implementation.
- Quick Capture end-to-end.
- نمایش آیتم ثبت‌شده در Timeline.
- Unit/Widget tests.

Definition of Done:
`Create item → persist → load → show in RTL Timeline → test → CI`

این اولین Vertical Slice محصولی واقعی است و از ساخت همزمان Featureهای متعدد بدون مسیر End-to-End مهم‌تر است.

## 9. Wave 5 — Feature expansion موازی
پس از Vertical Slice پایدار، Featureها بر اساس Contract مشترک در Laneهای مستقل توسعه یابند:
- Note
- Event
- Call
- Idea
- Daily Activity
- Search/Filter
- Item detail/edit

هر Feature باید:
- Model/Storage موجود را reuse کند مگر دلیل معماری خلاف آن وجود داشته باشد.
- تست مستقل داشته باشد.
- PR کوچک داشته باشد.
- Current State را در تغییر مهم به‌روز کند.

## 10. Automation Roadmap
به‌ترتیب ارزش:
1. PR Flutter Quality Gate
2. Analyze/Test اجباری برای Merge policy در صورت امکان Repository settings
3. Build validation پس از ایجاد Platform files
4. APK artifact برای Release Candidate
5. Release workflow مبتنی بر tag/version
6. Dependency/update hygiene
7. Issue/PR templates فقط اگر واقعاً اصطکاک کار را کم کنند

Automation نباید صرفاً تعداد Workflowها را زیاد کند؛ باید انتظار، خطای انسانی یا Evidence مبهم را کم کند.

## 11. سیاست مستندسازی همزمان
برای هر تغییر مهم:
`Code/Workflow Change ↔ Validation ↔ Evidence ↔ Current State`

- Canonical document فقط هنگام تغییر قاعده اصلاح می‌شود.
- Current State پس از تغییر واقعی وضعیت به‌روزرسانی می‌شود.
- ADR فقط برای تصمیم معماری ماندگار ساخته می‌شود.
- Handoff باید کوتاه و قابل ادامه باشد.
- Snapshot تاریخی بازنویسی نمی‌شود تا تاریخ پروژه پاک نشود.

## 12. GitHub Work Queue Hygiene
در هر continuation:
1. Open PRs خوانده شوند.
2. PR تکراری ساخته نشود.
3. PRهای superseded شناسایی شوند.
4. Head و CI دقیق هر PR بررسی شود.
5. Merge فقط بعد از Evidence انجام شود.
6. شاخه‌های مستقل در صورت عدم تداخل همزمان جلو بروند.

## 13. Definition of Done پروژه‌ای در هر مرحله
هیچ درصد پیشرفتی فقط از روی تعداد Commit/PR افزایش داده نشود.

پیشرفت فقط وقتی محسوب می‌شود که خروجی قابل استفاده و Validate شده باشد.

فرمول تحویل:
`Working Software + Tests + CI Evidence + Documentation + Review + Safe Integration`

## 14. نزدیک‌ترین اقدامات واقعی
ترتیب بر اساس وضعیت فعلی GitHub:
1. تکمیل و Merge مستندات Canonical در PR #3 پس از CI.
2. بررسی CI جدید PR #2 و رفع فقط Failure واقعی در صورت وجود.
3. Ready/Merge کردن PR #2 پس از Flutter validation سبز.
4. ارزیابی و بستن PR #1 در صورت superseded بودن.
5. ایجاد PR کوچک CI consolidation پس از Foundation.
6. سپس آغاز Core contract و UI skeleton در دو Branch مستقل و هماهنگ.

## 15. قانون ادامه
Trigger:
`ادامه یادنگار`

معنی اجرایی:
`Audit live GitHub → reconcile current docs → choose nearest real unfinished gap → parallelize independent work → execute → validate exact ref → document → report briefly`
