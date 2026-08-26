# YadNegar — Live AI Handoff

## قانون اصلی
مرجع عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

GitHub Reality همیشه مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.

## Repository
`mobinpda-lab/YadNegar`
Default branch: `main`
آخرین main تأییدشده: `0610c401eb5a31a68552be047bc3d765696c2f33`
Commit: `feat(core): define minimal Timeline Item contract`

## Integrated روی main
### Foundation — PR #2
Merge شده؛ Issue #4 بسته.
Flutter/Dart foundation + Persian RTL baseline + baseline test.
Validated head `e614343a80f9c30e7a171ef7aeb1eaebc852a8be` با pub get/analyze/test سبز.

### Fast CI — PR #7
Merge SHA: `9999e31f7aa2fa4717c5f027319e356ca705bebe`
Validated head: `a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`
Run `32987365151`: success.
Fast Gate: `flutter pub get → flutter analyze → flutter test`
Placeholderهای `test.yml` و `build.yml` حذف شدند.
Issue #6 فقط برای Full Build Gate واقعی آینده باز است.

### Timeline Domain — PR #10
Merge/current main: `0610c401eb5a31a68552be047bc3d765696c2f33`
Validated head: `53825cc629fca1285e20c57bfdbc91369eabfb8c`
Run `32987199672`: pub get/analyze/test success.
Contract: note/event/call/idea/activity + `TimelineItem` + `timelineAt = occurredAt ?? createdAt`.
Issue #9 بسته.

## موج موازی فعال
### Lane A1 — Persistence
Issue #11 → PR #12 only.
PR #12: `feat(persistence): persist Timeline items to JSON`
Branch: `persistence/json-timeline-repository`
Head: `0dbe99146be2b33f50ed28d3259bd0f0c5741cc4`

Implemented:
- `TimelineRepository`
- `JsonFileTimelineRepository`
- real disk persistence via `dart:io`
- schema version 1
- upsert/find/listNewestFirst
- duplicate prevention
- Timeline ordering
- reload-from-disk tests
- unsupported-schema test

JSON storage یک MVP dependency-free و قابل‌تعویض است؛ Database نهایی اعلام نشده.

### Lane A2 — Quick Capture Application (stacked)
Issue #15 → PR #16 only.
PR #16: `feat(capture): add Quick Capture use case`
Branch: `feature/quick-capture-use-case`
Head: `2c2f9f433e92ae3c3d275371c8ad5d0264e2fd0d`
Base فعلی: `persistence/json-timeline-repository`

این PR عمداً روی PR #12 stacked است و پس از Merge #12 باید به `main` retarget شود.
Implemented:
- `QuickCapture`
- injected clock/id generator
- trim text
- reject empty text/id
- reuse `TimelineItem`
- persistence فقط از طریق `TimelineRepository`
- unit tests مستقل از UI/file system

### Lane B — UI
Issue #5 → PR #8 only.
PR #8: `feat(ui): establish RTL timeline shell`
Branch: `ui/rtl-timeline-shell`
Head: `3b7ac04e401bfdc5b88f36eeed614c294a84e6df`

Implemented:
- TimelineScreen
- RTL shell
- empty state
- disabled Quick Capture contract تا Integration
- Quick Capture accessibility tooltip
- widget tests

Runهای قدیمی بدون runner/steps Evidence شکست کد نیستند. Current head باید Green شود.

### Lane C1 — Automation
Issue #13 → PR #14 only.
PR #14: `ci: validate all active lanes on push`
Branch: `ci/expand-active-branch-gates`
Head: `669e11bbcde79bc17dbb4c53e0435eed8a5cd792`

هدف: همان CI واحد روی Push شاخه‌های `core/**`, `persistence/**`, `docs/**` نیز اجرا شود؛ Workflow موازی جدید ایجاد نشده است.

### Lane C2 — Documentation
PR #3 Documentation baseline فعال است و با هر Merge/Evidence جدید Sync می‌شود.

## Actions Reality
CI برای PRهای Merge‌شده #7/#10 Evidence واقعی دارد.
در آخرین Audit، Headهای جدید #8/#12/#14/#16 هنوز Run جدید ثبت‌شده نداشتند. صفر Run نه Success است نه Failure.
وقتی Run ظاهر شد، Job/Steps را بررسی کن و فقط exact-head Green را معتبر بدان.

## Vertical Slice
هدف:
`Quick Capture → Persist → Timeline → View/Edit`

وضعیت:
- Domain: Integrated
- Fast CI: Integrated
- UI shell: PR #8
- Persistence: PR #12
- Quick Capture logic: PR #16 stacked
- قدم بعد: wire UI → QuickCapture → TimelineRepository → real Timeline data، سپس View/Edit.

## قواعد معماری
- Reuse before rebuild
- Foundation/AppShell/Timeline Model/Repository/Storage/CI موازی نساز
- UI به `dart:io` وابسته نشود
- DB آینده فقط بر اساس نیاز واقعی query/index/migration/recovery/performance انتخاب شود
- Fake persistence یا Build نمایشی گزارش نشود

## Validation
`flutter pub get → flutter analyze → flutter test`
`flutter build` فقط بعد از Platform foundation واقعی.
Evidence فقط برای SHA دقیق معتبر است.

## ترتیب ادامه
1. Audit زنده main + PR #3/#8/#12/#14/#16 + Issues/Actions.
2. Poll exact-head Actions موازی.
3. هر Failure واقعی را از Step تشخیص و همان Branch را Fix کن.
4. PR #14 را پس از Green Merge کن تا Laneهای فعال روی Push مستقیم Validate شوند.
5. PR #12 را پس از Green Merge کن؛ سپس #16 را به main retarget و Revalidate کن.
6. PR #8 فقط با Green current-head و mergeability واقعی Merge شود؛ در صورت drift همان Branch را Sync کن، PR موازی نساز.
7. پس از Integration، wiring Vertical Slice را در PR کوچک بعدی بساز.
8. PR #3 را همزمان Sync نگه دار.

## اصل کار
کار موازی هماهنگ سریع؛ تولید نرم‌افزار در چند ساعت به‌جای چند روز؛ Automation و Documentation همزمان با Implementation؛ بدون حذف Test/Evidence/Safe Integration.

## Trigger
`ادامه یادنگار`
معنی:
`Audit live GitHub → reconcile docs → avoid duplicate work → parallel execute → validate exact refs → merge safe work → continue vertical slice → document → short report`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
کوتاه، ساده و غیرفنی.
