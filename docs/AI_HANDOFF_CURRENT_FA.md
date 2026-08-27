# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `a29fe46ba9c9c50be107e36b6c618ddc1a0c6e95`

## Release Wave 7 — تکمیل‌شده
Wave 7 شامل Build، Release Candidate، Artifact evidence، Android Emulator Smoke و Recovery واقعی storage است و روی main اثبات شده است.

## Release Manifest — تکمیل‌شده
PR #85 / Issue #84:
`release: add deterministic release manifest evidence`

Final exact head:
`2a456003899ec24ab310a86f5f521c68a97fb483`

قبل از Merge:
- CI `33070804473`: success
- Android `33070804465`: success
- Build: success
- Release Candidate + Manifest: success
- Smoke/Recovery: success

Merge با `expected_head_sha` انجام شد.

Post-main روی `a29fe46...`:
- Fast CI `33071541211`: success
- Android `33071541182`: success
- android-build: success
- android-smoke-recovery: success

Issue #84 بسته و تکمیل شده است.

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem مشترک
- فارسی و RTL
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- Delete امن + Undo
- Export
- Backup معتبر + Restore امن
- reminderAt اختیاری روی schema v2 با read سازگار v1
- Reminder فارسی + Android local notifications
- startup/Restore reconciliation
- Fast CI
- Debug APK artifact
- Release Candidate artifact
- SHA-256 + size evidence
- `RELEASE_MANIFEST.txt`
- source SHA واقعی جدا از validation SHA
- Android Emulator startup proof
- Recovery واقعی primary از `.bak`

هیچ Timeline model/repository/storage/AppShell/Reminder DB موازی وجود ندارد.

## وضعیت امضای Release
Release-mode build هنوز با debug signing config امضا می‌شود.

وضعیت صحیح:
`candidate verified / not production-signed / not Play-Store-ready`

هیچ secret یا keystore واقعی داخل Repository ثبت نشده و نباید ثبت شود.

## Release Governance فعال — Issue #87 / PR #88
`release: aggregate candidate readiness evidence`

Branch:
`release/candidate-readiness-evidence`

Head دقیق هنگام این بروزرسانی:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

هدف:
- همان Android workflow reuse شود
- Build/Manifest/Smoke/Recovery حفظ شوند
- Job جدید `release-readiness` بعد از Gateهای قبلی اجرا شود
- Candidate و Smoke evidence همان Run دانلود و بررسی شوند
- `RELEASE_READINESS.txt` ساخته و Upload شود
- تا وقتی debug signing وجود دارد، Production signing صریحاً blocked گزارش شود

Runs شروع‌شده روی همین Head:
- CI `33073336472`
- Android `33073336417`

در زمان این commit هنوز نتیجه نهایی این Runها قطعی نشده بود؛ قبل از هر Merge باید Fresh-read شوند.

## مستندسازی فعال — PR #86
Branch:
`docs/release-wave7-final`

Current State، Handoff، Operation Plan و Canonical Governance هم‌زمان با کار عملی GitHub Sync می‌شوند.

Docs-only Merge فقط با:
`exact head + Fast CI Green + live mergeability + expected_head_sha + post-main Fast CI`

## Automation
Issue #19 باز است.

Ruleset فعلی PR را اجباری می‌کند، اما required status checks هنوز Platform-level enforce نشده‌اند و ابزار متصل Ruleset Write ارائه نمی‌کند.

قانون عملی Merge:
`exact head + exact-head CI + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## اصل سرعت
- Release / Product / Automation / Docs تا حد امن موازی
- Block شدن Runner، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- PR کوچک و قابل Rollback
- مستندسازی هم‌زمان با Implementation
- هیچ Evidence مصنوعی یا stale
- Workflow و Foundation تکراری ممنوع

## ادامه
1. PR #88 روی Head دقیق Validate شود.
2. Fast CI + Build + Smoke/Recovery + Release Readiness باید Green باشند.
3. Merge فقط بعد از Fresh head/mergeability و با `expected_head_sha`.
4. بعد از Merge، main دوباره Verify شود.
5. PR #86 با نتیجه واقعی #88 یک بار نهایی و سپس docs-only Merge شود.
6. #19 باز بماند تا enforcement واقعاً writable شود.
7. Production signing فقط در Slice امنیتی جدا بعد از تعیین مالکیت امن keystore/credentials.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
