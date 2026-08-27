# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.5 — Release Candidate Verified / Emulator Smoke Active

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

## 2. main فعلی و Proof
Verified main:
`59eea7a8451e646145d027629f07a110e50ffbf2`

این main شامل PR #81 است:
`release: add deterministic Android release-candidate artifact gate`

PR #81 final head:
`b0e3bf3e2846eb22ed8ae71d7676a2ae8fb9d024`

Exact-head قبل از Merge:
- quality `33051771284`: success
- android-build `33051771332`: success

Post-main:
- quality `33066010366`: success
- android-build `33066010346`: success
- Debug APK build/verify/upload: success
- Release-mode Candidate APK build/verify/upload: success

Release Candidate evidence:
- non-empty APK
- SHA-256
- byte size

Signing audit:
Android `release` فعلی از debug signing config استفاده می‌کند. Candidate فعلی فقط برای build/reproducibility proof است و **production-signed / Play-Store-ready نیست**.

## 3. Foundation محصول — Stable
Main شامل:
- Timeline واحد
- Note/Event/Call/Idea/Activity
- Persian RTL
- crash-recoverable schema-v2 JSON persistence با read سازگار v1
- Search / Type / Date Range
- occurredAt capture/edit
- safe Delete + Undo
- visible Export
- validated Backup/Restore
- optional reminderAt
- Persian Reminder UX
- Android local notifications
- startup + Restore Reminder reconciliation

هیچ Model / Repository / Storage / AppShell / Reminder DB موازی وجود ندارد.

Foundationهای تکمیل‌شده دوباره ساخته نشوند:
- PR #81 / Issue #80 — Release Candidate artifact gate
- PR #78 / Issue #77 — Reminder UI/local notifications
- PR #76 / Issue #75 — Reminder schema contract
- PR #73 / Issue #70 — Restore
- PR #68 / Issue #67 — Backup
- PR #65 / Issue #64 — Export
- PR #63 / Issue #59 — Undo
- PR #61 / Issue #57 — Delete
- PR #45 — CI dedupe

## 4. Lane A — Core/Data
Status: Stable.

Reuse:
- one TimelineItem
- one TimelineRepository contract
- one crash-recoverable JSON storage
- production recovery path: primary / `.tmp` / `.bak`
- validated Backup/Restore

هیچ Foundation داده‌ای جدید برای Slice فعلی لازم نیست.

## 5. Lane B — Product/UX
Status: Stable.

Feature جدید محصول تا بسته‌شدن Gap فعلی Release ساخته نشود.

## 6. Lane C — Release/Platform — Active Wave 7
Roadmap:
`E2E + build + artifact + smoke + recovery`

### Completed — Issue #80 / PR #81
Deterministic Android Release Candidate artifact gate روی main Merge و Verify شده است.

### Active — Issue #82 / PR #83
`release: prove Android emulator smoke and storage recovery`

Branch:
`release/android-emulator-smoke-recovery`

Current exact head:
`1ffe17bd45b7dbaae5e75ab730fe21579b3267f7`

Current runs:
- YadNegar CI `33067893613`
- YadNegar Android Build `33067893659`

Fresh execution state هنگام این سند:
- Fast CI: success
- Android `android-build`: success
- Debug APK: build/verify/upload success
- Release Candidate: build/verify/upload success
- `android-smoke-recovery`: active؛ هنوز تا Fresh-read پایان کار Green گزارش نشود

Smoke/Recovery scope:
- reuse همان Android workflow
- مصرف exact-run Debug APK
- Android Emulator واقعی
- install + launch package `com.mobinpda.lab.yadnegar`
- seed schema-v2 `timeline.json` در storage واقعی app با `run-as`
- force-stop
- شبیه‌سازی primary missing + valid `.bak`
- relaunch و اثبات Recovery از مسیر production repository
- حفظ data marker
- cleanup `.bak` / `.tmp`
- crash-buffer check
- evidence artifact شامل logcat/activity/storage/screenshot

CI safety:
`release/**` عمداً به push trigger اضافه نشده تا duplicate push/PR run مشابه مشکل حل‌شده PR #45 برنگردد.

## 7. Lane D — CI/Automation/Docs
### Documentation
Current active docs branch:
`docs/release-smoke-active-state`

Canonical current-state/Handoff/Operation docs همزمان با Release lane در حال sync هستند. Merge Docs فقط بعد از exact-head Fast CI و Fresh mergeability انجام شود.

### Automation
Issue #19 باز است.

Live Ruleset `main-protection`:
- prevent deletion
- prevent non-fast-forward
- require pull request
- required status checks هنوز Platform-level تنظیم نشده‌اند

Connected tooling فعلی Ruleset را می‌خواند ولی write action در دسترس ندارد. تا زمان امکان Write واقعی، نباید ادعای enforcement پلتفرمی شود.

## 8. Merge Contract
### Product / Release
1. exact current head
2. quality Green روی همان head
3. Android Green روی همان head
4. relevant build/artifact/smoke jobs Green
5. live mergeability=true
6. merge با `expected_head_sha`
7. post-main proof

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. expected-head lock
5. post-main Fast CI proof

Historical Green برای Head جدید معتبر نیست.

## 9. خط قرمز
- duplicate foundation/workflow/storage
- fake CI/build/persistence/release evidence
- stale merge evidence
- stale docs
- direct risky main edits
- sidecar Reminder storage
- production-signing claim بدون verified signing config
- Play Store claim بدون release/publish proof
- دورزدن Gate برای سرعت
- متوقف‌کردن Lane مستقل به‌خاطر Runner دیگر

## 10. Queue
### Active
1. PR #83 — Android Emulator startup + storage recovery proof
2. docs/release-smoke-active-state — concurrent documentation
3. Issue #19 — Ruleset enforcement gap

### بعد از PR #83
4. post-main smoke/recovery proof
5. canonical docs final refresh
6. Production signing/release governance فقط در Slice امنیتی جدا و پس از owner/security audit

## 11. اصل سرعت
`Parallel Independent Work + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
