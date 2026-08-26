# YadNegar — Live AI Handoff

## قانون اصلی
مرجع فعال عملیات پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

این فایل Handoff فشرده برای انتقال پروژه بین گفتگوهای ChatGPT است؛ GitHub Reality همیشه مقدم است و قبل از هر ادامه باید وضعیت زنده Repository دوباره Audit شود.

## Repository
`mobinpda-lab/YadNegar`

Default branch:
`main`

آخرین main تأییدشده در این Snapshot:
`c632570a8d09fffecc3ae27e9747f417888b9c5f`

Commit:
`feat(foundation): establish real Flutter RTL foundation`

## شروع هر Session
1. Repository، `main`، HEAD، PRهای باز، Issues و Actions را زنده بررسی کن.
2. `docs/AI_CONTINUATION_STATE.md` را با GitHub تطبیق بده.
3. قابلیت موجود را قبل از ساخت نمونه جدید Audit کن.
4. Workstream تکراری نساز.
5. نزدیک‌ترین Gap واقعی را انتخاب کن.
6. Laneهای مستقل را موازی و بدون تداخل فایل/Contract جلو ببر.
7. هیچ CI/Build/Test موفقی را بدون Evidence برای SHA دقیق گزارش نکن.
8. مستندات را همزمان با تغییر واقعی GitHub به‌روز کن.

## Snapshot جاری — 2026-08-26
واقعیت تأییدشده:
- PR #2 Foundation Merge شده است.
- Issue #4 بسته و تکمیل شده است.
- Flutter/Dart Foundation روی `main` وجود دارد.
- `pubspec.yaml`, `lib/`, `test/` و Flutter CI پایه وجود دارند.
- RTL shell پایه و baseline widget test وجود دارند.
- PR #3 مستندات Canonical باز است.
- PR #7 CI consolidation باز است.
- PR #8 RTL Timeline shell باز است.
- PR #10 Timeline Domain contract باز است.
- همه PRهای #3/#7/#8/#10 در آخرین Audit non-draft و mergeable بودند؛ این وضعیت قبل از هر Merge دوباره Verify شود.

## موج موازی فعال
### Lane A — Core / Domain
PR #10 — `feat(core): define minimal Timeline Item contract`
Branch:
`core/timeline-item-contract`
Head در این Snapshot:
`53825cc629fca1285e20c57bfdbc91369eabfb8c`

Scope:
- `TimelineItemType`: note/event/call/idea/activity
- `TimelineItem`
- `timelineAt = occurredAt ?? createdAt`
- Domain tests

عمداً بدون Database، Persistence، Repository implementation، UI، Search، Reminder یا Migration.

Issue ownership:
#9 → PR #10 only.

### Lane B — UI
PR #8 — `feat(ui): establish RTL timeline shell`
Branch:
`ui/rtl-timeline-shell`
Head در این Snapshot:
`5e459940fedf8a5b83cb9708396ca6ea7ca0a989`

Scope:
- TimelineScreen
- Persian RTL shell
- empty state
- Quick Capture entry contract
- Quick Capture تا Persistence واقعی غیرفعال
- widget tests

Issue ownership:
#5 → PR #8 only.

### Lane C — CI
PR #7 — `ci: consolidate Flutter quality gates`
Branch:
`ci/consolidate-flutter-gates`
Head در این Snapshot:
`a6d81645bc21b2a6c2e8af2be3d6e02555f139b7`

Scope:
- یک Fast Quality Gate واقعی
- `permissions: contents: read`
- concurrency + `cancel-in-progress: true`
- Flutter cache
- explicit diagnostics
- `flutter pub get → flutter analyze → flutter test`
- حذف `test.yml` Placeholder
- حذف `build.yml` Placeholder

Issue ownership:
#6 → PR #7 only برای Fast Gate.
Full Build Gate بعداً و فقط پس از وجود platform build path واقعی.

### Lane C — Documentation
PR #3 — `docs: establish YadNegar canonical project documentation`
Branch:
`docs/yadnegar-documentation-baseline`

شامل:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `PROJECT_DOCUMENTATION_FA.md`
- README map و compatibility pointers

PR #3 فقط Documentation/README است؛ Application code یا Workflow behavior را تغییر ندهد.

## CI Reality
روی main بعد از Merge Foundation، سه Workflow موقت وجود داشتند و failure/startup_failure/queued دیده شد. Job-step evidence کافی برای نسبت‌دادن این وضعیت به Application Code وجود نداشت.

آخرین Evidence مهم:
- PR #7 exact head `a6d81645...`: workflow lookup هنوز صفر Run برگرداند.
- PR #10 exact head `53825cc6...`: workflow lookup هنوز صفر Run برگرداند.
- PR #8 exact head `5e459940...`: Flutter CI run `32986361005` completed/failure گزارش شد، اما job `98233297567` همچنان queued، بدون runner، بدون conclusion و با `steps: []` بود.
- PR #8 old Test run `32986016461` نیز failure ثبت کرده بود.

نتیجه:
هیچ‌کدام از این موارد به‌تنهایی Evidence معتبر شکست کد نیستند. PRهای #7/#8/#10 بدون exact-head job execution واقعی و analyze/test evidence Merge نشوند.

## هدف محصولی نزدیک
اولین Vertical Slice واقعی:
`Quick Capture → Persist → Timeline → View/Edit`

قبل از Persistence:
- PR #10 Domain contract را تثبیت کن.
- Storage را بر اساس نیاز واقعی Audit کن.
- Model/Repository/Storage موازی نساز.

معیارهای Persistence:
- Offline behavior
- Timeline/date queries
- sorting
- migrations
- backup/recovery
- export
- testability
- performance
- Flutter support
- maintainability

## معماری
- Flutter / Dart
- Clean Architecture direction
- Feature-Based organization
- Persian RTL-first
- Reuse before rebuild
- No duplicate App Shell
- No duplicate Router without justification
- No competing Timeline model
- No competing Repository/Storage foundation
- No duplicate CI path
- No duplicate canonical documentation

## Validation
Fast Gate فعلی:
`flutter pub get → flutter analyze → flutter test`

`flutter build` فقط وقتی platform project/build path واقعی وجود داشته باشد و Build واقعاً اجرا شود.

Evidence فقط برای Ref/SHA دقیق خودش معتبر است.

## ترتیب ادامه پیشنهادی
1. Fresh Audit.
2. PR #7 exact-head Actions را بررسی و CI را تثبیت کن.
3. اگر Fast Gate واقعی سبز شد، PR #7 را با expected head امن Merge کن.
4. main جدید را Verify کن.
5. PR #8 و PR #10 را روی CI جدید Revalidate کن.
6. فقط با exact-head analyze/test سبز Merge کن.
7. PR #3 را با وضعیت جدید Sync و بعد از Evidence معتبر Merge کن.
8. Persistence را Audit کن.
9. Vertical Slice `Quick Capture → Persist → Timeline → View/Edit` را بساز.

## اصل کار
کار موازی هماهنگ سریع.
تولید نرم‌افزار در چند ساعت به‌جای چند روز.
Automation و Documentation همزمان با کار واقعی GitHub.
سرعت نباید Audit، Test، Evidence، Recovery یا Safe Integration را حذف کند.

## گزارش به مالک پروژه
کوتاه، ساده و غیر فنی:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

## Trigger ادامه
`ادامه یادنگار`

معنی:
`Audit live GitHub → reconcile docs → inspect active PRs/issues → avoid duplicate work → parallel execute → validate exact refs → document → short report`

## هشدار انتقال گفتگو
این Snapshot ممکن است چند دقیقه بعد از ثبت منسوخ شود. گفتگوی جدید نباید SHAها یا وضعیت PR/Actions این فایل را بدون بررسی زنده Current فرض کند. GitHub منبع حقیقت است.
