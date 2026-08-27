# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.4 — Reminder Verified / Release Wave Active

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
`f85d804a84a4033c94e2dc843a6aa87f2d848991`

Post-main:
- YadNegar CI `33051308713`: success
- YadNegar Android Build `33051308694`: success
- APK build/verify/upload: success

Main شامل:
- Timeline واحد
- Note/Event/Call/Idea/Activity
- Persian RTL
- crash-recoverable JSON persistence
- Search / Type / Date Range
- occurredAt capture/edit
- safe Delete + Undo
- visible Export
- validated Backup/Restore
- schema-v2 optional `reminderAt`
- Persian Reminder set/clear UX
- Android local notification scheduling/cancel
- startup + Restore Reminder reconciliation
- Fast CI + Android artifact gate

هیچ Model / Repository / Storage / AppShell / Reminder DB موازی وجود ندارد.

## 3. Wave 6 — تکمیل‌شده
### Backup / Export / Restore
Foundationهای موجود reuse شوند و دوباره ساخته نشوند.

### Reminder Data Contract — PR #76 / Issue #75
Final head: `6ab46b5029b3070e43e1524431b821a766326eb2`
- CI `33046525150`: success
- Android `33046525158`: success
- merged main `fceb383aad507eed354d4b044e3939aacf5328d0`
- post-main CI `33046893279`: success
- post-main Android `33046893295`: success

Contract:
- optional reminderAt روی همان TimelineItem
- JSON write schema v2، read سازگار v1
- upgrade روی safe write
- preservation در Edit/Backup/Restore
- timeline ordering بدون تغییر

### Reminder UI / Local Notifications — PR #78 / Issue #77
Final head: `22bc0d1d855c98521dc554a770ff41e8475f532b`
- CI `33050851398`: success
- Android `33050851419`: success
- 106 tests passed
- exact Runner-generated lockfile
- expected-head merge lock

Merged main:
`f85d804a84a4033c94e2dc843a6aa87f2d848991`

Post-main:
- CI `33051308713`: success
- Android `33051308694`: success

Behavior:
- Persian set/clear Reminder
- durable persistence before schedule/cancel
- permission/scheduler failure does not lose data
- Delete cancel / Undo reschedule
- Edit refresh pending notification text
- startup/Restore reconciliation
- `flutter_local_notifications 19.5.0`
- `timezone 0.10.1`
- inexact scheduling; no exact-alarm permission
- no recurring reminders

Wave 6 is verified complete.

## 4. Lane A — Core/Data
Status: Stable.

Reuse:
- one TimelineItem
- one TimelineRepository contract
- one crash-recoverable JSON storage
- schema v2 with backward-compatible v1 reads
- validated Backup/Restore path

No new Core foundation is currently justified by live gaps.

## 5. Lane B — Product/UX
Reminder Product slice is complete and verified.

No additional Product feature should be invented before the Release wave's current gaps are closed.

## 6. Lane C — Release/Platform — Active Wave 7
Roadmap Wave 7:
`E2E + build + artifact + smoke + recovery`

### Active Slice — Issue #80 / PR #81
`release: add deterministic Android release-candidate artifact gate`

Branch: `release/android-release-candidate-gate`  
Initial head: `b0e3bf3e2846eb22ed8ae71d7676a2ae8fb9d024`

Scope:
- extend existing Android Build workflow, no duplicate workflow
- preserve Debug APK
- build release-mode Candidate APK
- verify artifact is non-empty
- emit SHA-256 and byte-size evidence
- upload Candidate APK + evidence
- preserve concurrency/cancel-in-progress

Signing audit:
Current `release` buildType uses debug signing config. Candidate is for build/reproducibility testing only; it is **not production-signed** and not Play-Store-ready.

Out of scope:
- production signing/key management
- Play Store publish
- tags/releases
- emulator E2E smoke

Follow-up after stable artifact gate:
- small Android emulator smoke/recovery slice

## 7. Lane D — CI/Automation/Docs
### Docs PR #79
Branch: `docs/current-state-reminder-contract-final`
- structurally synced onto `f85d804...`
- canonical docs refresh in progress
- temporary Reminder active-state document removed during finalization
- final diff must be docs-only
- exact-head Fast CI required

### Automation
Issue #19 remains open because required status check enforcement is not genuinely writable/verified through connected tooling.

## 8. Merge Contract
For Product/Release changes:
1. exact current head
2. YadNegar CI Green on that head
3. Android Green on that head
4. relevant artifact/build steps Green
5. live mergeability true
6. merge with `expected_head_sha`
7. post-main proof

For docs-only changes:
1. exact current head
2. Fast CI Green
3. live mergeability true
4. expected-head lock
5. post-main Fast CI

Historical Green never transfers to a new head.

## 9. خط قرمز
- duplicate foundation/workflow/storage
- fake CI/build/persistence/release evidence
- stale merge evidence
- stale docs
- direct risky main edits
- sidecar Reminder storage
- recurring Reminder mixed into current scope
- production-signing claim without verified signing config
- Play Store claim without actual release/publish proof
- stopping independent lanes because another runner is busy

## 10. Queue
### Active
1. PR #79 — canonical docs finalization
2. Issue #80 / PR #81 — deterministic Android Release Candidate artifact gate
3. Issue #19 — Ruleset enforcement gap

### Next
4. Android emulator smoke/recovery proof after #81
5. production signing/release governance only after a separate security/signing audit

## 11. اصل سرعت
`Parallel Independent Work + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
کوتاه و غیر فنی:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
