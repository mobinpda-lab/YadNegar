# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current product main: `b8bd35976fe3a51834c56799525451eec145a2fd`

## کجا هستیم
Foundation Timeline/Reminder پایدار است. موج #111 / PR #112 ادغام و post-main کامل Verify شده است: کاربر بعد از انتخاب یک نوع Timeline می‌تواند از همان Dropdown گزینه واقعی `همه انواع` را انتخاب کند و فقط محدودیت نوع را بردارد، بدون اینکه متن جستجو یا فیلترهای تاریخ/یادآور پاک شوند.

## موج‌های تکمیل‌شده
- Recurring Reminder — parent #93: تکمیل
- Reminder Status — #99 / PR #100 + docs #101: تکمیل
- Reminder Presence Filter — #102 / PR #103 + docs #105: تکمیل
- Timeline Type Card Icons — #104 / PR #106 + docs #107: تکمیل
- Shared Timeline Type Presentation — #108 / PR #109 + docs #110: تکمیل

Documented main after #108 docs PR #110:
`2c79d2e4f3d64571032560186229117df33dcafa`

## Independent Type Filter Clear — #111 / PR #112
Final product head:
`ee467aab71e682615d045acc5e363061e24a6ac5`

Merged product main:
`b8bd35976fe3a51834c56799525451eec145a2fd`

رفتار نهایی:
- Dropdown نوع اکنون `همه انواع` را به‌عنوان گزینه واقعی دارد.
- مقدار آن `null` است و همان callback nullable موجود reuse می‌شود.
- فیلتر نوع به‌تنهایی پاک می‌شود.
- query فعال حفظ می‌شود.
- date range و reminder-presence state با این عمل Reset نمی‌شوند.
- Clear All موجود همچنان همه فیلترهای مربوط را پاک می‌کند.

Scope واقعی فقط دو فایل بود:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_filter_all_option_test.dart`

Pre-merge exact-head روی `ee467aab...`:
- Fast CI `33105499667`: success
- Android `33105499651`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main روی `b8bd3597...`:
- Fast CI `33109216102`: success
- Android `33109216100`: success full chain
- Build/Candidate: success
- emulator Smoke/Recovery: success
- Release Readiness: success
- deterministic Release Draft: success
- Approval/Rollback evidence: success

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema: v3  
Compatibility: v1/v2 reads فعال است.

هیچ Timeline/Reminder DB/Repository/Storage/Scheduler موازی وجود ندارد.

## Release Safety
وضعیت انتشار:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

هیچ Tag/Release/Play Store publish واقعی یا production secret/keystore ساخته نشده است.

## Automation — Issue #19
#19 باز است. Ruleset `main-protection` فعال است؛ PR اجباری و deletion/non-fast-forward بسته است، اما required status checks هنوز Platform-level enforce نشده‌اند چون ابزار متصل Ruleset Write ندارد.

قانون عملی Merge:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## مستندات فعال #111
Branch: `docs/timeline-type-filter-all-option-live`

Branch از documented main قبلی آماده شد و در زمان Product Gate دست‌نخورده ماند. پس از Green کامل post-main محصول، بدون Force به exact main `b8bd3597...` Fast-forward شد و فقط سپس این اسناد نوشته شدند.

Gate Docs:
1. Fresh compare = فقط چهار سند canonical
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact expected-head merge
6. post-main Fast CI
7. سپس Close #111

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## Discovery بعدی
یک Candidate واقعی Audit شده اما هنوز Issue نیست: پاک‌کردن مستقل فیلتر تاریخ. State تاریخ در `TimelineHome` مستقل است، اما UI فعلی فقط انتخاب/تعویض بازه را ارائه می‌کند و برای حذف آن از Clear All استفاده می‌شود. بعد از بسته‌شدن #111 باید Fresh Audit نهایی شود و فقط در صورت حفظ Scope کوچک/reuse-first باز شود.

## صف فعلی
- #111: فقط Docs نهایی و proof باقی مانده است.
- #19: محدودیت Ruleset Write؛ باز می‌ماند.

## ادامه
1. Docs #111 را Fresh compare کن.
2. PR Docs را باز و exact-head Fast CI را Verify کن.
3. با mergeability زنده + expected-head ادغام کن.
4. post-main Fast CI را Verify و #111 را Completed ببند.
5. Candidate پاک‌کردن مستقل تاریخ را Fresh Audit کن و در صورت تأیید Slice بعدی قرار بده.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
