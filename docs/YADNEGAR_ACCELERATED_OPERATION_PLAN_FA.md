# برنامه عملیاتی شتاب‌یافته پروژه یادنگار
## نسخه 1.0 — Parallel / Fast / Coordinated Delivery

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Canonical Governance:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
**Comprehensive Reference:** `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

---

## 1. هدف برنامه
این برنامه برای تبدیل YadNegar از Repository مستنداتی فعلی به یک نرم‌افزار واقعی، تست‌شده و قابل‌ساخت طراحی شده است؛ با اصل:

`کار موازی هماهنگ + بازخورد سریع + GitHub Automation + مستندسازی همزمان + کنترل کیفیت`

هدف زمانی: کاهش Lead Time از چند روز به چند ساعت برای هر موج کوچک، نه با حذف Quality Gate بلکه با حذف صف‌های غیرضروری و اجرای همزمان کارهای مستقل.

---

## 2. وضعیت شروع Verify‌شده
در Snapshot 2026-08-26:
- `main` روی `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Flutter Foundation در `main` وجود ندارد.
- `pubspec.yaml`, `lib/`, `test/` وجود ندارند.
- `build.yml` و `test.yml` Placeholder هستند.
- PR مستندات `#3` فعال است.

بنابراین Critical Path واقعی پروژه:

`Documentation Baseline → Flutter Foundation → Real CI → Domain/UI Parallel → First Vertical Slice`

---

## 3. مدل اجرای موازی
سه Lane دائمی:

### Lane A — Foundation / Domain
هدف: ساخت پایه‌ای که بقیه Featureها روی آن سوار شوند.

### Lane B — UI / Product
هدف: RTL App Shell، Timeline و Quick Capture بدون ایجاد Foundation موازی.

### Lane C — CI / Automation / Documentation
هدف: تبدیل GitHub به سیستم بازخورد، کنترل کیفیت و ثبت وضعیت خودکار/نیمه‌خودکار.

اصل هماهنگی:
- Shared file بدون Owner مشترک و برنامه integration همزمان ویرایش نشود.
- هر Lane Branch مستقل داشته باشد.
- PRها کوچک بمانند.
- Lane مسدود، Lane مستقل را متوقف نکند.
- Current State در Mergeهای مهم همراه با کار به‌روز شود.

---

## 4. Wave 0 — تثبیت مستندات و Governance
### هدف
ایجاد مرجع واحد قبل از توسعه واقعی.

### کارها
**C0.1 — Canonical governance**
- `YADNEGAR_PROJECT_OPERATING_PACKAGE.md`
- وضعیت: انجام‌شده در Branch مستندات

**C0.2 — Comprehensive project document**
- تعریف محصول، معماری، CI، Automation، Roadmap، Risk و Continuity
- وضعیت: انجام‌شده در Branch مستندات

**C0.3 — Current state + Handoff**
- Snapshot دقیق `main`
- وضعیت: انجام‌شده در Branch مستندات

**C0.4 — Accelerated operation plan**
- همین سند

### Validation
- Documentation-only diff
- مقایسه Branch با `main`
- عدم تغییر app/workflow behavior
- PR Review

### خروجی موج
یک Baseline قابل انتقال برای تمام Sessionهای بعدی.

---

## 5. Wave 1 — Flutter Foundation Bootstrap
### وابستگی
پس از Merge مستندات یا Verify مجدد اینکه Branch توسعه از آخرین `main` ساخته شده است.

### Lane A — Critical Path
**A1.1 — Minimal Flutter bootstrap**
- ایجاد Flutter project حداقلی
- `pubspec.yaml`
- `lib/main.dart`
- baseline test
- فقط Platformهای لازم در فاز اول

**A1.2 — Foundation boundaries**
- `app/`
- Core فقط در حد مصرف واقعی
- عدم ساخت Featureهای خالی

### Lane B — Design Contract موازی
**B1.1 — RTL/UI contract**
- تعریف Theme/RTL rules
- App Shell contract
- Timeline visual contract در حد مستند/تست‌پذیر

این Lane می‌تواند همزمان با A1.1 طراحی شود، اما کد UI نهایی نباید قبل از آماده‌شدن Flutter bootstrap به Branch اصلی Feature متکی شود.

### Lane C — Automation preparation
**C1.1 — CI contract**
- تعریف Fast Lane و Full Gate
- آماده‌سازی Workflow تغییرات در Branch `ci/**`
- فعال‌سازی فقط وقتی Foundation روی Branch هدف واقعاً وجود دارد.

### Validation
روی Foundation head:
`flutter pub get → flutter analyze → flutter test`

در صورت امکان Build پایه نیز اجرا شود.

### Definition of Done
- Flutter app واقعی وجود دارد.
- Analyze/Test واقعی سبز است.
- Foundation PR کوچک و Reviewable است.
- Current State به‌روز شده است.

---

## 6. Wave 2 — سه مسیر موازی واقعی
پس از تثبیت Foundation، سه Lane باید همزمان اجرا شوند.

### Lane A — Timeline Domain
**A2.1 — Timeline Item Contract**
- بررسی Shared Item vs Feature-specific entities
- تعریف حداقل Entity/Value Object لازم
- Repository contract
- tests

**A2.2 — Persistence decision spike**
- انتخاب Storage بر اساس معیارهای واقعی
- ثبت ADR فقط اگر تصمیم معماری پایدار گرفته شد

### Lane B — RTL App Shell
**B2.1 — App Shell**
- فارسی
- RTL
- Theme پایه
- Navigation کمینه

**B2.2 — Timeline empty state**
- Screen واقعی بدون Fake data dependency

### Lane C — GitHub Fast Lane
**C2.1 — Fast Lane Workflow**
- PR/push working branches
- concurrency per branch
- cancel stale runs
- pub get
- analyze
- test

**C2.2 — Full Build Gate**
- PR ready/main
- full test
- build artifact
- artifact verification

### Parallel Rule
A2 و B2 و C2 در صورت عدم تداخل فایل‌ها باید همزمان جلو بروند.

### Integration Gate
قبل از Merge هر Lane:
- exact SHA validation
- compare against current main
- no duplicate foundation
- docs impact check

---

## 7. Wave 3 — First Real Vertical Slice
### هدف
اولین قابلیت کامل end-to-end:

`Quick Capture → Persist → Timeline → View/Edit`

### Lane A
- use caseهای create/update/read
- persistence implementation
- domain tests

### Lane B
- Quick Capture UI
- Timeline rendering
- Item detail/edit
- RTL/widget tests

### Lane C
- focused CI tests for capture/timeline
- full gate preservation
- update Current State automatically/manually as part of PR Definition of Done

### Definition of Done
- داده بعد از restart باقی بماند.
- Item در Timeline دیده شود.
- ویرایش حفظ شود.
- Analyze/Test/Build برای SHA دقیق سبز باشد.
- مستندات وضعیت جدید را منعکس کنند.

---

## 8. Wave 4 — Item Types روی Foundation مشترک
Featureها به‌صورت مستقل ولی روی Shared Item Contract توسعه می‌یابند:

### B4.1 — Note
### B4.2 — Event
### B4.3 — Call
### B4.4 — Idea
### B4.5 — Activity

قانون:
هیچ Feature حق ایجاد DB/Repository/Timeline engine مستقل ندارد مگر ADR تأییدشده دلیل آن را ثابت کند.

### Parallelization
اگر قرارداد Shared Item تثبیت شده باشد، UI و Feature logic این موارد می‌توانند در PRهای جدا و همزمان توسعه یابند.

---

## 9. Wave 5 — Retrieval & Reliability
### Lane A
- query/search contracts
- migration/versioning hardening

### Lane B
- Search UI
- filters
- date/group views

### Lane C
- surface-specific test matrix
- regression checks
- documentation integrity checks

هدف: قابلیت‌های retrieval بدون ساخت search engine موازی.

---

## 10. Wave 6 — Reminder / Backup / Export
این Wave فقط بعد از تثبیت Core Data Contract شروع شود.

### Reminder
- timestamp contract روشن
- notification behavior
- background constraints

### Backup/Restore
- versioned format
- validation before restore
- recovery tests
- عدم overwrite مخرب

### Export/Share
- فقط بر داده اصلی
- بدون storage دوم

---

## 11. Wave 7 — Release Readiness
- Integration/E2E
- Build release artifact
- smoke test
- artifact verification
- version/tag
- release notes
- rollback/recovery notes
- Current State final update

---

## 12. GitHub Automation Plan
### مرحله A — اکنون
- Branch/PR discipline
- Issues برای Workstreamها
- Documentation-as-Code
- Current State/Handoff

### مرحله B — پس از Foundation
**Fast Lane**
- trigger: PR + working branches
- `concurrency` group per branch
- `cancel-in-progress: true`
- analyze + test

**Full Gate**
- ready PR/main
- analyze + full tests + build
- artifact verification/upload

### مرحله C — پس از رشد پروژه
- test matrix per feature surface
- workflow path filters
- progress score فقط بر مبنای Definition of Done واقعی
- release artifact workflow

### اصل اتوماسیون
Automation باید زمان انتظار و خطای انسانی را کم کند؛ نه اینکه تعداد Workflowها را بی‌دلیل زیاد کند.

---

## 13. Work Item Template
هر Issue/Task باید حداقل این قرارداد را داشته باشد:

**Objective** — چه خروجی واقعی می‌خواهیم؟  
**Scope** — چه فایل/Featureهایی داخل کار است؟  
**Out of Scope** — چه چیزی عمداً انجام نمی‌شود؟  
**Dependencies** — به چه چیزی وابسته است؟  
**Parallel Safety** — با کدام Lane می‌تواند همزمان اجرا شود؟  
**Validation** — چگونه موفقیت ثابت می‌شود؟  
**Evidence** — چه SHA/Workflow/Test لازم است؟  
**Docs Impact** — کدام سند باید به‌روزرسانی شود؟  
**Rollback** — برگشت چگونه انجام می‌شود؟

---

## 14. PR Size Rule
ترجیح:
- یک هدف اصلی
- یک Foundation boundary
- Diff کوچک
- تست مرتبط
- docs مرتبط

اگر PR همزمان Architecture + Feature + CI + UI غیرمرتبط را تغییر می‌دهد، باید قبل از ادامه Decompose شود.

---

## 15. Fast Feedback Strategy
در هر PR:
1. Focused local validation در صورت امکان
2. Fast Lane GitHub
3. اگر آماده Merge است، Full Gate
4. merge فقط با Evidence exact-head

Run قدیمی باید در صورت push جدید Cancel شود تا صف CI پروژه را کند نکند.

---

## 16. Documentation in Parallel
مستندسازی مرحله آخر نیست.

در هر Workstream:
- هنگام تصمیم معماری: ADR/architecture note
- هنگام تغییر وضعیت: Current State
- هنگام تغییر قرارداد محصول: product/feature doc
- هنگام تغییر قواعد: Canonical first
- هنگام پایان Session مهم: Handoff refresh

هدف: Session بعدی بتواند بدون بازسازی ذهنی از گفتگو ادامه دهد.

---

## 17. گزارش مختصر و غیر فنی
پس از هر موج/PR مهم:

`کجا هستیم:` یک جمله  
`انجام شد:` حداکثر 2–3 مورد  
`وضعیت:` سبز / در حال بررسی / مسدود  
`مانع:` فقط اگر واقعی است  
`بعدی:` یک اقدام روشن

از گزارش جزئیات داخلی ابزارها، YAML و ساختارهای فنی برای مالک پروژه خودداری شود مگر تصمیمی به آن وابسته باشد.

---

## 18. Metrics پیشنهادی
پس از شکل‌گیری واقعی CI، این Metrics می‌توانند برای بهبود سرعت استفاده شوند:
- PR lead time
- CI feedback time
- full gate duration
- failed-run retry rate
- average PR size
- rework count
- escaped regression count

هدف Metric: پیدا کردن اتلاف زمان، نه ساخت درصد پیشرفت نمایشی.

---

## 19. برنامه 3 موج اول به‌صورت اجرایی
### موج فعلی — Documentation
- تکمیل PR #3
- Review scope
- Merge در صورت سالم بودن

### موج بعد — Foundation
- Issue A1: Flutter Foundation
- Issue B1: RTL/UI Contract
- Issue C1: Real CI Preparation

A1 Critical Path است؛ B1 و C1 تا حد عدم وابستگی می‌توانند همزمان آماده شوند.

### موج سوم — Parallel Build
- A2 Timeline Domain
- B2 App Shell
- C2 Fast Lane + Full Gate

این سه مسیر باید همزمان شروع شوند و فقط در Integration point هماهنگ شوند.

---

## 20. خط قرمزها
- شروع Feature قبل از Verify Foundation
- ادعای CI واقعی بر Placeholder
- ساخت Storage موازی
- بازطراحی معماری بدون Audit
- Commit بزرگ چندمنظوره
- Merge بدون exact-head evidence
- حذف تست برای سبزشدن
- نگه‌داشتن تصمیم مهم فقط در Chat
- سریالی کردن کارهای مستقل
- تولید Documentation زیاد بدون ارزش عملی

---

## 21. فرمول اجرایی دائمی
`Audit → Find Gap → Decompose → Parallelize → Implement → Fast Validate → Full Gate → Evidence → Document → Integrate → Report`

هدف نهایی:
**تولید نرم‌افزار واقعی در چند ساعت به‌جای چند روز، با کار موازی هماهنگ، GitHub خودکار، کنترل کیفیت و مستندسازی همزمان.**
