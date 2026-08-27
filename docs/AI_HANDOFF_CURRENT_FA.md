# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current main: `4b792ba53a33e6153db35014ccdf3a15968a5383`

## کجا هستیم
Release Governance غیرمخرب تا انتها روی همان Workflow موجود پیاده و Verify شده است؛ هیچ Workflow/Foundation موازی ساخته نشده است.

زنجیره فعلی:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

## PR #90 — Version + Release Notes Draft
Final head:
`f3aab864469135a4f1a038d00305630b36a2e9cc`

Pre-merge:
- CI `33074488110`: success
- Android `33074488158`: success
- Build / Smoke-Recovery / Readiness / Draft: success

Post-main روی `6f3b1de0777263201a55faac9d1af1007d4d2e25`:
- CI `33075537776`: success
- Android `33075537814`: success
- Build / Smoke-Recovery / Readiness / Draft: success

## PR #92 / Issue #91 — Tag Availability + Approval/Rollback
Final head:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Pre-merge:
- CI `33075612499`: success
- Android `33075612644`: success
- Build: success
- Smoke/Recovery: success
- Readiness: success
- Release Draft: success
- Release Approval: success

Fresh compare قبل از Merge ثابت کرد Scope فقط دو فایل است:
- `.github/scripts/release-approval.sh`
- `.github/workflows/android-build.yml`

با `expected_head_sha` Merge شد و main به:
`4b792ba53a33e6153db35014ccdf3a15968a5383`
رسید.

Post-main #92:
- CI `33076475799`: success
- Android `33076475804`: success
- Build: success
- Smoke/Recovery: success
- Readiness: success
- Draft: success
- Approval: success

Issue #91 بسته و Completed است.

## معنی Release Approval فعلی
این Approval به معنی اجازه انتشار Production نیست.

Release-mode هنوز debug-signed است؛ بنابراین وضعیت صحیح:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

Tag فقط از نظر availability بررسی می‌شود؛ هیچ Tag/Ref ساخته یا جابه‌جا نشده است. هیچ GitHub Release، Play Store publish، production keystore یا signing secret ایجاد/Commit نشده است.

## وضعیت محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Foundation فعلی:
- یک TimelineItem
- فارسی/RTL
- JSON persistence واقعی و crash-recoverable
- Search/Filter/Edit/Delete/Undo
- Export + Backup/Restore
- schema-v2 با `reminderAt` و خواندن backward-compatible v1
- Android local notifications
- startup/Restore reminder reconciliation

هیچ Reminder DB یا storage موازی وجود ندارد.

## Slice بعدی محصول — Issue #93
`product: add safe recurring reminders on the existing Timeline`

Scope طراحی‌شده:
- فقط `none / daily / weekly`
- schema v3 با خواندن v1/v2
- استفاده از همان TimelineItem، JSON repository، scheduler و Persian UX
- بدون DB/Repository جدید
- migration و recovery واقعی

Implementation بعد از Merge امن docs baseline شروع می‌شود.

## مستندسازی فعال — PR #86
Branch:
`docs/release-wave7-final`

چهار سند Current State / Handoff / Operation Plan / Canonical Governance با نتیجه واقعی #92 و post-main آن Sync شده‌اند.

Docs-only Merge:
`exact head + Fast CI Green + live mergeability + expected_head_sha + post-main Fast CI`

## Automation — Issue #19
Issue #19 باز است. Ruleset PR را اجباری می‌کند و delete/non-fast-forward را می‌بندد، ولی required status checks هنوز Platform-level enforce نشده‌اند.

Tooling فعلی فقط Ruleset Read دارد؛ Write واقعی ندارد.

قانون عملی تا زمان enforcement واقعی:
`exact head + exact-head relevant gates + live mergeability + expected_head_sha + post-main proof`

## اصل سرعت
- Laneهای مستقل موازی
- Reuse قبل از Rebuild
- Stacked preparation فقط با Fresh compare
- PR کوچک و rollback-friendly
- Evidence stale/fake ممنوع
- مستندسازی هم‌زمان
- Runner blocked، Lane مستقل را متوقف نمی‌کند

## ادامه
1. CI Head جدید PR #86 سبز شود.
2. #86 با Fresh head/mergeability و `expected_head_sha` Merge شود.
3. post-main docs CI Verify شود.
4. #93 از main تازه Branch شود و recurring reminder به‌صورت schema-v3 امن پیاده شود.
5. #19 باز بماند تا Ruleset write واقعی فراهم شود.
6. Production signing و Tag/Release/Publish واقعی فقط در Slice امنیتی/مالکیتی جدا انجام شوند.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
