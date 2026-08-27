# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `59eea7a8451e646145d027629f07a110e50ffbf2`

این main شامل PR #81 است:
`release: add deterministic Android release-candidate artifact gate`

Final head PR #81:
`b0e3bf3e2846eb22ed8ae71d7676a2ae8fb9d024`

Exact-head قبل از Merge:
- quality run `33051771284`: success
- android-build run `33051771332`: success

Post-main روی `59eea7a8451e646145d027629f07a110e50ffbf2`:
- quality run `33066010366`: success
- android-build run `33066010346`: success
- Debug APK: success
- Release-mode Candidate APK + SHA-256/size evidence: success

مهم: `release` فعلی هنوز با debug signing config امضا می‌شود؛ Candidate فعلی production-signed نیست و Play-Store-ready محسوب نمی‌شود.

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore → Reminder`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem مشترک
- فارسی و RTL
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- Delete امن + Undo
- Export
- Backup معتبر + Restore امن
- `reminderAt` اختیاری روی schema v2 با read سازگار v1
- Reminder فارسی
- Android local notifications
- startup/Restore reconciliation
- Fast CI
- Android Debug artifact
- Android Release Candidate artifact + reproducibility evidence

هیچ Timeline model/repository/storage/AppShell/Reminder DB موازی وجود ندارد.

## Foundationهای تکمیل‌شده و غیرقابل تکرار
- PR #81 / Issue #80 — Release Candidate artifact gate
- PR #78 / Issue #77 — Reminder UI/Notification
- PR #76 / Issue #75 — Reminder schema contract
- Restore #73/#70
- Backup #68/#67
- Export #65/#64
- Undo #63/#59
- Delete #61/#57
- edit Type #56/#55
- edit occurredAt #54/#53
- Timeline date context #52/#51
- Quick Capture occurredAt #49/#48
- Date Range #47/#46
- crash-recoverable persistence #42/#41
- CI dedupe #45
- typography #44

## Release فعال — Issue #82 / PR #83
Wave 7:
`E2E + build + artifact + smoke + recovery`

Issue #82 / PR #83:
`release: prove Android emulator smoke and storage recovery`

Branch:
`release/android-emulator-smoke-recovery`

Current exact head:
`1ffe17bd45b7dbaae5e75ab730fe21579b3267f7`

Current runs:
- YadNegar CI `33067893613`
- YadNegar Android Build `33067893659`

در لحظه این Handoff، هر دو Run فعال‌اند. تا Fresh-read موفقیت نهایی، Green گزارش نشوند.

Smoke/Recovery فعلی:
- همان Android workflow موجود reuse می‌شود
- Debug APK همان Run دانلود و روی Emulator نصب می‌شود
- storage واقعی app با schema v2 seed می‌شود
- App launch واقعی Verify می‌شود
- App force-stop می‌شود
- `timeline.json` به `.bak` منتقل و primary حذف‌شده شبیه‌سازی می‌شود
- Relaunch باید Recovery واقعی repository را فعال کند
- Marker داده باید حفظ شود
- `.bak` و `.tmp` باید پاک شوند
- Crash buffer بررسی می‌شود
- evidence شامل logcat/activity/storage/screenshot آپلود می‌شود

برای جلوگیری از برگشت مشکل PR #45، `release/**` به Android `push` trigger اضافه نشده و PR از مسیر `pull_request` Validate می‌شود.

## Automation
Issue #19 باز است.

Ruleset فعال `main-protection` هنوز required status checks را در سطح Platform اجباری نکرده است. ابزار متصل فعلی Ruleset read دارد ولی write ندارد.

تا آن زمان قانون Merge:
`exact current head + exact-head quality + exact-head android-build + relevant release/smoke gate + live mergeability + expected_head_sha + post-main proof`

Green تاریخی برای Head جدید معتبر نیست.

## اصل سرعت
Release / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی، Evidence و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. PR #83 و Runهای `33067893613` و `33067893659` Fresh-read شوند.
2. quality + android-build + android-smoke-recovery باید روی همین Head Green باشند.
3. Failure فقط با Evidence همان Run اصلاح شود؛ workaround یا Workflow موازی ساخته نشود.
4. Green کامل → Fresh mergeability → Merge با `expected_head_sha` دقیق.
5. post-main checks و smoke/recovery proof دوباره Verify شود.
6. Issue #82 بسته و Docs نهایی Refresh شوند.
7. Issue #19 باز بماند تا enforcement واقعاً writable/verified شود.
8. Production signing فقط در Slice امنیتی جدا بعد از Audit تازه.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
