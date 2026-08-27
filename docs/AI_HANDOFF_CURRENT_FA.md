# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `ecd088c7d880b925cbb3240ad7ee0230a911d42e`

## محصول روی main
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export`

Export و مستندات موج قبلی کامل و post-main Verify شده‌اند.

## Product فعال — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Initial PR head: `65dd346b6203efa8a1d70a5908024c252d49dfba`
Status: Draft

طراحی فعلی:
- Snapshot از همان JSON storage موجود
- recovery/validation قبل از Snapshot
- reuse همان serializer داخلی؛ serializer/schema دوم نداریم
- Timeline خالی backup معتبر می‌دهد بدون ساخت primary user storage
- snapshot موقت دوباره با production parser Validate می‌شود
- UI فارسی Backup از طریق Presentation Scope کوچک
- TimelineHome برای این Feature تغییر نکرده
- Share فقط در composition root
- `share_plus 10.1.4` exact-pinned تا با Flutter 3.35 سازگار بماند
- Restore/Import و Reminder خارج Scope هستند

تست‌ها:
- real-file valid snapshot + primary unchanged
- recovery-before-snapshot
- valid empty snapshot
- widget success/error/absence of backup action

## Dependency Gate
Toolchain فعلی:
- Flutter 3.35.0
- AGP 8.9.1
- Gradle 8.12
- app Java source/target 11

اولین CI/Android PR #68 برای resolve/compile feedback است. Lockfile فعلی هنوز final نیست. بعد از مشخص‌شدن dependency set واقعی، `pubspec.lock` Sync می‌شود و فقط Gateهای Head جدید معتبر خواهند بود.

Initial runs:
- CI `33027569106`: active
- Android `33027569115`: active

## Docs موازی
Branch `docs/current-state-backup-active` فقط وضعیت فعال Backup را ثبت می‌کند. Product settle → structural sync → final evidence → exact-head docs CI → merge.

## Automation
Issue #19 باز است: required status check در Ruleset هنوز Platform-level قابل‌نوشتن نیست.

Merge Product فقط با:
`exact-head CI + Android + live mergeability + expected-head lock + post-main proof`

## ادامه
1. Runهای #68 را Fresh بخوان.
2. dependency resolution واقعی را به lockfile منتقل کن.
3. خطاهای واقعی Analyze/Test/Android را اصلاح کن.
4. final exact-head gates را بگیر و Safe Merge کن.
5. main را Verify کن.
6. Docs lane را Final Sync/Merge کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
