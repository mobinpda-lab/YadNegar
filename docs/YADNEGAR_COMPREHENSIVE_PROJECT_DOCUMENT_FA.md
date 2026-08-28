# سند جامع پروژه یادنگار (YadNegar)
## نسخه 2.1 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Product Direction:** Persian RTL tracked tasks with persistent FollowUp history  
**Reality Authority:** GitHub Repository State

---

## 1. قانون حقیقت
ترتیب اعتبار:
`GitHub Reality > Owner-approved Product Contract > Canonical Governance > Current Docs > Conversation Memory`

قبل از هر Write/Merge/گزارش وضعیت:
`Fresh Audit → exact SHA → current gates → fresh scope → live mergeability`

Green تاریخی برای Head جدید معتبر نیست.

---

## 2. وضعیت Verify‌شده فعلی
Current verified product main:
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

مدل اصلی محصول:
- یک tracked-task/root ثابت
- هر FollowUp یک child persistent همان root
- FollowUp جدید root تازه نمی‌سازد
- ویرایش یک FollowUp تاریخچه siblingها را حفظ می‌کند
- Repository/JSON/Reminder foundation موجود reuse شده است
- Timeline تخت قبلی فقط legacy tooling است

Issue #121 و بدهی قدیمی #117 قبلاً Completed و بسته شده‌اند.

---

## 3. تجربه اصلی کاربر
### Home
- root tracked taskها نمایش داده می‌شوند.
- latest real FollowUp تاریخ/ساعت دقیق جلالی/فارسی و متن نسبی را تعیین می‌کند.
- تاریخ ساخت root هرگز به‌عنوان آخرین پیگیری نمایش داده نمی‌شود.
- حالت بدون پیگیری واضح است.
- کارت‌ها compact هستند.
- جستجو در داده‌های از قبل loadشده، title + description + FollowUp text را پوشش می‌دهد.

### Detail
- عنوان کار
- description/summary اختیاری
- ویرایش کار
- آخرین FollowUp واقعی
- elapsed time محاسباتی
- history newest-first
- interval محاسباتی بین FollowUpها
- دکمه واضح `+`
- PDF action

### FollowUp Capture / Edit
- `+` صفحه مستقل `ثبت پیگیری` را باز می‌کند.
- عنوان اختیاری؛ خالی => `پیگیری`.
- date/time پیش‌فرض از device clock می‌آید.
- قبل از save قابل تغییر است.
- date input جلالی و visible digits فارسی‌اند.
- parent relation و sibling history هنگام edit حفظ می‌شوند.

### Description
- create می‌تواند description چندخطی اختیاری ذخیره کند.
- blank => null.
- edit می‌تواند add/change/clear کند.
- detail و PDF در صورت وجود آن را نمایش می‌دهند.

---

## 4. Search Contract
Issue #144 یک mismatch واقعی UI/Product را اصلاح کرد.

قبلاً Hint خانه می‌گفت `جستجو در کارها و پیگیری‌ها...` اما فقط title root بررسی می‌شد.

اکنون Query روی همان Home memory بررسی می‌شود:
1. `subject.text`
2. `subject.description` در صورت وجود
3. متن همه FollowUpهای child همان subject

خواص:
- root فقط یک‌بار برمی‌گردد حتی اگر چند بخش match شوند
- empty query همه rootها را با ترتیب موجود برمی‌گرداند
- clear-search رفتار قبلی را حفظ می‌کند
- hierarchy تغییر نمی‌کند
- هنگام تایپ disk/repository query جدید وجود ندارد
- schema/model/store/scheduler/dependency جدید ایجاد نشده است

---

## 5. PDF / Share / Print
یک مسیر read-only export projection روی همان Repository وجود دارد.

Scopeها:
1. همه tracked taskها
2. tracked taskهای انتخاب‌شده
3. یک tracked task با کل FollowUp history

Document properties:
- PDF واقعی
- RTL Persian
- Persian digits
- Jalali date/time
- bundled Vazirmatn Regular/Bold
- deterministic root→children grouping
- optional root description

Share و Print همان document path را reuse می‌کنند. JSON Backup/Restore ویژگی جداگانه Data Safety است.

---

## 6. معماری و Data Safety
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

Persistence:
- JSON schema-versioned
- current schema **v5**
- backward-compatible reads **v1-v4**
- v4: optional `parentId`
- v5: optional root `description`
- no read-time rewrite
- tmp/bak crash recovery
- validated safe writes
- Backup/Restore
- unsupported newer schema fail-closed

Derived data مانند elapsed time و inter-FollowUp interval Persist نمی‌شود.

اصل Data Safety:
`Schema Version + Compatibility + Validation + Recovery + No Destructive Migration`

---

## 7. تاریخ، زبان و فونت
UI اصلی فارسی و RTL است.

- Gregorian `DateTime`/ISO در persistence
- Jalali conversion در Presentation/Input boundary
- visible digits فارسی
- Reminder از device/local timezone semantics استفاده می‌کند
- bundled default Persian font: Vazirmatn
- Licensed IRANSansX در صورت configuration از مسیر موجود load می‌شود و نبود آن blocker نیست

---

## 8. Reminder Foundation
Reminder روی همان Foundation مشترک Timeline باقی مانده است.

Recurrence:
- `none`
- `daily`
- `weekly`

رفتار:
- device-local timezone
- startup reconciliation
- fail-closed اگر timezone resolve نشود
- failure scheduling نباید durable persistence را از بین ببرد

---

## 9. موج‌های تحویل مهم
### Canonical Tracked-Task Contract — #121
- #122 / PR #124 — root + persistent FollowUp history
- #126 / PR #130 — Jalali/Persian date-time
- #129 / PR #133 — computed Persian duration
- #128 — dedicated FollowUp capture/edit + correct Home/detail semantics
- #125 / PR #138 + #139 — PDF + all/selected/single + share/print
- #140 / PR #141 + #142 — optional description schema v5 + UI + PDF
- PR #143 — canonical documentation closure

#121 Completed است. PR #120 مربوط به flat Timeline عمداً Superseded شد.

### Search Completion — #144 / PR #145
Final PR head:
`b876bade5c89d5215d7955c8b1ffc250bd8f627e`

Pre-merge exact-head:
- CI `33183658883`: success
- UI Evidence `33183658891`: success
- Android `33183658875`: success full chain
- fresh scope: exactly 2 files, behind=0
- expected-head merge: success

Merged current main:
`9b577cc655cb53c9cfb2ed396fa8a71ad4eb3262`

Post-main:
- CI `33185558030`: success
- Android `33185558017`: success full chain
  - Debug APK build/verify/upload
  - Release Candidate build/evidence
  - Emulator startup/storage recovery
  - Release Readiness
  - deterministic Release Draft
  - Approval/Rollback evidence

#144 Completed است.

---

## 10. Release Governance
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

وضعیت:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

عمداً انجام نشده:
- production keystore/secret
- production signing claim
- real release tag
- GitHub Release
- Play Store publish

این موارد Owner/Security decision مستقل می‌خواهند.

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
- deterministic release draft
- approval/rollback package

Evidence فقط برای SHA دقیق خودش معتبر است.

### Issue #19 — Platform Enforcement Gap
Ruleset `main-protection` فعال است:
- PR required
- deletion blocked
- non-fast-forward blocked

Required status checks هنوز Platform-level enforce نشده‌اند چون connected tooling Ruleset Write ندارد.

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
5. Docs فقط Evidence واقعی را ثبت می‌کنند.
6. stale/fake evidence ممنوع.
7. حذف Gate برای سرعت ممنوع.
8. merge با Head مبهم ممنوع.
9. Backlog مصنوعی ممنوع.

---

## 13. Documentation Sync فعلی
Branch:
`docs/tracked-subject-search-content`

این branch تا پایان Product post-main #145 بدون write باقی ماند و سپس بدون Force روی exact verified main `9b577cc...` قرار گرفت.

Scope مورد انتظار دقیقاً چهار سند canonical است:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

این موج #144/#145 را ثبت و drift قدیمی اسناد درباره #117/#121 را حذف می‌کند.

---

## 14. صف فعلی
Fresh Audit فعلی:
- open product PR: ندارد
- open product issue شناخته‌شده: ندارد
- تنها Issue باز شناخته‌شده: #19، Platform-limited

Feature جدید برای پرکردن Backlog ساخته نشود.

انتخاب Slice بعدی فقط با:
1. Fresh Audit واقعی UI/code
2. gap قابل مشاهده و کوچک
3. reuse foundation موجود
4. DoD روشن
5. branch از main تازه
6. focused tests + exact-head gates

---

## 15. Trigger ادامه
عبارت:
`ادامه یادنگار`

اجرای استاندارد:
`Fresh Audit → Real Gap → Reuse → Small Slice → Exact Gates → Merge Lock → Post-Main → Docs`

گزارش مالک:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
