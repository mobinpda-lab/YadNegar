# YadNegar — Live AI Handoff

## قانون اصلی
مرجع عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

GitHub Reality همیشه مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.

## Repository
`mobinpda-lab/YadNegar`
Default branch: `main`
آخرین main تأییدشده: `bb6f97672e446973df94674f6ae16a8dbfd3d930`
Commit: `ci: validate all active lanes on push`

## روی main چه چیزی واقعاً Integrated است
### Foundation — PR #2
Flutter/Dart foundation + Persian RTL baseline + baseline tests. Issue #4 بسته.

### Fast CI — PR #7
Merge SHA: `9999e31f7aa2fa4717c5f027319e356ca705bebe`
Validated head: `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`
Run `32987365151`: success.
Fast Gate: `flutter pub get → flutter analyze → flutter test`.
Placeholderهای قدیمی حذف شده‌اند.
Issue #6 فقط برای Full Build Gate واقعی آینده باز است.

### Timeline Domain — PR #10
Merge SHA: `0610c401eb5a31a68552be047bc3d765696c2f33`
Validated head: `53825cc629fca1285e20c57bfdbc91369eabfb8c`
Run `32987199672`: success.
Contract مشترک: `TimelineItem`, note/event/call/idea/activity و `timelineAt = occurredAt ?? createdAt`.
Issue #9 بسته.

### Persistence — PR #12
Merge SHA: `cc00db09863592b6b3ccb89de05aa1c428dbb5e7`
با exact-head CI موفق Merge شده است. Issue #11 تکمیل شده.

Integrated:
- `TimelineRepository`
- `JsonFileTimelineRepository`
- واقعی روی disk با `dart:io`
- schema version 1
- upsert/find/listNewestFirst
- duplicate prevention
- Timeline ordering
- reload-from-disk tests
- unsupported-schema fail-fast

JSON storage یک MVP آفلاین و قابل‌تعویض است؛ Database نهایی اعلام نشده.

### Automation — PR #14
Merge/current main: `bb6f97672e446973df94674f6ae16a8dbfd3d930`
Validated head: `669e11bbcde79bc17dbb4c53e0435eed8a5cd792`
Run `32989549391`: success با Resolve dependencies + Analyze + Test واقعی.
Issue #13 تکمیل شده.

همان CI واحد اکنون Push laneهای زیر را نیز پوشش می‌دهد:
`main`, `ci/**`, `fix/**`, `feature/**`, `ui/**`, `core/**`, `persistence/**`, `docs/**`.

## موج موازی فعال
### Lane A — Quick Capture Application
Issue #15 → PR #16 only.
PR #16: `feat(capture): add Quick Capture use case`
Branch: `feature/quick-capture-use-case`
Current base: `main`
Current head: `8e3c3d1176d89c58b4ed6483152fcebe7c86d6a2`

Implemented:
- `QuickCapture`
- injected clock/id generator
- trim input
- reject empty text/id
- reuse existing `TimelineItem`
- write only through `TimelineRepository`
- default capture type = note
- unit tests independent of UI/file system

Latest exact-head Actions lookup هنوز Run ثبت‌شده نشان نداده است. Zero Run نه success است نه failure. Merge فقط با Green exact-head.

### Lane B — UI
Issue #5 → PR #8 only.
PR #8: `feat(ui): establish RTL timeline shell`
Branch: `ui/rtl-timeline-shell`
Current head: `30c3765231e38146b8b14e03a35e05cc3b91f0c4`

Implemented:
- TimelineScreen
- Persian RTL shell
- real empty state
- disabled Quick Capture contract تا wiring
- tooltip/accessibility
- stable keys برای empty state و Quick Capture action
- widget tests

Live state در آخرین audit: mergeable. Latest exact-head Actions lookup هنوز Run ثبت‌شده نشان نداده است. Merge فقط با Green exact-head.

### Lane C — Documentation
PR #3 Documentation baseline فعال است و با هر Merge/Evidence Sync می‌شود.
Branch `docs/yadnegar-documentation-baseline` اکنون به‌دلیل PR #14 Push CI مستقیم نیز می‌گیرد.

## Vertical Slice
هدف:
`Quick Capture → Persist → Timeline → View/Edit`

وضعیت:
- Domain: Integrated
- Fast CI: Integrated
- Persistence: Integrated
- CI automation: Integrated
- UI shell: PR #8
- Quick Capture logic: PR #16

Nearest next step after #8/#16:
`UI action → QuickCapture → TimelineRepository → persisted item → Timeline reload/render`.
بعد از آن View/Edit روی همان قرارداد.

## قواعد معماری
- Reuse before rebuild
- Foundation/AppShell/Timeline Model/Repository/Storage/CI موازی نساز
- UI را مستقیم به `dart:io` وابسته نکن
- DB آینده فقط بر اساس نیاز واقعی query/index/migration/recovery/performance انتخاب شود
- Fake persistence یا Build نمایشی گزارش نشود

## Validation
`flutter pub get → flutter analyze → flutter test`
`flutter build` فقط بعد از Platform foundation واقعی.
Evidence فقط برای SHA دقیق معتبر است.

## ترتیب ادامه
1. Fresh Audit main + PR #3/#8/#16 + Issues/Actions.
2. exact-head Actions #8 و #16 را موازی بررسی کن.
3. هر Failure واقعی را از Job/Step تشخیص بده و همان Branch را Fix کن.
4. هر PR فقط با Green exact-head و mergeability امن Merge شود.
5. PR #3 را با Mergeها/Evidence Sync نگه دار و از Push CI جدید استفاده کن.
6. پس از Integration #8/#16، یک PR کوچک wiring برای `Quick Capture → Persist → real Timeline render` بساز.
7. سپس View/Edit را در همان vertical slice ادامه بده.
8. Full Build Gate را فقط بعد از Platform build foundation واقعی اضافه کن.

## Automation ادامه
یک Task ساعتی برای Audit زنده و ادامه واقعی توسعه YadNegar فعال است. هر اجرا باید GitHub را منبع حقیقت بداند، Laneها را موازی نگه دارد، Evidence دقیق بگیرد، Merge امن انجام دهد و Docs را همزمان Sync کند.

## اصل کار
کار موازی هماهنگ سریع؛ تولید نرم‌افزار در چند ساعت به‌جای چند روز؛ GitHub Automation و Documentation همزمان با Implementation؛ بدون حذف Test/Evidence/Safe Integration.

## Trigger
`ادامه یادنگار`
معنی:
`Audit live GitHub → reconcile docs → avoid duplicate work → parallel execute → validate exact refs → merge safe work → continue vertical slice → document → short report`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
کوتاه، ساده و غیرفنی.
