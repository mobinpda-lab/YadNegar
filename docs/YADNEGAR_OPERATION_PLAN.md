# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 1.1 — اجرای موازی، هماهنگ و قابل‌اندازه‌گیری

**تاریخ مبنا:** 2026-08-26  
**وضعیت:** Current execution plan  
**مرجع حقیقت:** GitHub Repository State  
**مرجع قواعد:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
**سند جامع:** `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

## 1. هدف
تبدیل YadNegar از Repository اولیه به نرم‌افزار Flutter واقعی، تست‌شده، قابل‌ساخت و قابل‌توسعه با مدل:

`کار موازی هماهنگ + PR کوچک + Automation + Fast Feedback + Documentation همزمان + Evidence`

هدف سرعت، تولید خروجی معتبر در ساعت‌ها به‌جای چند روز است. سرعت هرگز با حذف Audit، Test، Build، Review، Recovery یا Evidence به دست نمی‌آید.

## 2. وضعیت Verify‌شده هنگام تدوین
### main
- Repository: `mobinpda-lab/YadNegar`
- Default branch: `main`
- HEAD: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Root در main: `.github/` و `README.md`
- Flutter Foundation هنوز در `main` Merge نشده است.

### CI روی main
- `build.yml`: Placeholder
- `test.yml`: Placeholder
- سبز بودن Runهای main فقط `checkout + echo` را اثبات می‌کند.

### PR #3 — Documentation baseline
Branch: `docs/yadnegar-documentation-baseline`

هدف:
- Canonical operating package
- سند جامع پروژه
- Current State / AI Handoff
- مستند فنی/محصولی
- برنامه عملیاتی واحد
- README documentation map

Scope باید Documentation/README-only باقی بماند.

### PR #2 — Flutter Foundation
Branch: `feat/foundation-flutter`
Head Verify‌شده: `e614343a80f9c30e7a171ef7aeb1eaebc852a8be`
Status: Open / Draft / Mergeable

محتوای Verify‌شده:
- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`
- `.github/workflows/flutter-ci.yml`
- `MaterialApp` فارسی با Shell RTL حداقلی

Evidence دقیق Head:
- `flutter pub get`: success
- `flutter analyze`: success
- `flutter test`: success
- Workflow `Flutter CI`: success

در حال حاضر Build APK/Release برای این Head به‌عنوان Evidence تأیید نشده است و نباید ادعا شود.

### PR #1 — CI path validation
این PR آزمایشی به‌دلیل superseded شدن توسط PR #3 و PR #2 در 2026-08-26 بدون Merge بسته شد. تاریخچه آن فقط Evidence آزمایش اولیه است و دیگر Workstream فعال نیست.

### Issues فعال موج اول
- #4 — validate and integrate existing Flutter foundation
- #5 — RTL app shell and timeline contract
- #6 — consolidate real Flutter CI and remove placeholder ambiguity

## 3. مدل اجرای موازی
سه Lane دائمی:

### Lane A — Foundation / Core / Domain
- Flutter Foundation
- Timeline item contract
- Repository contracts
- Persistence foundation پس از تصمیم معماری

### Lane B — UI / Product
- Persian RTL shell
- Timeline UI
- Quick Capture
- Item presentation/edit flows

### Lane C — CI / Automation / Documentation
- GitHub Actions
- Analyze/Test/Build gates
- Fast Lane / Full Gate
- Artifact validation
- Current State / Handoff
- PR queue hygiene

### قانون هماهنگی
- Laneهای مستقل همزمان جلو می‌روند.
- Shared file/contract در هر Wave یک Owner روشن دارد.
- Block شدن یک Lane، Lane مستقل دیگر را متوقف نمی‌کند.
- قبل از هر Wave: open PRs + branches + exact CI + shared files دوباره Audit می‌شوند.

## 4. Wave 0 — Governance و Reality Baseline
### وضعیت
در حال اجرا در PR #3.

### خروجی
- یک Canonical governance
- یک Comprehensive project document
- یک Current State
- یک Handoff
- یک Operational Plan فعال
- README map

### Definition of Done
`Docs complete + no production/workflow behavior change + PR CI evidence + review`

### ضد دوباره‌کاری
فقط `docs/YADNEGAR_OPERATION_PLAN.md` برنامه اجرایی فعال است. برنامه‌های موازی با محتوای مشابه نباید باقی بمانند.

## 5. Wave 1 — Integration Foundation موجود
### مسیر اصلی: Issue #4 / PR #2
PR #2 از صفر ساخته نمی‌شود؛ Work موجود reuse و تکمیل می‌شود.

### اقدامات
1. Audit نهایی Diff PR #2.
2. Verify مجدد exact-head CI قبل از Ready.
3. بررسی minimal بودن Foundation و نبود Over-engineering.
4. Mark Ready for Review پس از Evidence معتبر.
5. Merge کنترل‌شده در صورت نبود Conflict/Regression.
6. Current State بعد از Merge با SHA جدید main به‌روز شود.

### DoD
- Flutter Foundation واقعی روی main
- RTL shell پایه
- baseline widget test
- Flutter Analyze/Test CI واقعی
- Evidence exact SHA

## 6. Wave 2 — CI Consolidation و Parallel Foundation Expansion
بعد از Merge Foundation، سه مسیر همزمان:

### A2 — Core/Timeline Contract
- Audit مدل مفهومی Item
- تصمیم Shared Timeline Item vs Feature-specific variants
- Repository contract حداقلی
- تست Domain
- Persistence هنوز قبل از تصمیم Contract تثبیت نشود.

### B2 — RTL App Shell / Timeline Surface
- reuse از `YadNegarApp` موجود
- Theme baseline
- Navigation کمینه
- Timeline empty/loading/error states
- Quick Capture entry
- Widget tests

### C2 — CI Consolidation
- Audit `build.yml`, `test.yml`, `flutter-ci.yml`
- حذف/تبدیل Placeholderها
- جلوگیری از سه Quality Gate تکراری
- Fast Lane برای feedback سریع
- Full Gate برای integration/build

سه مسیر باید در Branchهای مستقل با Boundary غیرمتداخل اجرا شوند.

## 7. GitHub Automation Target
تجربه Arvin با تطبیق وارد YadNegar می‌شود.

### Fast Lane
Trigger:
- pull_request به main
- working branches مناسب

Contract:
- `concurrency` per branch/PR
- `cancel-in-progress: true`
- Flutter setup/cache
- `flutter pub get`
- `flutter analyze`
- `flutter test`

هدف: نتیجه سریع و لغو Runهای stale.

### Full Gate
برای PR آماده Merge، push به main یا manual dispatch حسب طراحی نهایی:
- dependency restore
- analyze
- full tests
- `flutter build` وقتی Platform foundation واقعی وجود دارد
- verify artifact
- upload artifact در مرحله Release/RC

### Surface Matrix
پس از رشد تست‌ها، تست‌های مستقل Timeline/Capture/Persistence/UI می‌توانند به Matrix تبدیل شوند تا Fail یک Surface بقیه مسیرهای مستقل را بی‌دلیل سریالی نکند.

### Progress Automation
Progress score فقط وقتی Definition of Done و Scorecard واقعی وجود دارد. درصد از تعداد Commit/PR ساخته نمی‌شود.

## 8. Wave 3 — First Vertical Slice
هدف:

`Quick Capture → Persist → Timeline → View/Edit`

### Lane A
- create/update/read use cases
- persistence implementation پس از تصمیم storage
- domain/data tests

### Lane B
- Quick Capture UI
- Timeline rendering
- Item detail/edit
- RTL widget tests

### Lane C
- focused CI
- regression gate
- Current State update

### DoD
- Item بعد از restart باقی بماند.
- Timeline صحیح نمایش دهد.
- Edit حفظ شود.
- Analyze/Test/Build applicable روی SHA دقیق سبز باشد.
- Documentation همزمان به‌روز باشد.

## 9. Wave 4 — Feature Expansion موازی
پس از Shared Contract پایدار:
- Note
- Event
- Call
- Idea
- Daily Activity

قانون:
هیچ Feature حق ایجاد Model/Repository/Storage/Timeline engine موازی ندارد مگر ADR تأییدشده دلیل آن را ثبت کند.

Featureها در PRهای مستقل و همزمان توسعه می‌یابند وقتی Boundary مشترک پایدار باشد.

## 10. Wave 5 — Retrieval & Reliability
### A
- query/search contracts
- persistence hardening
- migration/versioning

### B
- Search UI
- filters
- date/group views

### C
- surface-specific test matrix
- regression automation
- documentation integrity checks فقط اگر ارزش عملی داشته باشند

## 11. Wave 6 — Reminder / Backup / Export
فقط پس از Core Data Contract پایدار:

### Reminder
- timestamp contract
- notification behavior
- background constraints

### Backup/Restore
- versioned format
- validation before restore
- recovery test
- no destructive overwrite

### Export/Share
- فقط از source of truth اصلی
- بدون storage دوم

## 12. Wave 7 — Release Readiness
- Integration/E2E
- release build
- APK/artifact verification
- smoke test
- version/tag
- release notes
- rollback/recovery notes
- Current State final refresh

## 13. Documentation همزمان با کار
در هر Workstream:

`Implementation/Workflow ↔ Validation ↔ Evidence ↔ Current State`

- تغییر Rule: Canonical update
- تصمیم معماری ماندگار: ADR
- تغییر وضعیت واقعی: Current State
- Feature contract مهم: Feature doc
- Session انتقالی: Handoff refresh

مستندسازی نباید فقط در پایان پروژه انجام شود.

## 14. Work Queue Hygiene
هر continuation:
1. Open PRها و Issues خوانده شوند.
2. Work موجود قبل از ایجاد کار جدید Audit شود.
3. PR/Issue تکراری ساخته نشود.
4. Superseded work بسته/آرشیوی شود.
5. Exact head CI بررسی شود.
6. Merge فقط با Evidence.
7. Independent branches همزمان جلو بروند.

PR #1 نمونه‌ای از Work آزمایشی Superseded بود و بسته شد تا صف تمیز بماند.

## 15. قالب Work Item
هر Issue/Task مهم:
- Objective
- Scope
- Out of Scope
- Dependencies
- Parallel Safety
- Validation
- Evidence
- Docs Impact
- Rollback

Issues #4 تا #6 با همین قرارداد ثبت شده‌اند.

## 16. PR Policy
- یک هدف اصلی
- Diff کوچک
- فایل‌های مشترک کنترل‌شده
- Test مرتبط
- Evidence exact-head
- Documentation impact
- Reversible by default

PR چندمنظوره Architecture + UI + CI غیرمرتبط باید Decompose شود.

## 17. گزارش مالک پروژه
گزارش فقط:

`کجا هستیم | انجام شد | وضعیت | مانع | بعدی`

کوتاه، غیر فنی و نتیجه‌محور. جزئیات YAML/کد/لاگ در GitHub باقی می‌ماند مگر برای تصمیم لازم باشد.

## 18. Metrics پس از شکل‌گیری CI
- PR lead time
- fast-lane feedback time
- full-gate duration
- stale-run cancellation benefit
- rework count
- regression escape count

Metric برای کشف اتلاف است، نه نمایش درصد مصنوعی.

## 19. نزدیک‌ترین اقدامات واقعی
1. تکمیل و Review PR #3 به‌عنوان Documentation baseline.
2. PR #2: exact-head CI مجدداً Verify؛ سپس Ready for Review.
3. Merge PR #2 در صورت سالم بودن Review/CI.
4. Issue #6: CI consolidation بعد از Foundation.
5. Issue #5 و Core Timeline contract در Branchهای جدا و موازی.
6. First vertical slice: Capture → Persist → Timeline.

## 20. خط قرمزها
- ساخت Foundation دوم به‌جای reuse PR #2
- ادعای Build بدون Build evidence
- نگه‌داشتن Placeholder به‌عنوان Quality Gate واقعی
- Storage موازی
- معماری بدون Audit
- Merge بدون exact-head evidence
- حذف تست برای سبزشدن
- تصمیم مهم فقط در Chat
- سریالی‌کردن Work مستقل
- Documentation governance تکراری

## 21. فرمول دائمی
`Audit → Reuse Existing Work → Find Gap → Decompose → Parallelize → Execute → Fast Validate → Full Gate → Evidence → Document → Integrate → Brief Report`

**هدف: نرم‌افزار واقعی در چند ساعت به‌جای چند روز، با موازی‌سازی هماهنگ، GitHub Automation، Quality Gate و مستندسازی همزمان.**
