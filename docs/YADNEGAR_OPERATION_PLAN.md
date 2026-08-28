# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 5.1 — Tracked-Task + Search Contract Verified

**تاریخ مبنا:** 2026-08-28  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
چرخه استاندارد:
`Fresh Audit → Reuse → Decompose → Maximum Parallel → Focused Tests → exact-head CI/Android → fresh scope → expected-head merge → post-main proof → docs sync → issue cleanup → next real slice`

Laneهای مستقل:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Green تاریخی برای Head جدید معتبر نیست.

## 2. main Verify‌شده فعلی
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

جهت canonical محصول:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Share/Print`

Timeline/Reminder/JSON قدیمی حذف نشده و reuse شده است؛ ابزار Timeline تخت فقط legacy tooling است.

## 3. قابلیت‌های اصلی تکمیل‌شده
### Tracked Task
- یک root ثابت برای هر کار
- description چندخطی اختیاری
- create/edit/detail کامل
- Home compact

### FollowUp
- هر پیگیری child همان root است
- تاریخچه persistent و history-safe
- صفحه مستقل `ثبت پیگیری`
- عنوان اختیاری؛ خالی => `پیگیری`
- تاریخ/ساعت دستگاه با ورودی جلالی قابل ویرایش
- ویرایش هر FollowUp با حفظ parent/siblings

### Home / Detail
- latest real FollowUp مبنای exact Jalali date/time و relative helper
- no-follow-up state واقعی
- elapsed/inter-follow-up duration محاسباتی، نه persisted
- newest FollowUp first

### Search
Home search اکنون با reuse داده‌های از قبل loadشده، root را با تطبیق هرکدام از این‌ها برمی‌گرداند:
- عنوان کار
- شرح اختیاری کار
- متن هر FollowUp فرزند

هیچ disk read یا search service دوم هنگام تایپ وجود ندارد. ترتیب و hierarchy فعلی حفظ می‌شود.

### PDF
- همه کارها
- کارهای انتخاب‌شده
- یک کار با کل تاریخچه
- RTL Persian + Jalali + Persian digits + bundled Vazirmatn
- description در صورت وجود
- Share/Print روی همان projection/document path

## 4. Data / Storage Safety
Current schema: **v5**  
Backward-compatible reads: **v1-v4**

Schema evolution:
- v4: optional `parentId`
- v5: optional tracked-task `description`

قواعد:
- یک Repository/Storage واحد
- no duplicate Task/FollowUp DB
- no destructive migration
- no read-time rewrite
- safe-write upgrade
- tmp/bak recovery
- validated Backup/Restore
- unsupported newer schema fail-closed

## 5. موج canonical تکمیل‌شده #121
#121 قبلاً Completed شده است:
- #122 / PR #124 — root/follow-up foundation
- #126 / PR #130 — Jalali/Persian date-time
- #129 / PR #133 — computed Persian duration
- #128 — FollowUp UX + correct Home/detail semantics
- #125 / PR #138 + #139 — PDF/share/print
- #140 / PR #141 + #142 — schema v5 description + UI + PDF
- PR #143 — canonical docs closure

#117 نیز قبلاً Completed شده است. این دو Issue جزو Queue آینده نیستند.

## 6. آخرین موج محصول — #144 / PR #145
هدف: هماهنگ‌کردن رفتار جستجو با متن واقعی UI.

Final head:
`b876bade5c89d5215d7955c8b1ffc250bd8f627e`

Fresh scope: دقیقاً دو فایل، `behind=0`.

Pre-merge:
- CI `33183658883`: success
- UI Evidence `33183658891`: success
- Android `33183658875`: success full chain

Merged main:
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

Post-main:
- CI `33185558030`: success
- Android `33185558017`: success full chain
- Debug/Candidate/Smoke-Recovery/Readiness/Release-Draft/Approval: all success

#144 Completed است.

## 7. Release Baseline
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

وضعیت:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

بدون تصمیم صریح Owner/Security انجام نشود:
- production keystore/secret
- real release tag
- GitHub Release
- Play Store publish

## 8. Automation / Issue #19
تنها Gap شناخته‌شده Platform-level است.

Ruleset `main-protection` فعال است:
- PR required
- deletion blocked
- non-fast-forward blocked

required status checks هنوز enforce نشده‌اند چون Connected tooling Ruleset Write ندارد.

تا enforcement واقعی:
`exact head + exact-head relevant gates + fresh scope + live mergeability + exact expected_head_sha + post-main proof`

Docs-only:
`exact docs head + Fast CI + fresh docs scope + live mergeability + expected-head merge + post-main Fast CI`

## 9. Documentation Sync فعلی
Branch:
`docs/tracked-subject-search-content`

Branch پس از Green کامل post-main #145 بدون Force روی exact main `9b577cc...` قرار گرفته است.

Scope مورد انتظار فقط چهار فایل:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

هدف این sync:
- ثبت #144/#145 و evidence جدید
- حذف drift اسناد که #117/#121 را اشتباهاً کار آینده نشان می‌دادند
- ثبت صف واقعی فعلی

## 10. Maximum Parallel Contract
- Product / Release / Automation / Docs تا حد استقلال موازی
- Reuse قبل از Rebuild
- کوچک‌ترین Slice برگشت‌پذیر
- تست focused زودهنگام
- Full gates فقط روی exact head نهایی
- stale/fake evidence ممنوع
- branchهای stacked بعد از base move باید fresh compare شوند
- مستندات فقط واقعیت Verify‌شده را ثبت کنند

## 11. خط قرمز
- duplicate workflow/foundation/storage
- destructive migration بدون قرارداد
- direct risky main edit
- force update غیرضروری
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون تصمیم صریح
- حذف Gate برای سرعت
- Backlog مصنوعی

## 12. Queue فعلی
- Product PR باز: ندارد
- Product Issue باز شناخته‌شده: ندارد
- Issue باز: فقط #19، Platform-limited

بعد از merge این docs sync، #19 با main/evidence جدید refresh شود. سپس Fresh Audit انجام شود؛ Feature جدید فقط با یک gap واقعی و کوچک، DoD روشن و reuse بالا ایجاد شود.

## 13. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Immediate Documentation`

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
