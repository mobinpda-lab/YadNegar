# سند جامع پروژه یادنگار (YadNegar)
## نسخه 2.0 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Product Direction:** Persian RTL tracked tasks with persistent follow-up history  
**Reality Authority:** GitHub Repository State  
**Current Execution Plan:** `docs/YADNEGAR_OPERATION_PLAN.md`

---

## 1. قانون حقیقت و ادامه
ترتیب اعتبار:
`GitHub Reality > Owner-approved Product Contract > Canonical Governance > Comprehensive Reference > Current Handoff > Conversation Memory`

قبل از هر Write/Merge/گزارش وضعیت:
`Fresh Audit → exact SHA → current gates → fresh scope → live mergeability`

Green تاریخی برای Head جدید قابل انتقال نیست.

---

## 2. وضعیت Verify‌شده فعلی — 2026-08-28
Current verified product main:
`2c1f944f94de729037adc62939650863123786c3`

قرارداد canonical محصول Issue #121 اکنون پیاده‌سازی شده است:
- یک tracked task/root ثابت
- هر FollowUp یک child persistent همان root
- هیچ FollowUp جدید root تازه ایجاد نمی‌کند
- افزودن/ویرایش FollowUp تاریخچه قبلی را حذف یا replace نمی‌کند
- Repository/JSON/Reminder foundation موجود reuse شده و سیستم موازی ساخته نشده است

Timeline تخت قبلی حذف نشده و برای ابزارهای legacy در دسترس است، اما جهت اصلی محصول tracked-task/follow-up است.

---

## 3. تجربه اصلی کاربر
### Home
- root tracked tasks نمایش داده می‌شوند.
- اگر FollowUp وجود داشته باشد، آخرین FollowUp واقعی تاریخ/ساعت دقیق جلالی/فارسی و متن نسبی را تعیین می‌کند.
- root creation date هرگز به‌عنوان آخرین پیگیری جا زده نمی‌شود.
- حالت بدون پیگیری واضح است.
- کارت‌ها compact هستند و description hierarchy اصلی را شلوغ نمی‌کند.

### Detail
- عنوان کار
- description/summary اختیاری
- edit action کار
- latest real FollowUp exact date/time
- elapsed time محاسبه‌شده از آخرین FollowUp
- history newest-first
- interval محاسبه‌شده بین FollowUpها
- round `+` واضح و قابل دسترس
- empty state واقعی برای نبود پیگیری

### FollowUp Capture / Edit
- `+` صفحه مستقل `ثبت پیگیری` را باز می‌کند.
- عنوان اختیاری است.
- عنوان خالی به `پیگیری` normalize می‌شود.
- date/time پیش‌فرض از device clock می‌آید.
- قبل از save قابل تغییر است.
- date input جلالی/فارسی است.
- visible date/time digits فارسی هستند.
- task و FollowUp هر دو بعداً قابل ویرایش‌اند.
- edit یک FollowUp، parent relation و sibling history را حفظ می‌کند.

### Description
- create می‌تواند description چندخطی اختیاری ذخیره کند.
- blank description => null.
- edit می‌تواند add/change/clear کند.
- detail description یا empty state را نشان می‌دهد.
- PDF description را فقط در صورت وجود درج می‌کند.

---

## 4. PDF / Share / Print
یک مسیر read-only export projection روی همان Repository وجود دارد.

Scopeهای محصول:
1. همه tracked taskها
2. tracked taskهای انتخاب‌شده
3. یک tracked task با کل FollowUp history

Document properties:
- PDF واقعی
- RTL Persian
- Persian digits
- Jalali date/time
- bundled Vazirmatn Regular/Bold
- complete root→children grouping
- deterministic ordering
- optional root description

Share و Print همان PDF document path را reuse می‌کنند.

JSON Backup/Restore ویژگی جداگانه machine-readable و Data Safety است و جای PDF را نمی‌گیرد.

---

## 5. معماری و Data Safety
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

Foundation واحد:
- `TimelineItem` و Repository موجود reuse شده‌اند.
- root/follow-up relation روی همان model/store است.
- Reminder روی همان Timeline foundation است.
- DB/Repository/Storage/AppShell/Scheduler دوم وجود ندارد.

Persistence:
- JSON schema-versioned
- current schema **v5**
- backward-compatible reads **v1-v4**
- no read-time rewrite
- tmp/bak crash recovery
- validated safe writes
- Backup/Restore
- unsupported newer schema fail-closed

Schema evolution مهم:
- v4: optional `parentId` برای FollowUp relation
- v5: optional `description` برای tracked-task root

Derived data مثل elapsed time و inter-follow-up interval هرگز Persist نمی‌شود.

اصل Data Safety:
`Schema Version + Compatibility + Validation + Recovery + No Destructive Migration`

---

## 6. تاریخ/زبان/فونت
UI اصلی فارسی و RTL است.

Primary tracked-task/follow-up date presentation:
- Gregorian DateTime/ISO داخل persistence
- Jalali conversion فقط در Presentation/Input boundary
- visible digits فارسی
- device/local timezone semantics برای Reminder حفظ شده است

Bundled default Persian font:
- Vazirmatn

Licensed IRANSansX در صورت configure شدن می‌تواند از مسیر موجود load شود؛ نبود آن نباید محصول را متوقف کند.

---

## 7. Reminder Foundation
Reminder از قبل روی Foundation مشترک Timeline قرار دارد و Store/Scheduler موازی ندارد.

Recurrence contract:
- `none`
- `daily`
- `weekly`

رفتار:
- device-local timezone
- startup reconciliation
- fail-closed وقتی timezone resolve نشود
- persistence مستقل از notification scheduling failure باقی می‌ماند

Persian UX:
`بدون تکرار / روزانه / هفتگی`

---

## 8. موج‌های محصول مهم
### Timeline / Reminder Foundation سابق
- Recurring Reminder — parent #93 / PR #96 / PR #97
- Reminder Status — #99 / PR #100
- Reminder Presence Filter — #102 / PR #103
- Timeline Type Icons / Shared Presentation — #104/#108
- Independent Type/Date/Query clear — #111/#114/#117

این قابلیت‌ها Foundation و legacy tooling را تقویت می‌کنند؛ اما بعد از #121 ظرفیت محصول باید اول قرارداد tracked-task را دنبال کند.

### Canonical Tracked-Task Contract — #121
تحویل به Sliceهای قابل برگشت تقسیم شد:
- #122 / PR #124 — root tracked subjects + persistent FollowUp history
- #126 / PR #130 — Jalali input + Persian date/time digits
- #129 / PR #133 — computed Persian duration helpers
- #128 — dedicated FollowUp capture, task/follow-up edit, correct Home/detail semantics
- #125 / PR #138 + PR #139 — Persian PDF foundation + share/print scopes
- #140 / PR #141 + PR #142 — optional description schema v5 + UI + PDF

PR #120 از مسیر flat Timeline بعد از اصلاح جهت محصول Superseded شد و عمداً merge نشد.

---

## 9. Evidence نهایی canonical completion
PR #142 final head:
`da362d2138df05b859468d36b52b61d1ac95192f`

Merged product main:
`2c1f944f94de729037adc62939650863123786c3`

Pre-merge exact-head evidence:
- YadNegar CI `33179167525`: success
- YadNegar UI Evidence `33179167522`: success
- YadNegar Android Build `33179167509`: success full chain
  - debug APK
  - release candidate
  - emulator startup/storage recovery
  - readiness
  - deterministic release draft
  - approval/rollback evidence
- live mergeability=true
- exact expected-head merge succeeded

Post-main evidence on exact `2c1f944...`:
- YadNegar CI `33179977417`: success
- YadNegar Android Build `33179977437`: success full chain

Narrow Android UI:
- 320px create flow روی Theme واقعی `YadNegarApp` تست می‌شود.
- Material Dialog minimum-width conflict با `DialogThemeData(insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24))` رفع شده است.
- هیچ متن، field یا typography عادی برای رفع overflow حذف نشده است.

---

## 10. Release Governance
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

عمداً انجام نشده:
- production keystore/secret
- production signing
- real release tag
- GitHub Release
- Play Store publish

این‌ها Owner/Security decision مستقل می‌خواهند.

---

## 11. CI و Automation
Fast CI:
- dependency resolution
- analyze
- full tests

Android chain:
- debug APK build/verify/upload
- release-candidate build/evidence
- emulator startup + storage recovery
- readiness evidence
- deterministic version/release-notes draft
- approval/rollback package

Evidence فقط برای SHA دقیق خودش معتبر است.

### Issue #19 — Platform Enforcement Gap
Ruleset `main-protection`:
- PR required
- deletion blocked
- non-fast-forward blocked

اما required status checks هنوز Platform-level enforce نشده‌اند چون connected tooling Ruleset Write ندارد.

تا enforcement واقعی:
`exact current head + exact-head relevant gates + fresh scope + live mergeability + exact expected_head_sha + post-main proof`

---

## 12. Maximum Parallel
Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

قوانین:
1. Block یک Lane، Lane مستقل را متوقف نمی‌کند.
2. Reuse قبل از Rebuild.
3. Slice کوچک و reversible.
4. Stacked preparation فقط با Fresh compare بعد از base move.
5. Docs همزمان ولی فقط با Evidence واقعی.
6. stale/fake evidence ممنوع.
7. حذف Gate برای سرعت ممنوع.
8. merge با Head مبهم ممنوع.

چرخه:
`Audit → Reuse → Decompose → Parallelize → Execute → Fast Feedback → Full Exact-Head Gate → Scope Proof → Integrate → Post-Main Proof → Document`

---

## 13. Documentation Finalization — #117 / #121
Branch:
`docs/tracked-task-canonical-final`

این branch تا پایان Product proof بدون docs write نگه داشته شد؛ سپس بدون Force به exact verified main `2c1f944...` fast-forward شد.

Scope این موج باید دقیقاً چهار سند canonical باشد:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

این موج:
- بدهی Documentation قدیمی #117 را تسویه می‌کند.
- completion واقعی قرارداد parent #121 را ثبت می‌کند.

پس از exact-head docs CI + fresh four-file scope + live mergeability + expected-head merge + post-main Fast CI، #117 و #121 Completed بسته می‌شوند.

---

## 14. صف و انتخاب Slice بعدی
Fresh Audit فعلی نشان می‌دهد بعد از cleanup مستندات، Product Issue باز شناخته‌شده‌ای باقی نمی‌ماند. فقط #19 Platform-limited باز است.

Feature جدید برای پرکردن Backlog ساخته نشود.

انتخاب Slice بعدی:
1. Fresh Audit UI/code/open issues
2. پیدا کردن gap واقعی و کوچک
3. بررسی امکان reuse foundation موجود
4. جلوگیری از schema/store/workflow جدید مگر واقعاً لازم باشد
5. Definition of Done روشن
6. branch از main تازه
7. focused tests + exact-head gates

---

## 15. خط قرمزهای پایدار
- duplicate Task/Timeline/Reminder/Storage/Workflow foundation
- destructive migration بدون قرارداد
- stale/fake evidence
- direct risky main edits
- force push غیرضروری
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون Owner/Security decision
- merge با head نامشخص
- Backlog مصنوعی

---

## 16. Trigger ادامه
عبارت:
`ادامه یادنگار`

اجرای استاندارد:
1. Fresh Audit GitHub
2. exact main/PR/Issue/CI reality
3. Maximum Parallel روی Laneهای مستقل
4. Exact Evidence + safe integration
5. docs فوری پس از proof
6. گزارش کوتاه مالک:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
