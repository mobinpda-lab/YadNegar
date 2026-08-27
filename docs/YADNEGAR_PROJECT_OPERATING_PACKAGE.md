# YADNEGAR PROJECT OPERATING PACKAGE v1.4
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
2. هر Session مهم با Fresh Audit شروع می‌شود؛ Conversation یا Documentation قدیمی جای Audit را نمی‌گیرد.
3. هدف، نرم‌افزار سالم در ساعت‌ها به‌جای روزهاست. سرعت از Parallel Work، Automation، reuse و حذف انتظار می‌آید؛ نه از حذف Gate.
4. Laneهای مستقل همزمان حرکت می‌کنند. Block یک Lane نباید Lane مستقل دیگر را متوقف کند.
5. Evidence فقط برای Ref/SHA دقیق معتبر است. Green تاریخی برای Head جدید معتبر نیست.
6. قبل از ساخت Model/Repository/Storage/AppShell/Workflow/Foundation جدید، نمونه موجود Audit و reuse شود.
7. Fake Build/Test/Persistence/Release Evidence ممنوع است.
8. تغییرات پرریسک مستقیماً روی `main` انجام نمی‌شوند؛ Branch/PR مسیر پیش‌فرض است.
9. تغییرات کوچک، قابل Review، قابل Rollback و با Scope روشن باشند.
10. مستندات همزمان با Implementation حرکت کنند و سند اجرایی رقیب ساخته نشود.
11. Stacked preparation برای کاهش زمان انتظار مجاز است، اما Merge وابسته فقط بعد از Fresh compare، Scope مستقل، Gate کامل وابستگی و post-main proof انجام می‌شود.

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
10. Docs همزمان Sync و گزارش مالک کوتاه ارائه شود.

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
- deterministic artifact/manifest/readiness/version/release-notes/approval evidence
- emulator smoke/recovery
- release governance
- production signing فقط بعد از Audit امنیتی و تعیین مالک credentials

### Lane D — CI / Automation / Documentation
- GitHub Actions
- Analyze/Test/Build
- stale-run cancellation
- exact-run evidence capture
- Current State / Handoff / Operation Plan / Canonical sync

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

ابهام کوچک نباید پروژه را متوقف کند؛ ابهام معماری، داده، امنیت یا انتشار قبل از تغییر پرریسک باید حل شود.

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

Platform/Data implementations پشت boundary می‌مانند؛ Domain مستقیم به Flutter plugin یا storage implementation وابسته نمی‌شود.

## 7. Data Governance
Production storage schema v2 است و v1 را backward-compatible می‌خواند.

هر schema/storage change مهم حسب مورد:
`Versioning + Backward Compatibility + Migration/Safe Upgrade + Validation + Recovery/Rollback`

داده کاربر destructive rewrite نمی‌شود.
Backup/Restore باید production parser/serializer/recovery path را reuse کند؛ raw overwrite و serializer دوم ممنوع است.

## 8. Reminder Governance
Reminder روی همان TimelineItem و storage موجود سوار است.

قواعد:
- no sidecar Reminder database/repository
- notification plugin بیرون Domain
- persist-first: schedule/cancel failure نباید داده ذخیره‌شده را rollback کند
- startup/Restore reconciliation از persisted Timeline
- recurring reminders فقط در Slice جدا پس از Audit
- exact-alarm permission فقط با نیاز واقعی محصول و compatibility proof

## 9. CI / Quality
Fast chain:
`flutter pub get → flutter analyze → flutter test`

Release chain فعلی:
`Fast CI → Android Build → Debug APK → Release Candidate → Manifest → Smoke/Recovery → Release Readiness → Version/Release Notes Draft → Approval/Rollback Evidence → live mergeability → expected-head merge → post-main proof`

Workflow rules:
- reuse موجود قبل از Workflow جدید
- `concurrency/cancel-in-progress` برای runهای stale
- artifact باید واقعی و قابل Verify باشد
- build/Green یک SHA به SHA دیگر نسبت داده نشود
- source Head SHA از temporary PR validation SHA تفکیک شود
- downstream jobs باید exact-run artifacts را مصرف کنند، نه artifact تاریخی
- proposed tag فقط proposal است تا زمانی که Owner/Security mutation واقعی را تأیید کند
- tag availability check حق ساخت یا حرکت ref ندارد
- production approval وقتی signing blocked است باید blocked گزارش شود
- PR validation نباید با push trigger تکراری شود مگر دلیل اثبات‌شده وجود داشته باشد

## 10. Git / PR Governance
- Branch کوچک و هدفمند
- PR یک هدف اصلی
- Out-of-scope روشن
- commits قابل Review/Rollback
- stale merge ممنوع
- قبل از Merge exact current head دوباره خوانده شود
- Merge محصول/Release فقط با exact-head Fast CI + Android/relevant jobs و live mergeability
- Merge با `expected_head_sha`
- بعد از Merge، main تازه Verify شود
- stacked branch قبل از Merge باید نسبت به main جدید Fresh compare شود و فقط Scope خودش را نشان دهد

## 11. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/Release Gate Green همان Head
4. relevant artifact/manifest/smoke/recovery/readiness/draft/approval jobs Green
5. اگر Slice stacked است، dependency post-main Green و Fresh compare Scope مستقل
6. live mergeability=true
7. `expected_head_sha=exact head`
8. post-main CI/Android proof

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. expected-head lock
5. post-main Fast CI proof

Historical Green برای Head جدید قابل انتقال نیست.

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

Comprehensive document یک Snapshot/reference است؛ Current State و GitHub Reality برای وضعیت روز مقدم‌اند.

## 13. Verified Current Baseline — 2026-08-27
Current main:
`6f3b1de0777263201a55faac9d1af1007d4d2e25`

### Integrated Candidate Readiness — PR #88 / Issue #87
Final head:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Pre-merge exact-head:
- CI `33073336472`: success
- Android `33073336417`: success
- Build / Smoke-Recovery / Readiness: success

Post-main on `8656564b...`:
- CI `33074363600`: success
- Android `33074363581`: success
- Build / Smoke-Recovery / Readiness: success

### Integrated Version + Release Notes Draft — PR #90 / Issue #89
Final head:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Pre-merge exact-head:
- CI `33074488110`: success
- Android `33074488158`: success
- Build / Smoke-Recovery / Readiness / Release Draft: success

Merged with exact expected-head lock to current main `6f3b1de...`.

Post-main runs `33075537776` and `33075537814` were active at this canonical revision and require Fresh-read before final Green claim.

Main product flow:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Verified release capabilities now include:
- Debug APK artifact
- release-mode Candidate APK
- SHA-256 + byte-size evidence
- deterministic `RELEASE_MANIFEST.txt`
- version + application id
- exact source SHA + separate validation SHA
- explicit signing state
- Android emulator startup proof
- real `.bak` storage recovery proof
- deterministic `RELEASE_READINESS.txt`
- deterministic `RELEASE_VERSION.txt`
- deterministic `RELEASE_NOTES_DRAFT.md`

## 14. Release Governance — Active
Active Issue #91 / PR #92:
`release: prove tag availability and emit approval rollback package`

Exact head:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Fresh compare after #90 merge proves Scope remains isolated to:
- `.github/scripts/release-approval.sh`
- `.github/workflows/android-build.yml`

Purpose:
- preserve all existing gates
- consume exact-run Release Version + Readiness evidence
- verify exact source SHA
- verify proposed tag availability from remote without mutation
- fail closed on collision/lookup ambiguity
- emit `RELEASE_APPROVAL.txt`
- emit `ROLLBACK_PLAN.md`
- explicitly keep approval blocked while debug signing remains

Exact-head runs started:
- CI `33075612499`
- Android `33075612644`

Current signing audit:
Android `release` buildType uses debug signing config. Therefore current candidate is **not production-signed** and must not be described as Play-Store-ready.

Production signing/key management is a separate security-sensitive Slice and requires explicit verified credentials ownership. Secrets/keystore must never be committed to repository.

Tag creation, GitHub Release creation and store publication are irreversible/release mutations and require explicit owner/security approval after signing readiness.

## 15. Automation Gap
Issue #19 remains open.

Live `main-protection` Ruleset:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks are not yet configured at Platform level

Fresh tool discovery still exposes Ruleset read but not Ruleset write.
Until write is genuinely available, operational exact-head proof + expected-head lock remains mandatory. Do not claim platform enforcement that does not exist.

## 16. Reliability / Recovery
For important changes:
`Detect → Classify → Contain → Recover → Validate → Document → Improve`

Data/release changes require rollback/recovery thinking before integration. Backup without tested recovery is not sufficient proof.

Pre-release automation that performs no tag/release/publish mutation must state that rollback is currently a no-mutation stop. Before future real publication, a verified previous production release/tag/artifact reference is required as the rollback target.

## 17. AI Decision Boundary
Routine, reversible, scoped engineering work can continue autonomously after Audit.

Extra caution/owner decision when materially changing:
- product direction
- major architecture
- destructive migration/data loss risk
- security/signing secrets
- irreversible tag/release/publishing behavior
- major visual redesign

## 18. گزارش مالک
Owner report کوتاه، غیر فنی و نتیجه‌محور:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Inference نباید به‌عنوان Fact گزارش شود.

## 19. فرمول توسعه
**Fast Delivery = Parallel Independent Work + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Controlled Integration + Evidence + Concurrent Documentation**

**Professional Delivery = Speed + Quality + Architecture + Recovery + Traceability**

اگر Implementation با این سند اختلاف داشت، GitHub Reality مقدم است و Current State/این سند باید اصلاح شوند.
