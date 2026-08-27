# YADNEGAR PROJECT OPERATING PACKAGE v1.7
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
4. Laneهای مستقل همزمان حرکت می‌کنند؛ Block یک Lane، Lane مستقل دیگر را متوقف نمی‌کند.
5. Evidence فقط برای Ref/SHA دقیق معتبر است؛ Green تاریخی به Head جدید منتقل نمی‌شود.
6. قبل از Foundation جدید، موجودی فعلی Audit و reuse شود.
7. Fake Build/Test/Persistence/Release Evidence ممنوع است.
8. تغییر پرریسک مستقیم روی `main` انجام نمی‌شود؛ Branch/PR مسیر پیش‌فرض است.
9. تغییرات کوچک، Reviewable، Reversible و Rollback-friendly باشند.
10. مستندات همزمان با Implementation حرکت کنند و Canonical رقیب ساخته نشود.
11. Stacked preparation مجاز است، اما Merge وابسته فقط بعد از Fresh compare، Scope مستقل، dependency post-main Green و Gate کامل انجام می‌شود.

## 1. ترتیب مرجع حقیقت
`GitHub Reality > approved architecture decisions > this canonical package > current execution docs > conversation memory`

در اختلاف منابع:
`Verify GitHub → identify discrepancy → repair docs → preserve material history`

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

## 3. مدل Maximum Parallel
### Lane A — Core / Data
- Domain contracts
- Timeline model/repository
- Persistence, schema, migration, recovery

### Lane B — Product / UX
- Persian RTL
- Timeline / Quick Capture
- Search/Filter/Edit/Delete/Undo
- Backup/Restore/Reminder UX

### Lane C — Release / Platform
- Android build/release candidate
- deterministic manifest/readiness/version/release-notes/approval evidence
- emulator smoke/recovery
- production signing فقط بعد از Audit امنیتی و تعیین مالک credentials

### Lane D — CI / Automation / Documentation
- GitHub Actions
- Analyze/Test/Build
- exact-run evidence
- Current State / Handoff / Operation Plan / Canonical sync

Rule:
`Detect overlap → assign ownership → execute independently → validate → integrate`

## 4. Definition of Ready / Done
Ready:
- objective/value روشن
- reuse audit انجام‌شده
- scope/out-of-scope مشخص
- dependencies و evidence معلوم
- parallel-safety مشخص

Done:
`Working Change + Tests/Validation + Exact Evidence + Documentation + Safe Integration`

## 5. معماری و Reuse Contract
Current implementation یک foundation مشترک دارد:
- one `TimelineItem`
- one `TimelineRepository` contract
- one crash-recoverable JSON storage
- one App Shell / Timeline flow
- one schema-versioned parser/serializer path
- one Reminder scheduling boundary

Feature جدید نباید Foundation موازی ایجاد کند مگر Audit و ADR واقعی آن را لازم کند.

Dependency direction:
`Presentation → Application → Domain`

Platform/Data implementations پشت boundary می‌مانند.

## 6. Data Governance
Production storage اکنون schema v3 است.

Compatibility:
- v1 reads supported
- v2 reads supported
- v3 reads/writes current
- legacy read نباید فایل را mutation کند
- اولین safe write از همان staging/tmp/bak path موجود نسخه قدیمی را به v3 می‌برد

Schema v3 recurrence contract:
- `none`
- `daily`
- `weekly`
- recurrence بدون `reminderAt` به `none` normalize می‌شود

هر schema/storage change:
`Versioning + Backward Compatibility + Migration/Safe Upgrade + Validation + Recovery/Rollback`

داده کاربر destructive rewrite نمی‌شود. Backup/Restore باید production parser/serializer/recovery path را reuse کند.

## 7. Reminder Governance
Reminder روی همان TimelineItem و storage موجود سوار است.

قواعد:
- no sidecar Reminder database/repository
- notification plugin بیرون Domain
- persist-first: schedule/cancel failure نباید داده ذخیره‌شده را rollback کند
- startup/Restore reconciliation از persisted Timeline
- recurring reminders محدود به contract versioned موجود باشند
- exact-alarm permission فقط با نیاز واقعی و compatibility proof

Recurring reminder behavior:
- `none`: one-shot فعلی
- `daily`: device-local clock time
- `weekly`: device-local weekday + clock time
- recurrence قدیمی باید به occurrence بعدی آینده منتقل شود
- device timezone قبل از reconciliation تعیین شود
- اگر timezone قابل Verify نیست، recurrence fail-closed باشد؛ UTC fallback ساختگی ممنوع است

Presentation rule after recurrence foundation:
- reminder state may be surfaced directly on Timeline cards by reusing existing `TimelineItem` fields
- no second read/query/storage path is needed for reminder summaries

## 8. CI / Quality
Fast chain:
`flutter pub get → flutter analyze → flutter test`

Release chain:
`Fast CI → Android Build → Debug APK → Release Candidate → Manifest → Smoke/Recovery → Release Readiness → Version/Release Notes Draft → Approval/Rollback Evidence → live mergeability → expected-head merge → post-main proof`

Rules:
- reuse موجود قبل از Workflow جدید
- artifact واقعی و قابل Verify
- Green یک SHA به SHA دیگر نسبت داده نشود
- source Head SHA از temporary PR validation SHA تفکیک شود
- downstream jobs exact-run artifacts را مصرف کنند
- no duplicate validation بدون دلیل

## 9. Git / PR Governance
- Branch کوچک و هدفمند
- PR یک هدف اصلی
- Out-of-scope روشن
- stale merge ممنوع
- exact current head قبل از Merge Fresh-read شود
- Product/Release فقط با exact-head Fast CI + Android/relevant jobs + live mergeability
- Merge با `expected_head_sha`
- main بعد از Merge Fresh-verify شود
- stacked branch قبل از Merge نسبت به main جدید Fresh compare شود

## 10. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/relevant gates Green همان Head
4. stacked dependency post-main Green + Fresh isolated compare
5. live mergeability=true
6. `expected_head_sha=exact head`
7. post-main CI/Android proof
8. docs sync

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. exact expected-head lock
5. post-main Fast CI proof

Historical Green برای Head جدید قابل انتقال نیست.

## 11. Documentation-as-Code
Canonical:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

Execution plan:
`docs/YADNEGAR_OPERATION_PLAN.md`

Current state:
`docs/AI_CONTINUATION_STATE.md`

Persian Handoff:
`docs/AI_HANDOFF_CURRENT_FA.md`

Historical/product reference:
`docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

GitHub Reality و Current State برای وضعیت روز مقدم‌اند.

## 12. Verified Current Baseline — 2026-08-27
Current main:
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Product flow:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Release Governance کامل و post-main Green است.

### Recurring Foundation — PR #96 / Issue #94
Final head:
`225c948eac7a95e63d5618254fab7e6213a5c835`

Pre-merge:
- CI `33078963061`: success
- Android `33078963046`: success

Post-main:
- CI `33079988610`: success
- Android `33079988616`: success

### Scheduler + Persian UX — PR #97 / Issue #95
Final head:
`79bc8d84e8bab563ab63a688448fbf26d3a51dad`

Pre-merge:
- CI `33080762656`: success
- Android `33080762586`: success

Merged main:
`1610e3221c1eec9af6de0f4b16b45d2fdfc9ebf6`

Post-main:
- CI `33081668902`: success
- Android `33081668913`: success

Current main therefore includes the complete safe `none/daily/weekly` recurring-reminder behavior using device-local timezone and the existing Timeline/Reminder foundations.

### Active Docs Closure — PR #98
PR #98 synchronizes all four canonical/live docs with the completed product outcome.

It must pass a fresh exact-head Fast CI after the final factual refresh, merge with exact expected-head lock, and receive post-main Fast CI proof before parent #93 closes.

### Next Product Candidate — Issue #99
`product: surface reminder status on Timeline cards`

Planned scope:
- presentation-only reuse of existing reminder fields
- one-shot date/time summary
- daily clock summary
- weekly weekday/clock summary
- focused widget tests

No schema/repository/storage/scheduler/navigation foundation change.

## 13. Release Safety Boundary
Android release build still uses debug signing config:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

No production keystore/secret committed. No real tag, GitHub Release or store publication created.

Production signing/key management is a separate security-sensitive Slice requiring verified credential ownership and explicit Owner/Security decision.

## 14. Automation Gap — Issue #19
Live main protection requires PR and blocks deletion/non-fast-forward, but required status checks are not yet Platform-level enforced.

Connected tooling exposes Ruleset read but no Ruleset write.

Until writable enforcement exists:
`exact current head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## 15. Reliability / Recovery
For important changes:
`Detect → Classify → Contain → Recover → Validate → Document → Improve`

Data/release changes require rollback/recovery thinking before integration.

## 16. AI Decision Boundary
Routine reversible scoped engineering work can continue autonomously after Audit.

Extra owner/security decision for:
- major product direction
- major architecture
- destructive migration/data-loss risk
- production signing/secrets
- irreversible tag/release/publishing
- major visual redesign

## 17. گزارش مالک
کوتاه، غیر فنی و نتیجه‌محور:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

Inference نباید Fact گزارش شود.

## 18. فرمول توسعه
**Fast Delivery = Maximum Parallel + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation**

**Professional Delivery = Speed + Quality + Architecture + Recovery + Traceability**

اگر Implementation با این سند اختلاف داشت، GitHub Reality مقدم است و این سند باید اصلاح شود.
