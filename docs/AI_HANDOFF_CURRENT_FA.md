# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `6f3b1de0777263201a55faac9d1af1007d4d2e25`

## وضعیت Release تا اینجا
Wave 7، Release Manifest، Candidate Readiness و Version/Release Notes Draft به‌ترتیب روی همان Android workflow موجود ساخته و Verify شده‌اند؛ Workflow موازی جدیدی ایجاد نشده است.

### PR #88 / Issue #87 — Candidate Readiness
Final head:
`32d2b6de7649377642fa5fdaac42b0c5ee0cf239`

Pre-merge:
- CI `33073336472`: success
- Android `33073336417`: success
- Build: success
- Smoke/Recovery: success
- Release Readiness: success

Post-main روی `8656564b...`:
- CI `33074363600`: success
- Android `33074363581`: success
- Build: success
- Smoke/Recovery: success
- Release Readiness: success

### PR #90 / Issue #89 — Version + Release Notes Draft
Final head:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Pre-merge:
- CI `33074488110`: success
- Android `33074488158`: success
- Build: success
- Smoke/Recovery: success
- Release Readiness: success
- Release Draft: success

با `expected_head_sha` Merge شد و main به:
`6f3b1de0777263201a55faac9d1af1007d4d2e25`
رسید.

Post-main #90:
- CI `33075537776`: هنگام این revision فعال
- Android `33075537814`: هنگام این revision فعال

تا Fresh-read پایان این دو Run، Green نهایی post-main گزارش نشود.

## وضعیت واقعی محصول
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
- `RELEASE_VERSION.txt`
- `RELEASE_NOTES_DRAFT.md`

هیچ Foundation/Workflow/Storage موازی ساخته نشده است.

## وضعیت امضای Release
Release-mode build هنوز با debug signing config امضا می‌شود.

وضعیت صحیح:
`candidate verified / production signing blocked / not Play-Store-ready`

هیچ secret یا keystore واقعی داخل Repository ثبت نشده است.

## Release Governance فعال — Issue #91 / PR #92
`release: prove tag availability and emit approval rollback package`

Branch:
`release/approval-rollback-package`

Head دقیق:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Fresh compare بعد از Merge #90 نشان داد Scope فقط دو فایل است:
- `.github/scripts/release-approval.sh`
- `.github/workflows/android-build.yml`

هدف:
- Release Version + Readiness همان Run reuse شوند
- source SHA تطبیق داده شود
- Tag پیشنهادی فقط از نظر وجود قبلی روی remote بررسی شود
- هیچ Tag/Ref ساخته یا جابه‌جا نشود
- `RELEASE_APPROVAL.txt` تولید شود
- `ROLLBACK_PLAN.md` تولید شود
- اگر Tag موجود بود یا lookup قابل Verify نبود، Gate fail-closed شود
- Approval تا وقتی Production signing blocked است، صریحاً blocked بماند

Validation شروع‌شده:
- CI `33075612499`
- Android `33075612644`

نتیجه این Runها در این revision هنوز نهایی نیست.

## مستندسازی فعال — PR #86
Branch:
`docs/release-wave7-final`

Current State، Handoff، Operation Plan و Canonical Governance هم‌زمان با کار GitHub Sync می‌شوند.

Docs-only Merge:
`exact head + Fast CI Green + live mergeability + expected_head_sha + post-main Fast CI`

## Automation
Issue #19 باز است. PR روی main اجباری است، اما required status checks هنوز Platform-level enforce نشده‌اند و Fresh tool discovery فقط Ruleset Read ارائه می‌کند.

قانون عملی Merge:
`exact head + exact-head CI + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## اصل سرعت
- Release / Product / Automation / Docs موازی تا حد امن
- stacked preparation فقط با Fresh compare و Scope تمیز
- Runner blocked، Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- PR کوچک و Rollback-friendly
- مستندسازی هم‌زمان
- Evidence مصنوعی/stale ممنوع
- Workflow/Foundation تکراری ممنوع

## ادامه
1. post-main #90 روی main `6f3b1de...` کامل Green شود.
2. PR #92: Fast CI + Build + Smoke/Recovery + Readiness + Release Draft + Release Approval همگی روی Head دقیق Green شوند.
3. #92 فقط با Fresh head/mergeability + `expected_head_sha` Merge شود.
4. post-main #92 Verify شود.
5. PR #86 با نتیجه واقعی #92 نهایی و docs-only امن Merge شود.
6. #19 باز بماند تا enforcement واقعاً writable شود.
7. Production signing و Tag/Release/Publish واقعی بدون تصمیم و پیکربندی امن انجام نشوند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
