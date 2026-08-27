# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current product main: `0fbdb1c9dc3473112530843620480a3e7283e7ae`

## کجا هستیم
Foundation Timeline/Reminder پایدار است. موج #114 / PR #115 وارد `main` شده و post-main کامل Verify شده است: وقتی بازه زمانی فعال است، کاربر می‌تواند فقط همان بازه را پاک کند و متن جستجو، فیلتر نوع و فیلتر وضعیت یادآور را نگه دارد.

## موج‌های تکمیل‌شده
- Recurring Reminder — parent #93: تکمیل
- Reminder Status — #99 / PR #100 + docs #101: تکمیل
- Reminder Presence Filter — #102 / PR #103 + docs #105: تکمیل
- Timeline Type Card Icons — #104 / PR #106 + docs #107: تکمیل
- Shared Timeline Type Presentation — #108 / PR #109 + docs #110: تکمیل
- Independent Type Filter Clear — #111 / PR #112 + docs #113: تکمیل؛ documented main `654cb489...`

## Independent Date-Range Clear — #114 / PR #115
Final product head:
`6cb084ae12c9dbab1e2fcd2dc812374522f1f895`

Merged product main:
`0fbdb1c9dc3473112530843620480a3e7283e7ae`

رفتار نهایی:
- وقتی Date Range فعال است، کنترل پاک‌کردن مستقل نمایش داده می‌شود.
- همان State موجود `_dateStart/_dateEndExclusive` reuse شده است.
- پاک‌کردن تاریخ فقط Date Range را حذف و مسیر reload موجود را اجرا می‌کند.
- query فعال حفظ می‌شود.
- type filter حفظ می‌شود.
- reminder-presence filter حفظ می‌شود.
- Global Clear All بدون تغییر باقی مانده است.

Scope واقعی فقط سه فایل است:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_date_filter_clear_test.dart`

Pre-merge exact-head روی `6cb084ae...`:
- Fast CI `33114258026`: success
- Android `33114258075`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main روی `0fbdb1c9...`:
- Fast CI `33115076694`: success
- Android `33115076613`: success full chain
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

## مستندات فعال #114
Branch: `docs/timeline-date-filter-clear-live`

Branch از main مستند قبلی `654cb489...` آماده شد و تا پایان Product Gate هیچ Write نداشت. بعد از Green کامل post-main، بدون Force به exact main `0fbdb1c9...` Fast-forward شد و سپس این اسناد با Evidence واقعی نوشته شدند.

Gate Docs:
1. Fresh compare = فقط چهار سند canonical
2. exact docs head
3. Fast CI Green همان Head
4. live mergeability=true
5. exact expected-head merge
6. post-main Fast CI
7. سپس Close #114

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- Historical Green برای Head جدید معتبر نیست

## صف فعلی
- #114: فقط Docs نهایی و proof باقی مانده است.
- #19: محدودیت Ruleset Write؛ باز می‌ماند.

بعد از بسته‌شدن #114، Feature جدید فقط با Fresh Audit و اثبات نیاز واقعی کوچک و reuse-first انتخاب می‌شود؛ Backlog مصنوعی ساخته نمی‌شود.

## ادامه
1. Docs branch را مقابل `0fbdb1c9...` Fresh compare کن.
2. PR Docs را باز و exact-head Fast CI را Verify کن.
3. با mergeability زنده + expected-head ادغام کن.
4. post-main Fast CI را Verify و #114 را Completed ببند.
5. سپس Product Queue را Fresh Audit کن.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
