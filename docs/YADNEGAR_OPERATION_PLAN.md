# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.2 — Timeline Context Integrated + Edit occurredAt Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State  
**مرجع قواعد:** `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

## 1. هدف اجرایی
تولید نرم‌افزار واقعی و Verify‌شده در چند ساعت به‌جای چند روز با اجرای موازی هماهنگ:
`Fresh Gap → Reuse → Small PR → Tests → exact-head CI/Android → safe merge → main proof → docs sync → next slice`

سرعت از موازی‌سازی، automation و جلوگیری از دوباره‌کاری می‌آید؛ نه از حذف Gate.

## 2. main فعلی
Current verified main:
`6e379f4de11edfd323f79861b04b16992ee6f614`

Main شامل:
- Flutter/Dart + Persian RTL
- Timeline Domain واحد
- Repository و JSON persistence واقعی، schema-versioned و crash-recoverable
- Quick Capture / Load / Edit
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range retrieval
- optional Event/Activity occurredAt capture
- Timeline card date/time context با `timelineAt`
- Vazirmatn + optional private IRANSansX
- Fast CI
- Android debug APK build/verify/upload
- deduplicated GitHub Actions triggers

No duplicate Model/Repository/Storage/AppShell exists.

Current-main post-merge proof after PR #52:
- Fast CI `33016376693`: success
- Android Build `33016376667`: success

## 3. موج‌های اخیر تکمیل‌شده
### PR #49 / Issue #48 — occurredAt Capture
COMPLETED.
- merged `16eb0e041cb6431c83bb9abc844d0291a5bc1cb4`
- pre CI/Android Green
- post-main CI `33015801059` Green
- post-main Android `33015801063` Green

### PR #52 / Issue #51 — Timeline Date/Time Context
COMPLETED.
- merged/current main `6e379f4de11edfd323f79861b04b16992ee6f614`
- exact head `3d082c19200f2b62dd70d382ea885277d17e9337`
- pre CI `33016029795` Green
- pre Android `33016029822` Green
- post CI `33016376693` Green
- post Android `33016376667` Green

## 4. Product Slice فعال — PR #54 / Issue #53
`feat(edit): update Event and Activity occurredAt`

Branch: `feature/edit-occurred-at`  
Exact head snapshot: `183cddb533b58284c534ad2dacee74b88d6dbaff`

Foundation موجود reuse شده:
- `TimelineItem.occurredAt`
- `timelineAt`
- `EditTimelineItem`
- occurredAt picker pattern

Scope:
- توسعه همان `EditTimelineItem`; `updateText` سازگار می‌ماند
- Event/Activity می‌توانند occurredAt را تغییر یا clear کنند
- Note/Call/Idea text-only باقی می‌مانند
- Application + Widget tests
- reload/sort با همان `timelineAt`

ممنوع در این Slice:
- Model جدید
- Repository/Storage/Schema جدید
- Use Case موازی
- dependency جدید برای picker

## 5. Parallel Execution Model
### Lane A — Core / Data
پایدار.
- Domain مشترک
- persistence واقعی
- crash recovery

DB/indexing/pagination فقط با evidence واقعی performance/scale.

### Lane B — Product / UX
فعال: PR #54 / Issue #53.

پس از integration، Gap بعدی فقط با Fresh Audit کد + Issueها انتخاب شود.

### Lane C — CI / Automation / Documentation
فعال:
- Draft PR #50 روی main #52 Sync شده و هم‌زمان #54 را track می‌کند
- Issue #19 Ruleset gap باز است
- workflowهای Fast و Android به‌عنوان gate واقعی ادامه دارند

Build در یک Lane نباید Lane مستقل دیگر را متوقف کند.

## 6. PR / Merge Contract
برای هر Product PR:
- یک هدف اصلی کوچک
- reuse قبل از build
- تست مرتبط
- exact-head `YadNegar CI` Green
- exact-head `YadNegar Android Build` Green
- live head + mergeability read بلافاصله قبل Merge
- merge با `expected_head_sha`
- post-merge main CI/Android proof

Historical Green برای Head جدید معتبر نیست.

## 7. Documentation Contract
Canonical governance:
`docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`

Current execution docs:
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`

PR #43 stale بسته شده است.
PR #50 replacement است و تا پایان Product Wave فعال Draft می‌ماند؛ سپس فقط یک Final Sync و Fresh Audit نهایی می‌گیرد.

## 8. CI / GitHub Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

Feature validation از PR به main انجام می‌شود؛ push quality روی main باقی می‌ماند و duplicate feature push/PR run حذف شده است.

## 9. Ruleset Reality — Issue #19
Main protection هنوز required-status-check rule ندارد.

تا زمانی که Ruleset write واقعاً در دسترس و Verify نشده:
`exact-head Green gates + live mergeability + expected-head lock`
قانون عملیاتی اجباری است.

## 10. Current Work Queue
### Active
1. PR #54 / Issue #53 — edit/clear occurredAt.
2. Draft PR #50 — live docs reconciliation in parallel.
3. Issue #19 — required CI status in Ruleset; platform-write gap.

### Recently Completed
- #49 / #48 — occurredAt capture
- #52 / #51 — timeline date/time context
- #47 / #46 — date-range UI
- #42 / #41 — crash-recoverable persistence
- #45 — CI deduplication
- #44 — typography

## 11. Definition of Done
Product:
`working capability + tests + exact-head CI + Android proof + safe merge + post-main validation + docs impact`

Docs:
`fresh GitHub reconciliation + current-main sync + exact-head validation + non-stale merge`

## 12. خط قرمزها
- Foundation دوم
- App Shell دوم
- Timeline Model دوم
- Repository/Storage موازی
- fake persistence/build/test
- stale merge evidence
- متوقف کردن Lane مستقل به خاطر Build
- سند عملیاتی stale
- ادعای Ruleset enforcement بدون proof
- درصد پیشرفت ساختگی

## 13. گزارش مالک پروژه
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
