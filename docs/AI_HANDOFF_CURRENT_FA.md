# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `99f672d53045782d18847380fc335fe1da25c0c6`

## وضعیت محصول
Flow اصلی روی main:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo`

قابلیت‌های اصلی موجود:
- پنج نوع TimelineItem
- فارسی و RTL
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن
- Undo با no-overwrite conflict protection
- Fast CI + Android APK Build/Verify/Upload

PR #50 مستندات نهایی موج Delete/Undo را روی main ادغام کرده است.

## Product فعال — PR #65 / Issue #64
`feat(export): copy visible Timeline items to clipboard`

Current head: `114fca4cdfd2269d5d4ff906ce96afe0590a7162`
Base: `main` at `99f672d...`
Status: Draft while exact-head gates run.

Scope واقعی:
- formatter خالص `ExportTimelineText`
- کپی همان آیتم‌هایی که کاربر اکنون در Timeline می‌بیند
- Search / Type / Date بدون query دوم در Export حفظ می‌شوند
- Clipboard فقط در Presentation
- success / empty / error feedback فارسی
- unit + widget tests
- فقط 4 فایل Export-related در diff

ممنوع/انجام‌نشده:
- dependency جدید
- Repository contract جدید
- schema/storage change
- Backup/Reminder foundation
- duplicate Search/Filter path

## Validation فعال
- YadNegar CI `33026398124`: in progress
- YadNegar Android Build `33026398078`: in progress
- PR live mergeable=true
- `mergeable_state=unstable` تا زمان settle شدن checks

Merge فقط بعد از Green شدن هر دو run، Fresh head/mergeability و `expected_head_sha` lock.

## Automation
Issue #62 recovered/closed است. PR #65 هر دو Workflow استاندارد را روی Head دقیق بدون carrier یا duplicate workflow دریافت کرده است.

Issue #19 باز است: Ruleset فعلی PR را الزام می‌کند، اما required status check Platform-level هنوز از Connector قابل‌نوشتن نیست.

## Docs موازی
Branch: `docs/current-state-wave6-export`
این Lane فقط وضعیت زنده Wave 6 را ثبت می‌کند و تا Merge Product از فایل‌های Product مستقل است. بعد از Merge #65 باید روی main جدید Final Sync شود و exact-head CI بگیرد.

## اصل سرعت
Laneهای Product / Automation / Documentation هم‌زمان جلو می‌روند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. CI + Android exact-head PR #65 را بخوان.
2. اگر Green شدند، PR را Ready و با expected-head lock Merge کن.
3. main جدید را دوباره Verify کن.
4. Docs lane را Final Sync و Merge کن.
5. سپس Wave 6 را Fresh Audit کن و فقط Gap بعدی واقعی را شروع کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
