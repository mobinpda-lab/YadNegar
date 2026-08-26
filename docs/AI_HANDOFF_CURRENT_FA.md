# YadNegar — Live AI Handoff

## قانون اصلی
مرجع فعال عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

این فایل برای انتقال پروژه بین گفتگوهای ChatGPT است. GitHub Reality همیشه مقدم است؛ قبل از هر Write/Merge یک Audit زنده انجام بده.

## Repository
`mobinpda-lab/YadNegar`

Default branch:
`main`

آخرین main تأییدشده در این Snapshot:
`0610c401eb5a31a68552be047bc3d765696c2f33`

Current main commit:
`feat(core): define minimal Timeline Item contract`

## شروع هر Session
1. `main`، PRهای باز، Issues و Actions را زنده بررسی کن.
2. `docs/AI_CONTINUATION_STATE.md` را با GitHub تطبیق بده.
3. Workstream تکراری نساز.
4. قابلیت موجود را Reuse کن.
5. Laneهای مستقل را موازی نگه دار.
6. هیچ CI/Test/Build موفقی را بدون Evidence برای SHA دقیق گزارش نکن.
7. مستندات را همزمان با تغییر واقعی GitHub Update کن.

## چه چیزی روی main واقعاً Merge شده
### Foundation
PR #2 Merge شده؛ Issue #4 بسته است.
Flutter/Dart foundation، RTL baseline و baseline test واقعی هستند.

### CI
PR #7 Merge شده.
Merge SHA:
`9999e31f7aa2fa4717c5f027319e356ca705bebe`

Validated head:
`a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`

CI run:
`32987365151` — success

Fast Gate واقعی:
`flutter pub get → flutter analyze → flutter test`

Placeholderهای قدیمی `test.yml` و `build.yml` حذف شده‌اند.
Workflow فعلی concurrency، stale-run cancellation، Flutter cache و permissions محدود دارد.
Issue #6 فقط برای Full Build Gate آینده باز مانده است.

### Timeline Domain
PR #10 Merge شده.
Merge SHA/current main:
`0610c401eb5a31a68552be047bc3d765696c2f33`

Validated head:
`53825cc629fca1285e20c57bfdbc91369eabfb8c`

Flutter CI run:
`32987199672` — success

Contract:
- note/event/call/idea/activity
- `TimelineItem`
- `timelineAt = occurredAt ?? createdAt`

Issue #9 بسته است.

## موج موازی فعال
### Lane A — Persistence
Issue #11 → PR #12 only.

PR #12:
`feat(persistence): persist Timeline items to JSON`

Branch:
`persistence/json-timeline-repository`

Head در این Snapshot:
`0dbe99146be2b33f50ed28d3259bd0f0c5741cc4`

Implemented:
- `TimelineRepository`
- `JsonFileTimelineRepository`
- disk persistence via `dart:io`
- schema version 1
- upsert/find/listNewestFirst
- duplicate prevention by id
- Timeline ordering
- reload-from-disk tests
- unsupported-schema failure test

هیچ dependency ذخیره‌سازی خارجی اضافه نشده است.
این JSON storage، MVP قابل‌تعویض است و Database نهایی اعلام نشده است.

### Lane B — UI
Issue #5 → PR #8 only.

PR #8:
`feat(ui): establish RTL timeline shell`

Branch:
`ui/rtl-timeline-shell`

Current head:
`3b7ac04e401bfdc5b88f36eeed614c294a84e6df`

Implemented:
- TimelineScreen
- RTL shell
- empty state
- disabled Quick Capture contract تا Persistence integration
- Quick Capture accessibility tooltip
- widget tests including accessibility contract

Runهای قدیمی failure بدون runner/steps، Evidence شکست کد نیستند.
Head فعلی باید با CI واقعی سبز شود.

### Lane C — Documentation / Automation
Fast CI روی main Merge شده است.
PR #3 Documentation baseline همچنان فعال است و باید با هر Merge/Evidence جدید Sync شود.

## هدف محصولی نزدیک
Vertical Slice:
`Quick Capture → Persist → Timeline → View/Edit`

وضعیت:
- Domain: انجام شده.
- CI: انجام شده.
- UI shell: PR #8.
- Persistence واقعی: PR #12.
- قدم بعد از Merge این دو: اتصال Quick Capture به Repository و نمایش داده واقعی Timeline.

## Persistence Rule
در این مرحله مستقیم سراغ DB نرو مگر نیاز واقعی اثبات شود.
MVP JSON file انتخاب شده چون offline، dependency-free، CI-testable و قابل‌تعویض است.
DB آینده فقط بر اساس query volume، indexing، migration، recovery، performance و platform requirements انتخاب شود.

## چیزهایی که نباید ساخته شوند
- Foundation دوم
- App Shell دوم
- Timeline Model دوم
- Repository/Storage موازی برای Scope PR #12
- CI موازی
- Fake persistence که به‌عنوان Feature واقعی گزارش شود
- Build نمایشی بدون Platform build path
- Canonical docs موازی

## Validation
هر PR فقط با Evidence exact-head Merge شود.

Fast Gate:
`flutter pub get → flutter analyze → flutter test`

`flutter build` فقط بعد از Platform foundation واقعی.

## ترتیب ادامه
1. Audit زنده PR #8 و PR #12 و Actions آن‌ها.
2. هر Failure واقعی را از Step/Job تشخیص بده و همان Branch را Fix کن.
3. با Green exact-head و mergeable بودن، PRها را امن Merge کن.
4. main جدید را Verify کن.
5. PR بعدی Vertical Slice را برای اتصال Quick Capture → Repository → Timeline real data بساز.
6. PR #3 را همزمان Sync نگه دار.
7. Full Build Gate را بعداً و فقط روی Platform واقعی اجرا کن.

## اصل کار
کار موازی هماهنگ سریع.
تولید نرم‌افزار در چند ساعت به‌جای چند روز.
GitHub Automation و Documentation همزمان با Implementation.
سرعت نباید Test، Evidence، Recovery یا Safe Integration را حذف کند.

## گزارش مالک پروژه
کوتاه و غیرفنی:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Trigger
`ادامه یادنگار`

معنی:
`Audit live GitHub → reconcile docs → avoid duplicate work → parallel execute → validate exact refs → merge safe work → continue vertical slice → document → short report`

## هشدار
این فایل Snapshot است و ممکن است چند دقیقه بعد قدیمی شود. SHA یا وضعیت PR را بدون Audit زنده Current فرض نکن.
