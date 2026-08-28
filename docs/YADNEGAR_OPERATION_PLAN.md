# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 5.0 — Canonical Tracked-Task Contract Integrated

**تاریخ مبنا:** 2026-08-28  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده با بیشترین سرعت امن.

چرخه استاندارد:
`Fresh Audit → Reuse → Decompose → Maximum Parallel → Focused Tests → exact-head CI/Android → fresh scope → expected-head merge → post-main proof → docs sync → issue cleanup → next real slice`

Laneهای مستقل:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Stacked preparation فقط وقتی مجاز است که branch بعداً Fresh compare شود و Scope/Dependency مستقل باقی مانده باشد.

## 2. main فعلی
Current verified main:
`2c1f944f94de729037adc62939650863123786c3`

جهت canonical محصول بر اساس #121:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → PDF/Share/Print`

Foundation قدیمی Timeline/Reminder/JSON حذف نشده و reuse شده است. ابزار Timeline تخت قدیمی در بخش legacy باقی می‌ماند، اما Product capacity باید روی قرارداد tracked-task متمرکز باشد مگر اینکه قابلیت قدیمی مستقیماً به قرارداد فعلی کمک کند.

## 3. رفتار اصلی محصول تکمیل‌شده
### Tracked Task
- یک root ثابت برای هر کار
- description/summary چندخطی اختیاری
- create/edit/detail کامل
- Home compact

### FollowUp
- هر پیگیری child همان root است
- history append-only از نظر رفتار محصول
- صفحه مستقل `ثبت پیگیری`
- عنوان اختیاری؛ خالی => `پیگیری`
- زمان پیش‌فرض دستگاه و قابل ویرایش قبل از ذخیره
- Jalali input + Persian digits
- ویرایش هر FollowUp با حفظ parent/siblings

### Home / Detail
- آخرین FollowUp واقعی مبنای exact date/time و relative text
- no-follow-up state واقعی
- elapsed-since-latest محاسباتی، نه persisted
- inter-follow-up interval محاسباتی، نه persisted
- newest FollowUp first

### PDF
- همه کارها
- کارهای انتخاب‌شده
- یک کار با همه پیگیری‌ها
- RTL Persian + Jalali + Persian digits + bundled Vazirmatn
- description در صورت وجود
- Share/Print روی همان projection/document path

## 4. Data / Storage Safety
Current schema: **v5**  
Backward-compatible reads: **v1-v4**

Schema evolution:
- v4: optional `parentId` برای root/follow-up relation
- v5: optional tracked-task `description`

قواعد پایدار:
- یک Repository/Storage واحد
- no duplicate Task/FollowUp DB
- no destructive migration
- no read-time rewrite
- safe-write upgrade
- tmp/bak recovery
- validated Backup/Restore
- unsupported newer schema fail-closed

## 5. موج canonical #121
تکمیل‌شده:
- #122 / PR #124 — root/follow-up foundation
- #126 / PR #130 — Jalali picker + Persian date/time digits
- #129 / PR #133 — computed Persian duration foundation
- #128 — final follow-up capture/edit/Home/detail semantics
- #125 / PR #138 + PR #139 — PDF + all/selected/single + share/print
- #140 / PR #141 + PR #142 — schema v5 description + UI + PDF

PR #120 از موج flat Timeline عمداً Superseded و merge نشده است.

## 6. Evidence نهایی محصول
PR #142 final head:
`da362d2138df05b859468d36b52b61d1ac95192f`

Merged main:
`2c1f944f94de729037adc62939650863123786c3`

Pre-merge exact-head:
- CI `33179167525`: success
- UI Evidence `33179167522`: success
- Android `33179167509`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main exact SHA:
- CI `33179977417`: success
- Android `33179977437`: success full chain
- Build/Candidate/Smoke-Recovery/Readiness/Release-Draft/Approval: all success

320px create flow روی Theme واقعی برنامه تست و اصلاح شده است؛ Dialog inset افقی 20px دارد.

## 7. Release Baseline
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

ممنوع بدون Owner/Security decision صریح:
- production keystore/secret
- production signing claim
- real release tag
- GitHub Release
- Play Store publish

## 8. Automation
### Issue #19
تنها Gap شناخته‌شده Platform-level است.

Ruleset `main-protection`:
- PR required
- branch deletion blocked
- non-fast-forward blocked

اما required status checks هنوز enforce نشده‌اند چون Connected tooling Ruleset Write ندارد.

تا enforcement واقعی:
`exact head + exact-head relevant gates + fresh scope + live mergeability + exact expected_head_sha + post-main proof`

### Docs-only Contract
1. branch از verified main یا safe fast-forward بدون Force
2. دقیقاً scope مستندات مورد انتظار
3. exact docs head
4. Fast CI Green همان Head
5. live mergeability=true
6. exact expected-head merge
7. post-main Fast CI

## 9. Documentation Finalization
Active branch:
`docs/tracked-task-canonical-final`

این branch قبل از docs write، فقط بعد از Green کامل Product post-main بدون Force به exact main `2c1f944...` fast-forward شده است.

Scope مورد انتظار دقیقاً چهار فایل:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

این sync دو debt را همزمان تسویه می‌کند:
- #117 — Product قدیمی complete، docs debt باقی‌مانده
- #121 — parent canonical tracked-task که همه childهای محصولی آن اکنون complete هستند

بعد از docs merge + post-main Fast CI، هر دو Issue completed بسته می‌شوند.

## 10. Maximum Parallel Contract
- Product / Release / Automation / Docs تا حد استقلال موازی
- هیچ Runner منفرد نباید کل پروژه را متوقف کند
- Reuse قبل از Rebuild
- کوچک‌ترین Slice برگشت‌پذیر
- تست focused زودهنگام
- Full gates فقط برای exact head نهایی
- evidence تاریخی برای head جدید ممنوع
- branchهای stacked بعد از تغییر base باید fresh compare شوند
- مستندات فقط واقعیت اثبات‌شده را ثبت کنند

## 11. خط قرمز
- duplicate workflow/foundation/storage
- fake/stale evidence
- destructive migration بدون قرارداد
- direct risky main edit
- force update غیرضروری branch
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون تصمیم صریح
- حذف Gate برای سرعت
- ساخت Backlog مصنوعی

## 12. Queue
### اکنون
- docs finalization برای #117/#121
- #19 platform enforcement gap

### بعد از docs closure
اگر Fresh Audit هیچ gap واقعی پیدا نکرد:
- Product Issue جدید ایجاد نشود.
- تست دستی/UX audit یا بررسی قابلیت‌های موجود برای یافتن کوچک‌ترین نیاز واقعی انجام شود.
- Slice بعدی فقط با Definition of Done روشن، reuse بالا و scope کم باز شود.

## 13. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Immediate Documentation`

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
