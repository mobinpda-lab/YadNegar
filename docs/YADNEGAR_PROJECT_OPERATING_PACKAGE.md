# YADNEGAR PROJECT OPERATING PACKAGE v1.5
## مرجع عملیاتی واحد پروژه یادنگار

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Architecture:** Feature-based + Clean boundaries + Persian RTL-first UI  
**Reality Authority:** GitHub Repository State  
**Status:** Canonical Governance

## 0. اصول غیرقابل مذاکره
1. GitHub مرجع حقیقت کد، Branch، Commit، PR، Workflow، CI، Build و مستندات است.
2. هر Session مهم با Fresh Audit شروع می‌شود؛ Conversation یا Documentation قدیمی جای Audit را نمی‌گیرد.
3. هدف، نرم‌افزار سالم در ساعت‌ها به‌جای روزهاست؛ سرعت از Parallel Work، Automation و Reuse می‌آید، نه حذف Gate.
4. Laneهای مستقل همزمان حرکت می‌کنند و Block یک Lane نباید Lane مستقل دیگر را متوقف کند.
5. Evidence فقط برای Ref/SHA دقیق معتبر است؛ Green تاریخی به Head جدید منتقل نمی‌شود.
6. قبل از ساخت Model/Repository/Storage/AppShell/Workflow/Foundation جدید، نمونه موجود Audit و reuse شود.
7. Fake Build/Test/Persistence/Release Evidence ممنوع است.
8. تغییرات پرریسک مستقیم روی `main` انجام نمی‌شوند؛ Branch/PR مسیر پیش‌فرض است.
9. تغییرات کوچک، Reviewable، Reversible و Rollback-friendly باشند.
10. مستندات همزمان با Implementation حرکت کنند و Canonical رقیب ساخته نشود.
11. Stacked preparation مجاز است، اما Merge وابسته فقط بعد از Fresh compare، Scope مستقل، Gate کامل وابستگی و post-main proof انجام می‌شود.

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
- deterministic manifest/readiness/version/release-notes/approval evidence
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
Task زمانی Ready است که objective/value، reuse audit، scope/out-of-scope، dependency، validation/evidence و parallel-safety مشخص باشند.

ابهام معماری، داده، امنیت یا انتشار قبل از تغییر پرریسک باید حل شود.

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
- one Reminder scheduling boundary

Feature جدید نباید Foundation موازی ایجاد کند مگر Audit و ADR واقعی آن را لازم کند.

Dependency direction:
`Presentation → Application → Domain`

Platform/Data implementations پشت boundary می‌مانند؛ Domain مستقیم به Flutter plugin یا storage implementation وابسته نمی‌شود.

## 7. Data Governance
Production storage فعلاً schema v2 است و v1 را backward-compatible می‌خواند.

هر schema/storage change:
`Versioning + Backward Compatibility + Migration/Safe Upgrade + Validation + Recovery/Rollback`

داده کاربر destructive rewrite نمی‌شود.
Backup/Restore باید production parser/serializer/recovery path را reuse کند؛ raw overwrite و serializer دوم ممنوع است.

Issue #93 در صورت اجرا schema v3 را فقط با backward-compatible v1/v2 reads و همان persistence path اضافه می‌کند.

## 8. Reminder Governance
Reminder روی همان TimelineItem و storage موجود سوار است.

قواعد:
- no sidecar Reminder database/repository
- notification plugin بیرون Domain
- persist-first: schedule/cancel failure نباید داده ذخیره‌شده را rollback کند
- startup/Restore reconciliation از persisted Timeline
- recurrence باید در Slice مستقل، versioned و migration-safe باشد
- exact-alarm permission فقط با نیاز واقعی محصول و compatibility proof

Current recurring-reminder proposal در Issue #93 محدود به `none / daily / weekly` است.

## 9. CI / Quality
Fast chain:
`flutter pub get → flutter analyze → flutter test`

Verified release chain:
`Fast CI → Android Build → Debug APK → Release Candidate → Manifest → Smoke/Recovery → Release Readiness → Version/Release Notes Draft → Approval/Rollback Evidence → live mergeability → expected-head merge → post-main proof`

Workflow rules:
- reuse موجود قبل از Workflow جدید
- `concurrency/cancel-in-progress` برای runهای stale
- artifact واقعی و قابل Verify
- build/Green یک SHA به SHA دیگر نسبت داده نشود
- source Head SHA از temporary PR validation SHA تفکیک شود
- downstream jobs فقط exact-run artifacts را مصرف کنند
- proposed tag فقط proposal است تا Owner/Security mutation واقعی را تأیید کند
- tag availability check حق ساخت/حرکت ref ندارد
- production approval وقتی signing blocked است باید blocked گزارش شود
- duplicate push/PR validation بدون دلیل اثبات‌شده ممنوع

## 10. Git / PR Governance
- Branch کوچک و هدفمند
- PR یک هدف اصلی
- Out-of-scope روشن
- commits قابل Review/Rollback
- stale merge ممنوع
- exact current head قبل از Merge Fresh-read شود
- Product/Release فقط با exact-head Fast CI + Android/relevant jobs و live mergeability Merge شوند
- Merge با `expected_head_sha`
- main بعد از Merge Fresh-verify شود
- stacked branch قبل از Merge نسبت به main جدید Fresh compare شود

## 11. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/relevant gates Green همان Head
4. اگر stacked است: dependency post-main Green + fresh isolated compare
5. live mergeability=true
6. `expected_head_sha=exact head`
7. post-main CI/Android proof
8. docs sync

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

GitHub Reality و Current State برای وضعیت روز مقدم‌اند.

## 13. Verified Current Baseline — 2026-08-27
Current main:
`4b792ba53a33e6153db35014ccdf3a15968a5383`

Main product flow:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Verified release capabilities:
- Debug APK artifact
- release-mode Candidate APK
- SHA-256 + byte-size evidence
- deterministic `RELEASE_MANIFEST.txt`
- exact source SHA + separate validation SHA
- Android emulator startup proof
- real `.bak` storage recovery proof
- deterministic `RELEASE_READINESS.txt`
- deterministic `RELEASE_VERSION.txt`
- deterministic `RELEASE_NOTES_DRAFT.md`
- proposed-tag availability verification without ref mutation
- deterministic `RELEASE_APPROVAL.txt`
- deterministic `ROLLBACK_PLAN.md`

### PR #90 / Issue #89
Final head: `f3aab864469135a4f1a038d00305630b36a2e9cc`

Post-main on `6f3b1de0777263201a55faac9d1af1007d4d2e25`:
- CI `33075537776`: success
- Android `33075537814`: success
- Build / Smoke-Recovery / Readiness / Draft: success

### PR #92 / Issue #91
Final head: `1990e70dfe5662aac31ed8859d7906ff274c6371`

Pre-merge:
- CI `33075612499`: success
- Android `33075612644`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

Merged with exact expected-head lock.

Post-main on current main `4b792ba53a33e6153db35014ccdf3a15968a5383`:
- CI `33076475799`: success
- Android `33076475804`: success
- Build / Smoke-Recovery / Readiness / Draft / Approval: success

Issue #91 is completed.

## 14. Release Safety Boundary
Android `release` buildType still uses debug signing config. Therefore:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

No production keystore/secret is committed.
No tag, GitHub Release or store publication has been created by current automation.

Production signing/key management is a separate security-sensitive Slice requiring verified credential ownership.
Real Tag/Release/Publish mutations require explicit Owner/Security decision after signing readiness.

## 15. Next Product Slice — Issue #93
`product: add safe recurring reminders on the existing Timeline`

Approved design direction:
- recurrence `none / daily / weekly`
- same TimelineItem and Reminder boundary
- schema v3 with backward-compatible v1/v2 reads
- same JSON parser/serializer/recovery path
- same Persian Quick Capture/Edit flow
- same Android scheduler/payload/id foundation
- focused domain/application/schema/scheduler/UI tests

No second Reminder DB/repository/storage is allowed.

## 16. Automation Gap — Issue #19
Live `main-protection` Ruleset:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks not yet Platform-level configured

Connected tooling still exposes Ruleset read but not Ruleset write.
Until write is genuinely available, exact-head proof + expected-head lock remains mandatory.

## 17. Reliability / Recovery
For important changes:
`Detect → Classify → Contain → Recover → Validate → Document → Improve`

Data/release changes require rollback/recovery thinking before integration.
Pre-release no-mutation rollback means stop safely; before future real publication, a verified previous production release/tag/artifact reference is required as rollback target.

## 18. AI Decision Boundary
Routine, reversible, scoped engineering work can continue autonomously after Audit.

Extra caution/owner decision when materially changing:
- product direction
- major architecture
- destructive migration/data loss risk
- security/signing secrets
- irreversible tag/release/publishing behavior
- major visual redesign

## 19. گزارش مالک
Owner report کوتاه، غیر فنی و نتیجه‌محور:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Inference نباید به‌عنوان Fact گزارش شود.

## 20. فرمول توسعه
**Fast Delivery = Parallel Independent Work + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Controlled Integration + Evidence + Concurrent Documentation**

**Professional Delivery = Speed + Quality + Architecture + Recovery + Traceability**

اگر Implementation با این سند اختلاف داشت، GitHub Reality مقدم است و Current State/این سند باید اصلاح شوند.
