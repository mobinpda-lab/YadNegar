# YadNegar — Live AI Handoff

## قانون اصلی
مرجع فعال عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

این فایل Handoff فشرده است؛ GitHub Reality همیشه مقدم است.

## شروع هر Session
1. Repository، `main`، HEAD، PRهای باز، Issues و Actions را زنده بررسی کن.
2. `docs/AI_CONTINUATION_STATE.md` را با GitHub تطبیق بده.
3. قابلیت موجود را قبل از ساخت نمونه جدید Audit کن.
4. نزدیک‌ترین Gap واقعی را انتخاب کن.
5. Laneهای مستقل را موازی و بدون تداخل فایل/Contract جلو ببر.

## Snapshot جاری — 2026-08-26
Repository: `mobinpda-lab/YadNegar`  
Main SHA: `c632570a8d09fffecc3ae27e9747f417888b9c5f`

واقعیت فعلی:
- Flutter Foundation روی `main` Merge شده است.
- `pubspec.yaml`, `lib/`, `test/` وجود دارند.
- RTL shell پایه و baseline widget test وجود دارند.
- PR #2 Foundation Merge شده است.
- PR #7 برای CI consolidation فعال است.
- PR #8 برای RTL Timeline shell فعال است.
- PR #3 بسته Canonical documentation فعال است.

## موج موازی فعال
### Lane A — Core / Domain
Foundation آماده است؛ مرحله بعد Timeline Item/Core contract است.

### Lane B — UI
PR #8:
- TimelineScreen
- RTL shell
- empty state
- Quick Capture contract غیرفعال تا Persistence واقعی

### Lane C — CI / Documentation
PR #7:
- یک Fast Quality Gate واقعی
- concurrency + cancel stale runs
- pub get/analyze/test
- حذف Workflowهای Placeholder

PR #3:
- Canonical governance
- سند جامع
- برنامه عملیاتی
- Current State/Handoff

## CI Reality
روی اولین Merge Foundation، وضعیت Workflowهای سه‌گانه مبهم شد و Runهای failure/startup_failure دیده شد. این موضوع با حدس به کد نسبت داده نشود. PR #7 برای حذف همین ابهام ساخته شده است.

Evidence فقط برای Ref دقیق معتبر است.

## هدف محصولی نزدیک
اولین Vertical Slice واقعی:
`Quick Capture → Persist → Timeline → View/Edit`

قبل از Persistence:
- Shared Timeline Item contract را مشخص کن.
- Storage را از روی معیار واقعی انتخاب کن.
- Model/Repository/Storage موازی نساز.

## Validation
فعلاً:
`flutter pub get → flutter analyze → flutter test`

`flutter build` فقط وقتی platform project/build path واقعی وجود داشته باشد.

## ادامه
Trigger:
`ادامه یادنگار`

معنی:
`Audit live GitHub → reconcile docs → continue nearest real gaps → parallel execute → validate exact refs → document → report`
