# YADNEGAR PROJECT OPERATING PACKAGE v1.1
## مرجع عملیاتی واحد پروژه یادنگار

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Architecture:** Feature-based + Clean boundaries + Persian RTL-first UI  
**Reality Authority:** GitHub Repository State  
**Status:** Canonical Governance

## 0. اصول غیرقابل مذاکره
1. GitHub مرجع عملیاتی حقیقت برای کد، Branch، Commit، PR، Workflow، CI، Build و مستندات است.
2. هر Session مهم با Fresh Audit شروع می‌شود؛ حافظه و Conversation جای Audit را نمی‌گیرند.
3. هدف، نرم‌افزار سالم در ساعت‌ها به‌جای روزهاست. سرعت از موازی‌سازی، Automation، reuse و حذف انتظار می‌آید؛ نه از حذف Gate.
4. Laneهای مستقل باید همزمان حرکت کنند. Block یک Lane نباید Lane مستقل دیگر را متوقف کند.
5. Evidence فقط برای Ref/SHA دقیق معتبر است. Green تاریخی برای Head جدید معتبر نیست.
6. قبل از ساخت هر Model/Repository/Storage/AppShell/Workflow/Foundation، نمونه موجود Audit و reuse شود.
7. Fake Build/Test/Persistence/Release Evidence ممنوع است.
8. تغییرات پرریسک مستقیماً روی `main` انجام نشوند؛ Branch/PR مسیر پیش‌فرض است.
9. تغییرات کوچک، قابل Review و قابل Rollback باشند.
10. مستندات همزمان با Implementation جلو بروند و سند اجرایی رقیب ساخته نشود.

## 1. ترتیب مرجع حقیقت
`GitHub Reality > approved architecture decisions > this canonical package > current execution docs > conversation memory`

در اختلاف منابع:
`Verify GitHub → identify discrepancy → repair current docs → preserve material history`

## 2. Trigger «ادامه یادنگار»
این عبارت دستور اجرایی است:
1. main/PR/Issue/Workflow زنده Audit شود.
2. Canonical + Current State خوانده شود.
3. نزدیک‌ترین Gap واقعی انتخاب شود.
4. Work به Laneهای مستقل شکسته شود.
5. reuse قبل از rebuild اعمال شود.
6. Implementation واقعی روی GitHub انجام شود.
7. exact-head Validation گرفته شود.
8. Merge فقط با Gate امن انجام شود.
9. post-main proof گرفته شود.
10. Docs همزمان sync و گزارش مالک کوتاه ارائه شود.

## 3. مدل کار موازی
### Lane A — Core / Data
- Domain contracts
- Timeline model/repository
- Persistence, schema, migration, recovery
- architecture boundaries

### Lane B — Product / UX
- Persian RTL
- Timeline / Quick Capture
- Search/Filter/Edit/Delete/Undo
- Backup/Restore/Reminder UX

### Lane C — Release / Platform
- Android build/release candidate
- artifact evidence
- smoke/E2E/recovery
- release governance/signing only after explicit audit

### Lane D — CI / Automation / Documentation
- GitHub Actions
- Analyze/Test/Build
- stale-run cancellation
- evidence capture
- Current State / Handoff / Operation Plan

Rule:
`Detect overlap → assign ownership → execute independently → validate → integrate`

## 4. Definition of Ready
Task زمانی Ready است که:
- objective و value روشن باشد
- existing implementation Audit شده باشد
- scope/out-of-scope مشخص باشد
- dependency و integration point معلوم باشد
- validation و evidence تعریف شده باشد
- parallel-safety معلوم باشد

ابهام کوچک نباید پروژه را متوقف کند؛ ابهام معماری/داده/امنیت قبل از تغییر پرریسک باید حل شود.

## 5. Definition of Done
`Working Change + Tests/Validation + Exact Evidence + Documentation + Safe Integration`

نوشتن فایل یا سبزشدن Placeholder به‌تنهایی Done نیست.

## 6. معماری و Reuse Contract
Current implementation یک Timeline foundation مشترک دارد:
- one `TimelineItem`
- one `TimelineRepository` contract
- one crash-recoverable JSON storage
- one App Shell / Timeline flow
- one schema-versioned parser/serializer path

Feature جدید نباید Foundation موازی ایجاد کند مگر Audit و ADR واقعی آن را لازم کند.

Dependency direction:
`Presentation → Application → Domain`

Platform/Data implementations باید پشت boundary بمانند؛ Domain نباید مستقیم به Flutter plugin یا storage implementation وابسته شود.

## 7. Data Governance
Production storage اکنون schema v2 است و v1 را backward-compatible می‌خواند.

هر schema/storage change مهم حسب مورد باید داشته باشد:
`Versioning + Backward Compatibility + Migration/Safe Upgrade + Validation + Recovery/Rollback`

داده کاربر برای ساده‌سازی توسعه نباید destructive rewrite شود.

Backup/Restore باید production parser/serializer/recovery path را reuse کند؛ raw overwrite و serializer دوم ممنوع است.

## 8. Reminder Governance
Reminder روی همان TimelineItem و storage موجود سوار است.

قواعد:
- no sidecar Reminder database/repository
- notification plugin بیرون Domain
- persist-first: schedule/cancel failure نباید داده ذخیره‌شده را rollback کند
- startup/Restore reconciliation از persisted Timeline انجام شود
- recurring reminders فقط در Slice جدا پس از Audit
- exact-alarm permission فقط اگر نیاز محصول و compatibility proof آن را توجیه کند

## 9. CI / Quality
Fast chain:
`flutter pub get → flutter analyze → flutter test`

Android/Product/Release chain حسب Scope:
`Fast CI → Android Build → Artifact Verify/Upload → live mergeability → expected-head merge → post-main proof`

Workflow rules:
- reuse موجود قبل از Workflow جدید
- `concurrency/cancel-in-progress` برای جلوگیری از runهای stale
- artifact باید واقعی و قابل Verify باشد
- build یک SHA به SHA دیگر نسبت داده نشود

## 10. Git / PR Governance
- Branch کوچک و هدفمند
- PR یک هدف اصلی
- Out-of-scope روشن
- commits قابل Review/Rollback
- هیچ stale merge
- قبل از Merge، exact current head دوباره خوانده شود
- Merge محصول/Release فقط با exact-head CI + Android و live mergeability
- Merge با `expected_head_sha`
- بعد از Merge، main تازه Verify شود

## 11. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/Release Gate Green همان Head
4. relevant artifact steps Green
5. live mergeability=true
6. `expected_head_sha=exact head`
7. post-main CI/Android proof

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. expected-head lock
5. post-main Fast CI proof

## 12. Documentation-as-Code
Canonical Governance:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

Current execution plan:
`docs/YADNEGAR_OPERATION_PLAN.md`

Current state:
`docs/AI_CONTINUATION_STATE.md`

Persian Handoff:
`docs/AI_HANDOFF_CURRENT_FA.md`

Comprehensive historical/product reference:
`docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

Temporary active-state files باید پس از پایان Wave حذف شوند و به Canonical رقیب تبدیل نشوند.

## 13. Verified Current Baseline — 2026-08-27
Verified main:
`f85d804a84a4033c94e2dc843a6aa87f2d848991`

Post-main evidence:
- YadNegar CI `33051308713`: success
- YadNegar Android Build `33051308694`: success
- APK build/verify/upload: success

Main product flow:
`Quick Capture → Persist → Timeline → Search/Filter → Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Verified main capabilities include:
- Persian RTL Timeline
- Note/Event/Call/Idea/Activity
- crash-recoverable JSON persistence
- Search/Type/Date Range
- occurredAt
- Delete/Undo
- Export
- validated Backup/Restore
- schema-v2 optional reminderAt with v1 compatibility
- Persian Reminder UX
- Android local notifications
- startup/Restore Reminder reconciliation

## 14. Reminder Integration Record
### PR #76 / Issue #75
- final head `6ab46b5029b3070e43e1524431b821a766326eb2`
- CI `33046525150`: success
- Android `33046525158`: success
- merged main `fceb383aad507eed354d4b044e3939aacf5328d0`
- post-main CI `33046893279`: success
- post-main Android `33046893295`: success

### PR #78 / Issue #77
- final head `22bc0d1d855c98521dc554a770ff41e8475f532b`
- CI `33050851398`: success
- Android `33050851419`: success
- 106 tests passed
- exact Runner-generated dependency lock
- expected-head merge
- merged main `f85d804a84a4033c94e2dc843a6aa87f2d848991`
- post-main CI `33051308713`: success
- post-main Android `33051308694`: success

Issue #77 is completed.

## 15. Release Governance / Active Wave 7
Roadmap after Reminder/Backup/Export is Release:
`E2E + build + artifact + smoke + recovery`

Active Issue #80 / PR #81:
- extend existing Android workflow
- preserve Debug artifact
- produce release-mode Candidate artifact
- verify non-empty output
- emit SHA-256 and byte-size evidence
- upload artifact + evidence

Current signing audit:
Android `release` buildType uses the debug signing config. Therefore current candidate is **not production-signed** and must not be described as Play-Store-ready.

Production signing/key management is a separate security-sensitive Slice and requires explicit verified configuration.

## 16. Automation Gap
Issue #19 remains open. Required status check enforcement is not currently verified as writable through connected tooling.

Until then, operational safety is enforced through exact-head proof + expected-head merge lock. Do not claim platform enforcement that does not exist.

## 17. Reliability / Recovery
For important changes:
`Detect → Classify → Contain → Recover → Validate → Document → Improve`

Data/release changes require rollback/recovery thinking before integration. Backup without tested recovery is not sufficient proof.

## 18. AI Decision Boundary
Routine, reversible, scoped engineering work can continue autonomously after Audit.

Extra caution/owner decision when materially changing:
- product direction
- major architecture
- destructive migration/data loss risk
- security/signing secrets
- irreversible release/publishing behavior
- major visual redesign

## 19. گزارش مالک
Owner report باید کوتاه، غیر فنی و نتیجه‌محور باشد:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Inference نباید به‌عنوان Fact گزارش شود.

## 20. فرمول توسعه
**Fast Delivery = Parallel Independent Work + Automation + Reuse + Fast Feedback + Controlled Integration + Evidence + Concurrent Documentation**

**Professional Delivery = Speed + Quality + Architecture + Recovery + Traceability**

اگر Implementation با این سند اختلاف داشت، GitHub Reality مقدم است و Current State/این سند باید اصلاح شوند.
