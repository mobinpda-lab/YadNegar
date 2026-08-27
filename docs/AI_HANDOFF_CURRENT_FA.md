# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `f85d804a84a4033c94e2dc843a6aa87f2d848991`

Post-main روی همین SHA:
- CI `33051308713`: success
- Android `33051308694`: success
- APK build/verify/upload: success

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore → Reminder`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem مشترک
- فارسی و RTL
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type، حذف امن و Undo بدون overwrite
- Export خوانای Timeline فعلی
- Backup معتبر و Restore امن
- `reminderAt` اختیاری روی schema v2 با سازگاری خواندن v1
- انتخاب/پاک‌کردن یادآور در Quick Capture/Edit
- اعلان محلی واقعی Android
- schedule/cancel فقط بعد از Persist موفق
- حذف Reminder را cancel می‌کند و Undo دوباره schedule می‌کند
- Edit متن، اعلان pending را با متن جدید refresh می‌کند
- startup و Restore، Reminderهای ذخیره‌شده را از همان TimelineRepository reconcile می‌کنند
- هیچ Reminder database/repository موازی وجود ندارد
- Fast CI + Android APK Build/Verify/Upload واقعی

## Reminder Data Contract — PR #76 / Issue #75
Final head: `6ab46b5029b3070e43e1524431b821a766326eb2`
- CI `33046525150`: success
- Android `33046525158`: success
- merged main: `fceb383aad507eed354d4b044e3939aacf5328d0`
- post-main CI `33046893279`: success
- post-main Android `33046893295`: success

نتیجه:
- `reminderAt` روی همان TimelineItem
- write schema v2 و read سازگار v1
- upgrade فقط روی اولین write امن
- حفظ reminderAt در Edit/Backup/Restore
- ترتیب Timeline بدون تغییر

## Reminder UI/Notification — PR #78 / Issue #77
Final head: `22bc0d1d855c98521dc554a770ff41e8475f532b`
- CI `33050851398`: success
- Android `33050851419`: success
- 106 تست پاس شد
- lockfile دقیق توسط GitHub Actions با Flutter 3.35 تولید و commit شد
- mergeability=true
- merge با expected-head lock

Merged main:
`f85d804a84a4033c94e2dc843a6aa87f2d848991`

Post-main:
- CI `33051308713`: success
- Android `33051308694`: success

Reminder design:
- `flutter_local_notifications 19.5.0`
- `timezone 0.10.1`
- Plugin بیرون Domain و در platform/data edge
- inexact scheduling؛ exact-alarm permission در MVP لازم نیست
- permission اعلان فقط در مسیر مرتبط درخواست می‌شود
- notification id collision-aware بدون sidecar DB
- recurring reminder خارج Scope است

Issue #77 closed/completed است.

## Foundationهای تکمیل‌شده و غیرقابل تکرار
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

## Docs فعال — PR #79
Branch: `docs/current-state-reminder-contract-final`

Branch structurally روی main Reminder `f85d804...` sync شده است. Final diff باید فقط Docs باشد. فایل موقت Reminder باید حذف شود و چهار سند Canonical با وضعیت نهایی Refresh شوند. سپس exact-head Fast CI، Fresh mergeability و expected-head merge lock.

## Release فعال — Issue #80 / PR #81
Roadmap واقعی بعد از Wave 6، **Wave 7 Release** است.

Branch: `release/android-release-candidate-gate`  
PR #81 initial head: `b0e3bf3e2846eb22ed8ae71d7676a2ae8fb9d024`

Slice فعلی:
- همان Android workflow موجود reuse می‌شود
- Debug APK حفظ می‌شود
- Release-mode candidate APK ساخته می‌شود
- artifact باید non-empty باشد
- SHA-256 و byte size ثبت می‌شود
- candidate + evidence آپلود می‌شوند

Fresh signing audit:
`android/app/build.gradle.kts` هنوز release را با debug signing config امضا می‌کند. بنابراین Candidate فعلی **Production-signed نیست** و نباید Play-Store-ready گزارش شود.

بعد از پایداری این Gate، Emulator smoke/recovery یک Slice کوچک جدا خواهد بود.

## Automation
Issue #19 باز است. required status check در Ruleset هنوز واقعاً writable/verified نیست.

قانون Merge:
`exact current head + exact-head CI + exact-head Android برای Product/Release + live mergeability + expected_head_sha + post-main proof`

Green تاریخی برای Head جدید معتبر نیست.

## اصل سرعت
Product / Release / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی، cancel stale runs و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. PR #79 را docs-only نهایی و merge کن.
2. PR #81 را روی Head دقیق با CI و Android validate کن؛ هر دو Debug و Release Candidate باید ساخته/Verify/Upload شوند.
3. Green → Fresh mergeability → expected-head Merge → post-main proof.
4. سپس Android emulator smoke/recovery را به‌عنوان Slice بعدی Wave 7 شروع کن.
5. #19 باز بماند تا enforcement واقعاً قابل‌نوشتن و Verify شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
