# مستند فنی و محصولی پروژه یادنگار (YadNegar)

## 1. هدف این سند
این فایل مرجع فنی/محصولی برای ادامه توسعه YadNegar است. در هر ادامه یا ارتقا، ابتدا وضعیت زنده GitHub بررسی شود و سپس این سند با Implementation واقعی تطبیق داده شود.

مرجع قواعد عملیاتی پروژه:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

این فایل وضعیت محصول، معماری هدف، مرزهای توسعه و سوابق فنی را توضیح می‌دهد و جایگزین Audit زنده Repository نیست.

## 2. هویت پروژه
- نام: YadNegar / یادنگار
- Repository: `mobinpda-lab/YadNegar`
- شاخه اصلی: `main`
- فناوری هدف: Flutter / Dart
- UI هدف: فارسی و RTL
- معماری هدف: Clean Architecture + Feature-Based Architecture
- محور تجربه محصول: Timeline

## 3. ایده و کارکرد اصلی
یادنگار برای ثبت سریع و مرور منظم اطلاعات روزمره طراحی می‌شود؛ کاربر باید بتواند با کمترین اصطکاک یک مورد را ثبت کند و بعداً آن را در Timeline یا نماهای مرتبط پیدا و مرور کند.

دسته‌های اولیه محصول:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت روزانه

قابلیت‌های پایه هدف:
- Quick Capture
- Timeline
- تاریخ و زمان
- نمایش و ویرایش آیتم
- جستجو و فیلتر در مرحله مناسب
- ساختار مناسب برای توسعه Featureهای آینده

این فهرست Roadmap اولیه است و به معنی پیاده‌سازی فعلی نیست.

## 4. وضعیت واقعی Repository در Snapshot 2026-08-26
وضعیت Verify‌شده `main` پیش از ایجاد Branch مستندات:
- HEAD: `08a799c10a313926cb5d0a88a2601d9b4b132745`
- Message: `ci: add initial build workflow skeleton`
- تاریخ Commit: 2026-08-17

ساختار Root در همان Snapshot:
- `.github/`
- `README.md`

مواردی که در Root وجود نداشتند:
- `pubspec.yaml`
- `lib/`
- `test/`

نتیجه: Flutter Foundation هنوز در آن Snapshot به‌صورت واقعی ایجاد نشده بود. این وضعیت در هر Session آینده باید مجدداً Verify شود.

## 5. وضعیت CI در Snapshot
Workflowهای موجود:
- `.github/workflows/build.yml`
- `.github/workflows/test.yml`

هر دو Workflow فقط شامل `actions/checkout@v4` و یک مرحله Placeholder با `echo` بودند.

Runهای دیده‌شده روی `main` موفق بودند، اما این موفقیت فقط اجرای Placeholder را اثبات می‌کند و مدرک اجرای Flutter Analyze/Test/Build نیست.

CI واقعی فقط بعد از ایجاد Foundation Flutter باید فعال شود.

## 6. معماری هدف
معماری مطلوب:

`Presentation / Features → Application/Use Cases → Domain → Repository Contracts`

و در سمت Infrastructure:

`Data Sources / Persistence / Platform Services → Repository Implementations`

اصول:
- Domain تا حد منطقی مستقل از Flutter/Platform باشد.
- Featureها Boundary مشخص داشته باشند.
- Foundation مشترک قبل از Featureهای وابسته تثبیت شود.
- Storage و Repository موازی بدون نیاز واقعی ایجاد نشوند.
- تغییر معماری بعد از Audit و بررسی اثر انجام شود.
- از بازنویسی زودهنگام و Over-engineering جلوگیری شود.

## 7. ساختار پیشنهادی Foundation
این ساختار «هدف اولیه» است و هنگام ایجاد Flutter project باید با نیاز واقعی تطبیق داده شود:

```text
lib/
  app/
  core/
  features/
    timeline/
    capture/
    notes/
    events/
    calls/
    ideas/
    activities/
test/
```

نباید همه Featureها در اولین Commit ساخته شوند. Foundation باید حداقلی، معتبر و قابل تست باشد.

## 8. مدل داده اولیه — اصل طراحی
پیش از تثبیت Entityها باید Audit و طراحی انجام شود.

به‌صورت مفهومی، آیتم Timeline ممکن است نیازمند اطلاعاتی مانند این‌ها باشد:
- شناسه یکتا
- نوع آیتم
- عنوان/متن
- زمان ایجاد
- زمان رویداد یا تماس در صورت وجود
- وضعیت/metadata مرتبط با Feature

اما Schema نهایی، Persistence technology و قرارداد Migration هنوز تصمیم Verify‌شده نیستند و نباید صرفاً از این سند به‌عنوان Implementation قطعی برداشت شوند.

## 9. Storage و Migration
در Snapshot فعلی Storage واقعی وجود ندارد.

هنگام انتخاب Persistence باید بررسی شود:
- Offline-first بودن یا نبودن
- سادگی Migration
- Queryهای Timeline
- جستجو و فیلتر
- حجم داده
- Backup/Restore آینده
- تست‌پذیری
- سازگاری با Android/iOS در صورت نیاز

هر Schema change آینده باید در صورت کاربرد شامل:
`Versioning + Migration + Backward Compatibility + Validation + Recovery`

باشد.

## 10. UI و UX هدف
اصول UI:
- کاملاً فارسی و RTL-first
- سریع و مناسب استفاده روزمره
- Timeline محور
- ثبت سریع با حداقل Tap
- سلسله‌مراتب بصری آرام و خوانا
- Navigation ساده
- نمایش روشن تاریخ و زمان
- عدم فداکردن معماری برای ساخت سریع Mock UI

Componentهای پایه پیشنهادی:
- App Shell
- Timeline Screen
- Quick Capture Entry
- Item Card
- Item Detail/Edit
- Navigation
- Date/Time presentation

## 11. مدل توسعه موازی
### مسیر A — Core / Domain / Foundation
- Flutter foundation
- Entity/Value Object
- Repository contracts
- Shared business rules
- Shared infrastructure boundaries

### مسیر B — UI / Feature
- RTL app shell
- Timeline UI
- Quick Capture
- Feature screens

### مسیر C — CI / Automation / Documentation
- GitHub Actions
- Analyze/Test/Build
- quality gates
- docs/current state/handoff

قاعده: اگر Laneها روی Foundation یا فایل مشترک تداخل ندارند، همزمان اجرا شوند.

## 12. برنامه پیشنهادی مرحله Foundation
پس از Verify مجدد `main`:
1. Branch کوچک Foundation ایجاد شود.
2. حداقل Flutter project معتبر ایجاد شود.
3. `pubspec.yaml`، `lib/main.dart` و baseline test ایجاد شوند.
4. از افزودن Featureهای غیرضروری در Commit Foundation خودداری شود.
5. `flutter pub get` اجرا شود.
6. `flutter analyze` اجرا شود.
7. `flutter test` اجرا شود.
8. در صورت آماده بودن Platform، Build پایه بررسی شود.
9. Evidence ثبت و PR ایجاد شود.

## 13. برنامه پیشنهادی CI واقعی
فقط پس از وجود Flutter Foundation:
1. setup Flutter stable
2. cache در صورت ارزش واقعی
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`
6. `flutter build` در مرحله مناسب
7. artifact/release validation در زمان مناسب

Workflow Placeholder نباید بدون Foundation به CI ظاهراً واقعی تبدیل شود.

## 14. سیاست تست
حداقل تست‌ها با رشد پروژه:
- Unit tests برای Domain/Use Cases
- Widget tests برای رفتارهای UI مهم
- Integration tests برای Flowهای اصلی
- RTL checks
- Golden tests در صورت تثبیت Design System
- Migration tests پس از ایجاد Persistence نسخه‌دار

تست قرمز باید علت‌یابی شود؛ حذف تست صرفاً برای سبزکردن CI ممنوع است.

## 15. Git و Commit
فرآیند استاندارد:
`Audit → Analyze → smallest effective change → Validate → Report/Evidence → Commit → PR`

قواعد:
- Commit تک‌منظوره
- Branch هدفمند
- Rollback ساده
- عدم کار عادی مستقیم روی main
- عدم Force rewrite در روند عادی
- عدم ادعای موفقیت بدون Evidence

## 16. مستندسازی پروژه
مستندات فعال پایه:
- `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md` — مرجع Canonical عملیات
- `docs/AI_CONTINUATION_STATE.md` — Snapshot وضعیت جاری
- `docs/AI_HANDOFF_CURRENT_FA.md` — Handoff فشرده
- `PROJECT_DOCUMENTATION_FA.md` — مستند فنی و محصولی

مستندات Feature و ADR در آینده فقط هنگام وجود تصمیم یا Implementation واقعی ایجاد شوند.

## 17. قانون ادامه پروژه
Trigger:
`ادامه یادنگار`

فرآیند:
1. Verify دسترسی GitHub.
2. Verify Repository/Branch/HEAD.
3. بررسی Commitهای اخیر و PRهای باز.
4. بررسی Workflow و CI Ref دقیق.
5. مطالعه Canonical و Current State.
6. Audit Implementation واقعی.
7. انتخاب نزدیک‌ترین Gap واقعی.
8. اجرای موازی کارهای مستقل.
9. Validation.
10. Documentation/Evidence.
11. Commit/PR کوچک و قابل Rollback.
12. گزارش فشرده.

## 18. معیار موفقیت مرحله اول پروژه
Foundation زمانی قابل قبول است که حداقل:
- Flutter project معتبر باشد.
- dependency resolution موفق باشد.
- Analyze بدون خطای مسدودکننده اجرا شود.
- baseline tests موفق باشند.
- CI واقعی همان checks را روی Ref دقیق اجرا کند.
- معماری اولیه بدون Featureهای جعلی یا اضافی قابل توسعه باشد.
- مستندات وضعیت جدید را منعکس کنند.

## 19. اولویت توسعه پس از Foundation
اولویت‌ها فقط پس از Audit مجدد تعیین می‌شوند، اما مسیر منطقی اولیه:
1. Foundation
2. CI واقعی
3. Domain/Timeline contract
4. App Shell + RTL
5. Quick Capture
6. Timeline rendering
7. Featureهای Note/Event/Call/Idea/Activity
8. Search/filter
9. Persistence hardening
10. Backup/Restore/Release concerns در زمان مناسب

## 20. قاعده نهایی
هدف یادنگار فقط ساخت چند صفحه یا MVP نمایشی نیست.

هدف:
`Foundation سالم → معماری پایدار → CI معتبر → Core → UI → Features → Tests → Release`

سرعت از Parallel Execution و جلوگیری از دوباره‌کاری می‌آید. کیفیت، معماری، Recovery و Evidence حذف نمی‌شوند.
