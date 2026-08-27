# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.8 — Release Draft Integrated / Approval Gate Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در ساعت‌ها به‌جای روزها.

چرخه:
`Fresh Audit → Reuse → Small/Stacked Safe Slice → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Stacked preparation فقط وقتی مجاز است که بعد از Merge وابستگی، Fresh compare Scope مستقل را اثبات کند.

## 2. main فعلی
Current main:
`6f3b1de0777263201a55faac9d1af1007d4d2e25`

Main شامل:
- Release Candidate gate
- deterministic SHA/size evidence
- Android Emulator/Recovery gate
- deterministic `RELEASE_MANIFEST.txt`
- deterministic `RELEASE_READINESS.txt`
- deterministic `RELEASE_VERSION.txt`
- deterministic `RELEASE_NOTES_DRAFT.md`
است.

### Integration — PR #88 / Issue #87
Candidate Readiness روی Head `32d2b6de...` با CI `33073336472` و Android `33073336417` کامل Green شد و با expected-head lock Merge شد.

Post-main روی `8656564b...`:
- CI `33074363600`: success
- Android `33074363581`: success
- Build: success
- Smoke/Recovery: success
- Release Readiness: success

### آخرین Integration — PR #90 / Issue #89
Version + Release Notes Draft روی Head:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Pre-merge:
- CI `33074488110`: success
- Android `33074488158`: success
- Build: success
- Smoke/Recovery: success
- Readiness: success
- Release Draft: success

Merge با exact `expected_head_sha` انجام شد و main به `6f3b1de...` رسید.

Post-main:
- CI `33075537776`: active هنگام این revision
- Android `33075537814`: active هنگام این revision

## 3. Product Foundation — Stable
Main شامل:
- Timeline واحد
- Note/Event/Call/Idea/Activity
- Persian RTL
- crash-recoverable JSON persistence
- Search / Type / Date Range
- occurredAt capture/edit
- safe Delete + Undo
- Export
- validated Backup/Restore
- schema-v2 optional reminderAt
- Persian Reminder UX
- Android local notifications
- startup + Restore Reminder reconciliation

هیچ Model / Repository / Storage / AppShell / Reminder DB موازی وجود ندارد.

## 4. Release Foundation — Verified
زنجیره فعلی:
`Fast CI → Debug APK → Release Candidate → SHA/size → Release Manifest → Emulator Smoke → Real Storage Recovery → Release Readiness → Version/Release Notes Draft`

Evidenceها exact-run و exact-source-SHA هستند. source SHA با temporary validation SHA اشتباه نمی‌شود.

Current release mode هنوز debug-signed است و Production-signed نیست.

## 5. Release Governance — Active
### Active Slice — Issue #91 / PR #92
`release: prove tag availability and emit approval rollback package`

Branch:
`release/approval-rollback-package`

Exact head:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Fresh compare بعد از Merge #90 Scope را به دو فایل محدود کرد:
- `.github/scripts/release-approval.sh`
- `.github/workflows/android-build.yml`

Scope:
- reuse Release Version + Readiness exact-run
- تطبیق source SHA
- بررسی availability Tag پیشنهادی از remote بدون mutation
- fail-closed روی Tag collision یا lookup نامعتبر
- تولید `RELEASE_APPROVAL.txt`
- تولید `ROLLBACK_PLAN.md`
- ثبت `approval_state=blocked-production-signing`
- ثبت اینکه هیچ Tag/Release/Publish/Signing mutation انجام نشده است

Validation شروع‌شده:
- Fast CI `33075612499`
- Android `33075612644`

Out of scope:
- ساخت/جابجایی Tag
- GitHub Release
- Play Store publish
- Production signing
- secret/keystore
- Product/Core behavior change

## 6. Automation / Docs
### Automation
Issue #19 باز است.

Ruleset فعلی:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks هنوز Platform-level enforce نشده‌اند

Fresh tool discovery همچنان فقط Ruleset Read دارد؛ Write واقعی در دسترس نیست.

### Documentation
Active docs PR:
`#86 — docs: sync Wave 7 completion and release governance`

Branch:
`docs/release-wave7-final`

چهار سند اجرایی با GitHub Reality هم‌زمان Sync می‌شوند:
- Current State
- Persian Handoff
- Operation Plan
- Canonical Governance

Docs-only PR فقط بعد از exact-head Fast CI و Fresh mergeability Merge شود.

## 7. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android Build Green همان Head
4. relevant artifact/manifest/smoke/recovery/readiness/draft/approval jobs Green
5. dependency post-main Green در Sliceهای stacked
6. live mergeability=true
7. merge با `expected_head_sha`
8. post-main proof

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. expected-head lock
5. post-main Fast CI

Historical Green برای Head جدید معتبر نیست.

## 8. خط قرمز
- duplicate workflow/foundation/storage
- fake CI/build/release evidence
- stale merge evidence
- stale docs
- direct risky main edit
- secret/keystore داخل Repository
- production-signing claim بدون verified signing config
- Tag/Release/Play Store mutation بدون تصمیم Owner/Security
- دورزدن Gate برای سرعت

## 9. Queue
### Active
1. post-main proof برای PR #90 روی main `6f3b1de...`
2. PR #92 / Issue #91 — tag availability + approval/rollback evidence
3. PR #86 — concurrent documentation sync
4. Issue #19 — required-status enforcement gap

### Next
5. post-main proof برای #92 در صورت Merge
6. docs-only final integration
7. Production signing فقط در Slice امنیتی جدا بعد از تعیین مالکیت keystore/credentials
8. هر Tag/Release/Publish واقعی فقط پس از Production signing و تصمیم صریح مالک

## 10. اصل سرعت
`Parallel Independent Work + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
