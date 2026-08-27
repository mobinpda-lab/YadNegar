# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current product main: `9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`

## کجا هستیم
موج Reminder تکرارشونده، نمایش وضعیت Reminder و فیلتر «همه / دارای یادآور / بدون یادآور» کامل شده‌اند. اکنون PR #106 نیز پنج نوع Timeline را با آیکن‌های متفاوت روی `main` قابل‌تشخیص کرده و post-main Fast CI/Android آن کامل سبز است.

## Reminder Foundation — Completed
Parent #93 بسته شده است.

- PR #96 / Issue #94: recurrence contract `none / daily / weekly` + schema v3 + backward-compatible v1/v2 reads
- PR #97 / Issue #95: daily/weekly device-local scheduling + Persian UX + timezone-safe reconciliation
- بدون Repository/Storage/Scheduler موازی و بدون exact-alarm permission

## Reminder Status — #99 / PR #100
محصول و مستندات نهایی ادغام و Verify شده‌اند. Issue #99 بسته است.

## Reminder Presence Filter — #102 / PR #103
Product main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Docs main after PR #105:
`4d6dc18021b5d327b3a55972288df2b2a4d1c197`

Docs post-main Fast CI `33095853727`: success. Issue #102 بسته است.

## Timeline Type Icons — #104 / PR #106
Final product head:
`042491caadb405a31473b51986c263a6f9ba5d5c`

Merged main:
`9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`

رفتار نهایی:
- یادداشت => note outline
- رویداد => event outline
- تماس => call outline
- ایده => lightbulb outline
- فعالیت => check-circle outline

نوع فارسی آیتم، زمان Timeline، وضعیت Reminder و فیلتر Reminder قبلی بدون تغییر مانده‌اند.

Scope واقعی فقط دو فایل بود:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_icon_test.dart`

Pre-merge exact-head:
- Fast CI `33095681567`: success
- Android `33095681514`: success across full chain

Post-main exact SHA:
- Fast CI `33096491732`: success
- Android `33096491859`: success
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

## مستندات فعال #104
Branch: `docs/timeline-type-icons-live`

هدف: ثبت outcome واقعی #104/#106 و post-main Green در چهار سند live/canonical.

Gate Docs:
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact expected-head merge
5. post-main Fast CI
6. سپس Close #104

## اصل Maximum Parallel
- Product / Release / Automation / Docs تا حد امن موازی
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- Stacked work فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان

## ادامه
1. Docs #104 را exact-head Verify و Merge کن.
2. post-main Fast CI مستندات را Verify کن و #104 را Completed ببند.
3. Queue واقعی را Fresh Audit کن و فقط بعد از اثبات Scope مستقل Slice بعدی را انتخاب کن.
4. #19 تا Ruleset Write واقعی باز بماند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
