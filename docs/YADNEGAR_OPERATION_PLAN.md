# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.6 — Wave 7 Verified / Release Governance Active

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
`9ffa1041c3205a35d0aa0744236e9e4dcbb28333`

این main شامل Release Candidate gate و Android Emulator/Recovery gate است.

PR #83 final head:
`60d1f21ce3574e3b6c04478351136acf35e9e8e7`

Pre-merge proof:
- CI `33069328808`: success
- Android `33069328907`: success
- android-build: success
- android-smoke-recovery: success

Post-main:
- CI `33070027775`: success
- Android `33070027900`: در زمان این commit هنوز active؛ Fresh-read نهایی الزامی است

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

## 4. Wave 7 — Verified Complete
Contract:
`E2E + build + artifact + smoke + recovery`

Completed:
- PR #81 / Issue #80 — deterministic Android Release Candidate artifact gate
- PR #83 / Issue #82 — Android emulator startup + real storage recovery proof

Current release mode هنوز debug-signed است و Production-signed نیست.

## 5. Release Governance — Active
سند جامع Release Governance را بعد از Release Candidate چنین تعریف می‌کند:
`version/tag + exact SHA + validation evidence + release notes + rollback/recovery`

### Active Slice — Issue #84 / PR #85
`release: add deterministic release manifest evidence`

Branch:
`release/deterministic-release-manifest`

Initial head:
`cb8bd2d23dfc06bdb8f8ab20869dabb8edbfd340`

Scope:
- reuse همان Android workflow
- حفظ Debug APK، Candidate و Smoke/Recovery
- افزودن `RELEASE_MANIFEST.txt`
- ثبت version از `pubspec.yaml`
- ثبت application id
- ثبت exact source SHA
- ثبت APK SHA-256 و size
- ثبت signing state صریح

Out of scope:
- keystore/secret واقعی
- Production signing
- Play Store publish
- tag/release mutation

## 6. Automation / Docs
### Automation
Issue #19 باز است.

Ruleset `main-protection`:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks هنوز Platform-level تنظیم نشده‌اند

Fresh tool audit در 2026-08-27 فقط Ruleset Read دارد، نه Write.

### Documentation
Active docs branch:
`docs/release-wave7-final`

هدف:
- Current State
- Persian Handoff
- Operation Plan
را با Wave 7 و Release Governance هم‌تراز کند.

Docs-only PR فقط بعد از exact-head Fast CI و Fresh mergeability Merge شود.

## 7. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green
3. Android Build Green
4. relevant build/artifact/smoke jobs Green
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
1. PR #85 — deterministic Release Manifest evidence
2. docs/release-wave7-final — canonical current-state sync
3. Issue #19 — Ruleset enforcement gap

### Next
4. post-main proof برای هر Merge
5. Release Notes/Version/Tag governance فقط با Evidence واقعی
6. Production signing در Slice امنیتی جدا بعد از تعیین مالکیت keystore/credentials

## 10. اصل سرعت
`Parallel Independent Work + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
