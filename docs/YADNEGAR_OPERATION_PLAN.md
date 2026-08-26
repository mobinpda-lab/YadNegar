# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.0 — Product Expansion + Retrieval + Release Automation

**تاریخ مبنا:** 2026-08-26  
**وضعیت:** Current execution plan  
**مرجع حقیقت:** GitHub Repository State  
**مرجع قواعد:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`  
**Current State:** `docs/AI_CONTINUATION_STATE.md`  
**Handoff:** `docs/AI_HANDOFF_CURRENT_FA.md`

## 1. هدف اجرایی
YadNegar دیگر Repository اولیه یا Foundation آزمایشی نیست. هدف فعلی، توسعه سریع محصول قابل‌استفاده روی Core یکپارچه‌شده است:

`Product Slice → Fast CI → Android Build → Evidence → Merge → Main Validation → Docs Sync`

اصل دائمی:

`کار موازی هماهنگ + Reuse + Automation + Test/Build واقعی + Documentation همزمان + Merge با Evidence`

هدف سرعت، تحویل نرم‌افزار معتبر در ساعت‌ها به‌جای چند روز است؛ نه افزایش تعداد PR یا حذف Gate.

## 2. وضعیت Verify‌شده فعلی
### main
Current integrated product head در این موج:
`866a61b8ba8d26666d4d0436d36f402478af25b3`

این main شامل موارد زیر است:
- Flutter/Dart + Persian RTL foundation
- Timeline Domain واحد
- `TimelineRepository`
- JSON persistence واقعی و versioned MVP
- Quick Capture / Load Timeline / Edit Timeline application logic
- Timeline UI واقعی
- Quick Capture → Persist → Reload → Render
- production-safe application-support persistence
- View/Edit واقعی
- انتخاب نوع Timeline در Quick Capture
- Android project foundation واقعی و committed
- Fast CI
- Android APK Build Gate دائمی
- Canonical documentation baseline

### Build/CI
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Full Build Gate روی main قبلی `1b31899d69d3f1fa98520dcc82a9251a7026cc09` با Runهای واقعی Fast + Android و APK Artifact مستقل اثبات شده و Issue #6 completed است.

### Ruleset Gap
`main-protection` Pull Request را الزام می‌کند اما required status check پلتفرمی هنوز تنظیم نشده است.
Issue #19 تنها Owner این Gap است. تا زمانی که Ruleset write capability واقعی در دسترس نباشد، enforcement دستی/عملیاتی همان exact-head Green + expected-head merge lock است.

## 3. وضعیت Waveها
### Wave 0 — Governance / Reality Baseline
**COMPLETED**

Canonical docs روی main هستند. سند موازی Governance ساخته نشود.

### Wave 1 — Flutter Foundation
**COMPLETED**

Foundation واحد و تست‌پذیر روی main است.

### Wave 2 — Domain / Persistence / CI Consolidation
**COMPLETED**

- Timeline Domain
- Repository contract
- JSON persistence
- Fast CI
- active branch coverage

همگی یکپارچه‌اند.

### Wave 3 — First Vertical Slice
**COMPLETED**

`Quick Capture → Persist → Timeline → View/Edit`

Production bootstrap نیز durable و platform-safe است.

### Wave 3.5 — Android Foundation / Full Build Gate
**COMPLETED**

- Android files committed
- real debug APK build proven
- APK verify/upload automated
- permanent build workflow read-only
- post-merge main proof ثبت شده

### Wave 4 — Feature Expansion
**ACTIVE**

اولین Slice این Wave با PR #34 وارد main شد:
- Note
- Event
- Call
- Idea
- Activity

همه روی `TimelineItemType` موجود؛ بدون Model/Repository/Storage موازی.

### Wave 5 — Retrieval & Reliability
**ACTIVE IN PARALLEL**

Issue #35 / PR #36 Application foundation جستجو/فیلتر را می‌سازد:
- text query
- type filter
- ترکیب query + type
- حفظ newest-first order
- unmodifiable result

Search UI بعد از Integration Application boundary روی همین contract ساخته می‌شود.

## 4. مدل اجرای موازی فعلی
### Lane A — Application / Retrieval / Data Reliability
مالک:
- Search/filter contracts
- storage schema hardening در صورت نیاز واقعی
- migration/recovery tests
- query optimization فقط وقتی Evidence حجم/Latency آن را توجیه کند

Current work:
- PR #36 SearchTimeline application foundation

### Lane B — Product / UX
مالک:
- typed capture UX
- Search UI
- filter controls
- date/group views
- item detail improvements

Current state:
- typed Quick Capture integrated
- Search UI منتظر contract یکپارچه SearchTimeline است، نه طراحی دوباره Repository

### Lane C — CI / Android / Documentation
مالک:
- Fast CI
- Android Build Gate
- artifacts
- Ruleset hardening وقتی write capability فراهم شود
- Current State / Handoff / Operation Plan

Current work:
- PR #32 docs synchronization
- Issue #19 ruleset gap

## 5. قواعد Parallel Safety
1. Block شدن Build یک PR، Lane مستقل Application/Docs را متوقف نمی‌کند.
2. Shared Domain/Repository/Storage فقط با Owner روشن تغییر می‌کند.
3. UI حق ساخت query/storage path مستقل ندارد؛ Application contract را مصرف می‌کند.
4. Documentation همزمان به‌روز می‌شود، اما Product Lane را سریالی نمی‌کند.
5. اگر main بعد از ایجاد PR جلو رفت، PR قبل از Merge با main تازه Sync و دوباره exact-head validate می‌شود.
6. stale run Evidence نیست؛ concurrency باید Run قدیمی را لغو کند.
7. Merge فقط با live mergeability + exact current head + Green gates.

## 6. PR / Merge Contract
هر PR باید:
- یک هدف اصلی روشن داشته باشد
- Diff قابل‌بازگشت داشته باشد
- Test مرتبط داشته باشد
- Architecture موجود را reuse کند
- exact-head Fast CI بگیرد
- اگر `lib/**`, `android/**` یا build surface را تغییر می‌دهد، Android Build Gate واقعی بگیرد
- Artifact فقط وقتی Build workflow واقعاً اجرا شده گزارش شود

Merge command باید تا حد امکان expected head SHA را lock کند.

## 7. Feature Expansion Contract
Featureهای Note/Event/Call/Idea/Activity variant مستقل نیستند؛ همه Timeline item هستند.

قانون:
- `TimelineItemType` موجود reuse شود.
- `TimelineRepository` موجود reuse شود.
- metadata جدید ابتدا به shared contract اضافه شود، نه Feature storage جدا.
- UI labels فارسی و RTL-first باشند.

### نزدیک‌ترین Featureهای باارزش
1. typed Quick Capture — **Integrated**
2. occurred-at/date selection برای Event/Activity — candidate
3. type-specific visual treatment بدون تغییر Domain — candidate
4. quick filter chips روی Search contract — بعد از PR #36

## 8. Retrieval Contract
### Phase A — Application boundary
Issue #35 / PR #36:
`Repository snapshot → SearchTimeline → filtered immutable result`

### Phase B — UI
بعد از Merge A:
- search field
- type filter
- clear/reset state
- empty-result state
- RTL widget tests

### Phase C — Scale only when justified
فقط اگر داده/Latency واقعی نیاز نشان داد:
- repository-level query
- indexing
- pagination
- DB migration

تا آن زمان in-memory filtering روی repository snapshot یک MVP آگاهانه است، نه بدهی پنهان.

## 9. Persistence / Reliability
JSON persistence فعلی:
- واقعی
- durable در application support directory
- schema-versioned
- test-covered
- replaceable

DB migration فقط با Evidence نیاز انجام شود:
- query volume
- indexing
- atomic transaction نیاز
- migration/recovery complexity
- performance limit

هیچ DB صرفاً برای «production-looking architecture» اضافه نشود.

## 10. CI / Build Automation
### Fast CI
هدف: feedback سریع.

- pub get
- analyze
- test
- cache
- concurrency
- cancel stale runs
- active branch coverage

### Android Build
هدف: deployable surface proof.

- pub get
- debug APK build
- APK existence verification
- artifact upload
- read-only token

### آینده
Release build/signing فقط وقتی release credential/process واقعی تعریف شود. Debug APK را Release artifact جا نزن.

## 11. Documentation همزمان
چهار سطح:

### Canonical Governance
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`
فقط قواعد ماندگار.

### Active Plan
`docs/YADNEGAR_OPERATION_PLAN.md`
همین سند؛ Waveها و صف واقعی.

### Current State
`docs/AI_CONTINUATION_STATE.md`
SHA/PR/CI/Issue/Evidence زنده.

### Handoff
`docs/AI_HANDOFF_CURRENT_FA.md`
نقطه شروع اجرای بعدی.

Rule:
Implementation/CI تغییر مادی → همان موج Docs Sync، بدون منتظرماندن تا پایان پروژه.

## 12. Current Work Queue
### Active
- PR #36 — SearchTimeline application foundation
- PR #32 — documentation synchronization
- Issue #19 — required CI status in ruleset؛ blocked by connector capability

### Recently Completed
- PR #30 — platform Fast CI coverage
- PR #31 — Android foundation + permanent APK build
- PR #34 — typed Quick Capture
- Issues #6, #28, #29, #33 — completed

### Next Ready Queue
1. Merge PR #36 فقط بعد از Fast CI + Android Build exact-head Green.
2. Search UI روی contract Merge‌شده.
3. Date/occurredAt capture برای Event/Activity در Lane مستقل.
4. Final docs sync/merge PR #32.
5. Ruleset hardening فقط با write capability واقعی.

## 13. Definition of Done برای Product Slice
یک Slice زمانی Done است که:
- user-visible یا reusable application capability واقعی داشته باشد
- tests مرتبط سبز باشند
- Fast CI exact-head Green باشد
- Android Build در Surfaceهای لازم Green باشد
- conflict/main drift resolve شده باشد
- docs impact ثبت شده باشد
- PR با SHA-lock merge شود
- main regression evidence بررسی شود

## 14. Work Queue Hygiene
هر continuation:
1. main SHA Audit
2. open PRs Audit
3. exact-head workflow Audit
4. Issue ownership Audit
5. stale/duplicate work detection
6. independent Lane execution
7. safe merge
8. main validation
9. docs refresh
10. next independent Slice

تعداد PR معیار سرعت نیست؛ زمان رسیدن قابلیت معتبر به main معیار است.

## 15. گزارش مالک پروژه
فقط:

`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه و غیر فنی. جزئیات فنی و Evidence در GitHub باقی بماند.

## 16. خط قرمزها
- Foundation دوم
- App Shell دوم
- Timeline Model دوم
- Repository/Storage موازی
- Search engine موازی قبل از Application contract
- Build claim بدون Run/Artifact
- Merge بدون exact-head evidence
- حذف Test برای سبزشدن
- required-status ادعایی بدون Ruleset write واقعی
- سریالی‌کردن Laneهای مستقل
- نگه‌داشتن سند عملیاتی stale
- درصد پیشرفت ساختگی

## 17. معیار سرعت درست
سرعت مطلوب YadNegar:

`Gap واقعی → Branch مستقل → Implementation → Test → Fast CI/Build موازی → Merge → Main Proof → Docs → Slice بعدی`

هدف: **Working Software + Evidence در چند ساعت، نه فعالیت نمایشی در چند روز.**
