# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.7 — Release Manifest Verified / Readiness Gate Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در ساعت‌ها به‌جای روزها.

چرخه:
`Fresh Audit → Reuse → Small PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند.

## 2. main فعلی
Verified main:
`a29fe46ba9c9c50be107e36b6c618ddc1a0c6e95`

این main شامل:
- Release Candidate gate
- deterministic SHA/size evidence
- Android Emulator/Recovery gate
- deterministic `RELEASE_MANIFEST.txt`
است.

### آخرین Integration — PR #85 / Issue #84
Final PR head:
`2a456003899ec24ab310a86f5f521c68a97fb483`

Pre-merge:
- CI `33070804473`: success
- Android `33070804465`: success
- Build: success
- Manifest: success
- Smoke/Recovery: success

Post-main روی `a29fe46...`:
- CI `33071541211`: success
- Android `33071541182`: success
- android-build: success
- android-smoke-recovery: success

Issue #84 completed است.

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
Verified chain:
`Fast CI → Debug APK → Release Candidate → SHA/size → Release Manifest → Emulator Smoke → Real Storage Recovery`

Manifest اطلاعات زیر را به‌صورت deterministic ثبت می‌کند:
- app version
- application id
- exact source SHA
- validation SHA
- APK SHA-256
- byte size
- signing state
- release class

Current release mode هنوز debug-signed است و Production-signed نیست.

## 5. Release Governance — Active
### Active Slice — Issue #87 / PR #88
`release: aggregate candidate readiness evidence`

Branch:
`release/candidate-readiness-evidence`

Exact head هنگام این بروزرسانی:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Scope:
- reuse همان Android workflow
- حفظ Build/Manifest/Smoke/Recovery
- افزودن dependent job به نام `release-readiness`
- دانلود exact-run Candidate evidence
- دانلود exact-run Smoke/Recovery evidence
- تطبیق Manifest با source Head SHA
- Verify کردن startup/recovery/storage marker/staging cleanup
- تولید `RELEASE_READINESS.txt`
- گزارش صریح Production signing blocker

Validation فعلی:
- Fast CI `33073336472`: success
- Android `33073336417`: active هنگام این revision؛ Fresh-read الزامی است

Out of scope:
- keystore/secret واقعی
- Production signing
- Play Store publish
- tag/release mutation
- Product/Core behavior change

## 6. Automation / Docs
### Automation
Issue #19 باز است.

Ruleset فعلی:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks هنوز Platform-level enforce نشده‌اند

Connected tooling در Fresh audit فعلی Ruleset Write ارائه نمی‌کند.

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
4. relevant artifact/smoke/recovery/readiness jobs Green
5. live mergeability=true
6. merge با `expected_head_sha`
7. post-main proof

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
- Play Store claim بدون publish proof
- دورزدن Gate برای سرعت

## 9. Queue
### Active
1. PR #88 / Issue #87 — aggregate Candidate readiness evidence
2. PR #86 — concurrent canonical/current-state documentation sync
3. Issue #19 — required-status enforcement gap

### Next
4. post-main proof برای هر Merge
5. Release Notes/Version/Tag governance فقط با Evidence واقعی و بدون Publish خودکار
6. Production signing در Slice امنیتی جدا بعد از تعیین مالکیت keystore/credentials

## 10. اصل سرعت
`Parallel Independent Work + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
