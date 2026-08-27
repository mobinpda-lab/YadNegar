# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current verified main: `9e31b6e4db22ca5d9a34231eb4205f01027d0655`

## محصول روی main
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem
- فارسی و RTL
- `بسم الله الرحمن الرحیم` در هدر
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن + Undo conflict-safe
- Export visible Timeline
- Backup معتبر و قابل‌حمل
- Fast CI + Android Build/Verify/Upload واقعی

Foundation موازی Model/Repository/Storage/AppShell وجود ندارد.

## موج‌های Verify‌شده اخیر
### PR #69 — Bismillah
- pre-merge CI `33041625126`: success
- Android `33041625147`: success
- merged main `14bfd37a...`
- post-main CI/Android هر دو success

### PR #68 / Issue #67 — Backup
- final head `8057eca7...`
- CI `33042505480`: success
- Android `33042505505`: success
- final lockfile همان Head
- expected-head merge
- merged main `edf0c72b...`
- post-main CI `33042973852`: success
- Android `33042973848`: success با build/verify/upload
- Issue #67 closed completed

### PR #72 — Canonical Docs
- exact head `9689dd3f...`
- docs-only diff
- CI `33043437075`: success
- expected-head merge
- current main `9e31b6e4...`
- post-main CI `33044169143`: success

## Product فعال — PR #73 / Issue #70
`feat(restore): validate and restore Timeline snapshots safely`

Branch: `feature/timeline-restore-import`  
Current exact head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`  
Status: Draft؛ Merge فقط بعد از Gateهای final Head.

پیاده‌سازی فعلی:
- candidate قبل از هر write با production JSON parser/schema Validate می‌شود
- UTF-8 خراب، JSON خراب، schema ناسازگار و duplicate ID رد می‌شوند
- primary data در rejection تغییر نمی‌کند
- همان `_writeAll` موجود برای `.tmp` / `.bak` / rollback استفاده می‌شود
- Repository contract دامنه تغییر نکرده
- parser/serializer/storage دوم نداریم
- File Picker فقط در composition/platform edge
- `file_picker 8.3.7` exact-pinned
- confirmation فارسی قبل از replacement
- feedback فارسی برای success/invalid/unsupported/duplicate/failure
- Restore موفق همان `_reload()` موجود را اجرا می‌کند؛ Search/Type/Date حفظ می‌شوند
- Bismillah + Backup + Export حفظ شده‌اند

تست‌ها:
- valid real-file restore
- malformed/unsupported/duplicate/blank/invalid UTF-8 without data loss
- confirmation cancel
- successful reload while active search remains applied
- unsupported-version feedback

Dependency/CI evidence:
- pre-lock head `f04419ee...`: CI `33044782989` success، Analyze clean، 93 tests passed
- resolution واقعی Flutter 3.35: `file_picker 8.3.7` + `flutter_plugin_android_lifecycle 2.0.34`
- final lockfile روی `fa8cfb284...` Commit شده
- final CI `33045126480`: active at last refresh
- final Android `33045126515`: active at last refresh

Green قبلی برای Merge Head نهایی reuse نشود.

## Docs موازی
Branch: `docs/current-state-restore-active`

در حین Product فقط وضعیت واقعی Restore را ثبت می‌کند. بعد از Product merge باید روی main نهایی Structural Sync، final evidence، docs-only diff و exact-head Fast CI بگیرد.

## Automation
Issue #19 باز است: required status checks در سطح Platform هنوز writable/proven نیست.

قرارداد Merge:
`exact current head + exact-head CI + exact-head Android برای Product + live mergeability + expected_head_sha + post-main proof`

## ادامه
1. final CI/Android PR #73 را Fresh Verify کن.
2. failure فقط بر اساس evidence اصلاح شود.
3. Green → Ready → Fresh head/mergeability → expected-head Merge.
4. main جدید با CI+Android Verify و بسته‌شدن Issue #70 کنترل شود.
5. Docs lane final-sync و safe merge شود.
6. بعد Fresh Audit برای Slice واقعی بعدی.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
