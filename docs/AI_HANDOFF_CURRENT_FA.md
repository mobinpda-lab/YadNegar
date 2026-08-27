# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `8656564b57271947f6b45f0dbb206dbc4d3a3a38`

## Release Wave 7 + Manifest — تکمیل‌شده
Wave 7 شامل Build، Release Candidate، Artifact evidence، Android Emulator Smoke و Recovery واقعی storage است. PR #85 / Issue #84 نیز `RELEASE_MANIFEST.txt` deterministic را اضافه کرد و post-main آن کاملاً Green شد.

## Candidate Readiness — تکمیل و Merge شده
PR #88 / Issue #87:
`release: aggregate candidate readiness evidence`

Final exact head:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

قبل از Merge:
- CI `33073336472`: success
- Android `33073336417`: success
- android-build: success
- android-smoke-recovery: success
- release-readiness: success

Merge با `expected_head_sha` انجام شد و main به:
`8656564b57271947f6b45f0dbb206dbc4d3a3a38`
رسید.

Post-main:
- Fast CI `33074363600`: success
- Android `33074363581`: هنگام این revision هنوز در حال اجراست؛ نتیجه نهایی Android/Readiness فقط بعد از Fresh-read گزارش شود.

Issue #87 بسته و Completed است.

## وضعیت واقعی محصول و Release
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

روی main:
- Timeline foundation واحد
- فارسی/RTL
- persistence واقعی و crash-recoverable
- Search/Filter/Edit/Delete/Undo
- Export + Backup/Restore
- Reminder + Android notifications
- Debug APK
- Release Candidate
- SHA-256 + size evidence
- `RELEASE_MANIFEST.txt`
- Emulator startup + storage recovery
- `RELEASE_READINESS.txt`

هیچ Foundation/Workflow/Storage موازی ساخته نشده است.

## وضعیت امضای Release
Release-mode build هنوز با debug signing config امضا می‌شود.

وضعیت صحیح:
`candidate verified / production signing blocked / not Play-Store-ready`

هیچ secret یا keystore واقعی داخل Repository ثبت نشده است.

## Release Governance فعال — Issue #89 / PR #90
`release: generate deterministic version and release-notes draft`

Branch:
`release/version-notes-draft`

Head دقیق:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Scope فقط دو فایل است:
- `.github/scripts/release-draft.sh`
- `.github/workflows/android-build.yml`

هدف:
- Candidate + Readiness exact-run reuse شوند
- version/build number از Manifest خوانده شود
- Tag فقط proposal شود و هرگز ساخته نشود
- `RELEASE_VERSION.txt` تولید شود
- `RELEASE_NOTES_DRAFT.md` تولید شود
- Production signing blocker حفظ شود

Validation فعلی:
- CI `33074488110`: success
- Android `33074488158`: active؛ Build/Smoke/Readiness/Release Draft باید همگی Fresh-read Green شوند

PR #90 در آخرین Fresh-read mergeable بود، اما Merge تا Green کامل post-main #88 و Gateهای #90 ممنوع است.

## مستندسازی فعال — PR #86
Branch:
`docs/release-wave7-final`

Current State، Handoff، Operation Plan و Canonical Governance هم‌زمان با کار GitHub Sync می‌شوند.

Docs-only Merge:
`exact head + Fast CI Green + live mergeability + expected_head_sha + post-main Fast CI`

## Automation
Issue #19 باز است. PR روی main اجباری است، اما required status checks هنوز Platform-level enforce نشده‌اند و ابزار متصل Ruleset Write ارائه نمی‌کند.

قانون عملی Merge:
`exact head + exact-head CI + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## اصل سرعت
- Release / Product / Automation / Docs موازی تا حد امن
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- PR کوچک و Rollback-friendly
- مستندسازی هم‌زمان
- Evidence مصنوعی/stale ممنوع
- Workflow/Foundation تکراری ممنوع

## ادامه
1. post-main Android #88 روی main `8656564b...` Fresh-read و کامل Green شود.
2. PR #90: Fast CI + Build + Smoke/Recovery + Readiness + Release Draft همگی روی Head دقیق Green شوند.
3. #90 فقط با Fresh head/mergeability + `expected_head_sha` Merge شود.
4. post-main #90 Verify شود.
5. PR #86 یک Refresh نهایی Evidence بگیرد و docs-only امن Merge شود.
6. #19 باز بماند تا enforcement واقعاً writable شود.
7. Tag/Release/Publish واقعی و Production signing بدون تصمیم/پیکربندی امن انجام نشود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
