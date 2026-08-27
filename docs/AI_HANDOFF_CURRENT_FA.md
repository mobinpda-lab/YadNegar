# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `14bfd37a7304841db74133f5fd6524535350e49a`

## محصول روی main
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export`

همچنین PR #69 عبارت `بسم الله الرحمن الرحیم` را به‌صورت ظریف و وسط، بالای عنوان «یادنگار» در صفحه اصلی اضافه کرده و post-main Fast CI + Android هر دو Green هستند.

## Product فعال — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Current final-validation head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
Status: final exact-head CI و Android هر دو Green؛ مرحله بعد Ready + Fresh mergeability + expected-head merge.

طراحی نهایی:
- Snapshot از همان JSON storage موجود
- recovery/validation قبل از Snapshot
- reuse همان serializer داخلی؛ serializer/schema دوم نداریم
- Timeline خالی backup معتبر می‌دهد بدون ساخت primary user storage
- snapshot موقت دوباره با production parser Validate می‌شود
- UI فارسی Backup از طریق Presentation Scope کوچک
- TimelineHome برای این Feature تغییر نکرده
- Share فقط در composition root
- `share_plus 10.1.4` exact-pinned و با Flutter 3.35 Resolve شده
- `pubspec.lock` با package set واقعی CI نهایی شده
- Restore/Import و Reminder خارج Scope هستند

Branch بعد از Merge شدن بسم‌الله با current main به‌صورت دووالدی Sync شد:
`529df3fd6656705fab3756a878c45d8ec2ed1bbc`

در `TimelineScreen` نهایی هر دو قابلیت هم‌زمان حفظ شده‌اند:
- Bismillah header
- Backup action

تست‌ها:
- real-file valid snapshot + primary unchanged
- recovery-before-snapshot
- valid empty snapshot
- widget success/error/absence of backup action

## Dependency / Validation Gate
Toolchain فعلی:
- Flutter 3.35.0
- AGP 8.9.1
- Gradle 8.12

Dependency-resolution اولیه روی همین Toolchain موفق بود:
- Analyze بدون خطا
- 85 تست پاس

Final exact-head runs روی `8057eca7...`:
- CI `33042505480`: Green
- Android `33042505505`: Green

فقط همین Head برای Merge معتبر است.

## Docs موازی
Branch `docs/current-state-backup-active` وضعیت Backup و Bismillah را هم‌زمان ثبت می‌کند. Product merge → structural sync → final evidence → exact-head docs CI → merge.

## Automation
Issue #19 باز است: required status check در Ruleset هنوز Platform-level قابل‌نوشتن نیست.

Merge Product فقط با:
`exact-head CI + Android + live mergeability + expected-head lock + post-main proof`

## Next audited slice
Issue #70 برای Restore/Import امن ثبت شده است؛ validation + rollback و reuse parser production. Branch فقط بعد از Merge و post-main proof #68 شروع شود.

## ادامه
1. PR #68 را Ready کن.
2. Head و mergeability را Fresh بخوان.
3. فقط با expected-head lock همان SHA Merge کن.
4. main جدید را با CI + Android Verify کن.
5. Docs lane را روی main نهایی Structurally Sync و Merge کن.
6. سپس Issue #70 را به‌عنوان Slice مستقل شروع کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
