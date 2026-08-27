# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است. Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `9ffa1041c3205a35d0aa0744236e9e4dcbb28333`

## Wave 7 — تکمیل‌شده
PR #83 با Head دقیق زیر Merge شد:
`60d1f21ce3574e3b6c04478351136acf35e9e8e7`

Exact-head قبل از Merge:
- CI `33069328808`: success
- Android `33069328907`: success
- android-build: success
- android-smoke-recovery: success
- Debug APK + Release Candidate: success
- Emulator startup + recovery واقعی storage: success

Merge با `expected_head_sha` انجام شد و Issue #82 بسته شد.

Post-main روی `9ffa1041...`:
- Fast CI `33070027775`: success
- Android `33070027900`: هنگام این commit هنوز فعال است؛ تا Fresh-read پایان Run، Green نهایی گزارش نشود.

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore → Reminder`

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
- Release Candidate artifact + hash/size evidence
- Android Emulator startup proof
- Recovery واقعی primary از `.bak`

هیچ Timeline model/repository/storage/AppShell/Reminder DB موازی وجود ندارد.

## Release Candidate
Release-mode build هنوز با debug signing config امضا می‌شود.

بنابراین وضعیت صحیح:
`release-mode candidate / not production-signed / not Play-Store-ready`

هیچ secret یا keystore واقعی نباید داخل Repository ثبت شود.

## Release Governance فعال — Issue #84 / PR #85
`release: add deterministic release manifest evidence`

Branch:
`release/deterministic-release-manifest`

Initial head:
`cb8bd2d23dfc06bdb8f8ab20869dabb8edbfd340`

هدف:
- همان Android workflow reuse شود
- Build/Artifact/Smoke/Recovery حفظ شوند
- `RELEASE_MANIFEST.txt` به artifact موجود اضافه شود
- version، application id، exact SHA، APK SHA-256، size و signing state ثبت شوند
- بدون secret، tag، publish یا ادعای Production

Runs فعال روی Head اولیه:
- CI `33070352421`
- Android `33070352464`

قبل از Merge باید Fresh-read شوند.

## Automation
Issue #19 باز است.

Ruleset `main-protection` PR را اجباری می‌کند و deletion/non-fast-forward را می‌بندد، اما required status checks هنوز Platform-level تنظیم نشده‌اند. ابزار متصل در Fresh audit تاریخ 2026-08-27 فقط Ruleset Read دارد.

قانون عملی Merge:
`exact head + exact-head CI + exact-head Android/relevant jobs + live mergeability + expected_head_sha + post-main proof`

## اصل سرعت
- Release / Product / Automation / Docs تا حد امن موازی
- Runner مسدود Lane مستقل را متوقف نمی‌کند
- Reuse قبل از Rebuild
- PR کوچک و قابل Rollback
- مستندسازی هم‌زمان با Implementation
- هیچ Evidence مصنوعی یا stale
- Workflow و Foundation تکراری ممنوع

## ادامه
1. Android post-main روی `9ffa1041...` Fresh-read شود.
2. PR #85 روی Head دقیق Validate شود.
3. مستندات نهایی با Evidence واقعی Sync و docs-only PR ساخته شود.
4. Merge فقط با expected-head lock.
5. #19 باز بماند تا enforcement واقعاً writable شود.
6. Production signing فقط در Slice امنیتی جدا بعد از تعیین مالکیت keystore/credentials.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
