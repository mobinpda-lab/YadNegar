# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current product main: `3428c1798a43fd39fadd5f47673d1bd0366583ca`

## کجا هستیم
موج Reminder تکرارشونده کامل است، وضعیت Reminder روی کارت Timeline نمایش داده می‌شود و فیلتر «همه / دارای یادآور / بدون یادآور» نیز با PR #103 روی `main` ادغام شده است.

## Reminder Recurrence — Completed
Parent #93 بسته شده است.

- PR #96 / Issue #94: recurrence contract `none / daily / weekly` + schema v3 + backward-compatible v1/v2 reads
- PR #97 / Issue #95: daily/weekly device-local scheduling + Persian UX + timezone-safe reconciliation
- بدون Repository/Storage/Scheduler موازی و بدون exact-alarm permission

## Reminder Status — #99 / PR #100
محصول روی `8de412fa8aaefa7ecb23c9f7fbbb2f423070c318` ادغام شد و Docs PR #101 روی `fb2a02624421ba135de87357817d13922fed7abf` تکمیل و Verify شد. Issue #99 بسته است.

## Reminder Presence Filter — #102 / PR #103
Final product head:
`256c2f05a5ce0d4bfaba6c9a711e7470d78f932a`

Merged main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

رفتار نهایی:
- `همه موارد`
- `دارای یادآور`
- `بدون یادآور`
- ترکیب با Search/Type/Date قبلی
- Clear موجود، فیلتر Reminder را هم Reset می‌کند
- Export فقط موارد قابل‌مشاهده فعلی را خروجی می‌دهد

Scope واقعی فقط دو فایل بود:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_filter_test.dart`

Pre-merge exact-head:
- Fast CI `33092820178`: success
- Android `33092820203`: success

Post-main exact SHA:
- Fast CI `33093725156`: success
- Android `33093725042`: success
- Build/Candidate: success
- emulator Smoke/Recovery: success
- Release Readiness: success
- Release Draft: success
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

## مستندات فعال #102
Branch: `docs/timeline-reminder-filter-live`

هدف: ثبت outcome واقعی #102/#103 و post-main Green در چهار سند live/canonical.

Gate Docs:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact expected-head merge
5. post-main Fast CI
6. سپس Close #102

## اسلایس بعدی — #104
Issue #104 برای تفکیک آیکن پنج نوع Timeline ثبت شده است.
Branch: `product/timeline-type-icons`

فقط Presentation + focused widget test مجاز است؛ بدون تغییر Schema/Storage/Scheduler/Navigation/Dependency. آماده‌سازی موازی مجاز است ولی Merge فقط بعد از تکمیل Docs #102.

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## ادامه
1. Docs #102 را کامل و exact-head Verify کن.
2. Docs را با expected-head lock ادغام و post-main Fast CI را Verify کن.
3. #102 را Completed ببند.
4. #104 را با focused tests + exact-head gates ادامه بده.
5. #19 تا Ruleset Write واقعی باز بماند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
