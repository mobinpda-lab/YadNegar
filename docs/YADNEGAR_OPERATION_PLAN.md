# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 6.0 — Projects + Reporting + Home UX Verified

**تاریخ مبنا:** 2026-08-29  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
چرخه استاندارد:
`Fresh Audit → Reuse → Decompose → Maximum Parallel → Focused Tests → exact-head CI/UI/Android → fresh scope → expected-head merge → post-main proof → docs sync → issue cleanup → next real slice`

Laneهای مستقل:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Green تاریخی برای Head جدید معتبر نیست.

## 2. main فعلی
Current merged product main:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

جهت canonical:
`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Share/Print`

## 3. قابلیت‌های فعلی
### Tracked Task / FollowUp
- یک root ثابت برای هر کار
- description اختیاری
- Project اختیاری روی root
- FollowUp child همان root و بدون Project مستقل
- create/edit/detail/history کامل
- Jalali/Persian date-time
- elapsed/inter-follow-up derived و non-persisted

### Home
- یک repository snapshot در هر reload؛ N+1 read حذف شده است
- Search روی title + description + FollowUp text
- Project context و رنگ‌ها
- «بسم الله الرحمن الرحیم» در بالای Home
- Swipe چپ/راست → FollowUp همان root
- `confirmDismiss=false`؛ Swipe عملیات مخرب ندارد

### Date/Time Input
- Jalali monthly grid
- Persian visible digits
- 24-hour dial time picker

### Reporting
- PDF همه / انتخاب‌شده / یک کار
- PDF/Print/Share با foundation مشترک
- گزارش یک روز یا بازه جلالی
- range inclusive
- root یک‌بار و فقط FollowUpهای منطبق
- تاریخ ساخت root به‌تنهایی گزارش آن روز محسوب نمی‌شود

### Backup / Reminder
- validated JSON Backup/Restore
- tmp/bak recovery
- reminder none/daily/weekly با local-time semantics

## 4. Data / Storage Safety
Current schema: **v6**  
Backward-compatible reads: **v1-v5**

Schema evolution مهم:
- v4: `parentId`
- v5: root `description`
- v6: Projects + root `projectId`

قواعد:
- یک Repository/Storage
- no duplicate Task/FollowUp/Project DB
- no destructive migration
- no read-time rewrite
- safe-write upgrade
- tmp/bak recovery
- validated Backup/Restore
- unsupported newer schema fail-closed

## 5. آخرین تحویل‌ها
### #153 — Date Reports
Completed؛ گزارش یک روز/بازه جلالی با reuse مسیر PDF/Print/Share.

### #149 / PR #157 — Home Performance
Completed؛ Home با یک repository snapshot بارگذاری می‌شود. Post-main CI/Android full chain Green.

### #151 / PR #159 — Home + FollowUp UX
Final PR head:
`0e27cfd8083ca5428b1fb7a321982cc6d4b7f936`

Exact-head Green:
- CI #396 `33209126088`
- UI Evidence #39 `33209126046`
- Android #169 `33209126028` full chain

Merged main:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

Post-main:
- CI #397 `33209875036`: success
- Android #170 `33209875095`: **در حال اجرا** هنگام آماده‌سازی این نسخه

#151 و این docs lane فقط بعد از Green کامل #170 نهایی می‌شوند.

## 6. Release Baseline
Automation:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

Release state:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

بدون تصمیم Owner/Security:
- production keystore/secret ممنوع
- real release tag ممنوع
- GitHub Release ممنوع
- Play Store publish ممنوع

## 7. Platform Gap — #19
Ruleset `main-protection`:
- PR required
- deletion blocked
- non-fast-forward blocked

Required status checks هنوز Platform-level enforce نشده‌اند چون Ruleset Write در tooling موجود نیست.

Operational merge safety:
`exact current head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

Docs-only:
`exact docs head + Fast CI + fresh docs-only scope + live mergeability + expected-head merge + post-main Fast CI`

## 8. Next Product Lane — #160 Today Center
هدف:
`Next Action → Today / Overdue / Upcoming / No Next Action`

قرارداد:
- root-only optional `nextActionAt`
- Next Action با Reminder متفاوت است
- وضعیت‌های Today/Overdue/Upcoming Persist نمی‌شوند
- local calendar-day boundaries:
  - Today = current day
  - Overdue = before start of current day
  - Upcoming = after end of current day
  - No Next Action = null

Reuse:
- `TimelineItem`
- `QuickCapture`
- `EditTimelineItem`
- JSON repository
- Jalali grid picker
- 24-hour dial picker
- Home single-snapshot projection

ممنوع:
- Reminder به‌جای Next Action
- Store/DB دوم
- Calendar engine دوم
- Search service دوم

### Slice A — Data/Application
- schema v7 additive
- root-only nextActionAt
- v1-v6 backward reads
- safe-write upgrade
- QuickCapture/Edit set/clear
- derived bucket helper
- storage/mutation/boundary/backup tests

### Slice B — Product/UI
- Create/Edit set/change/clear Next Action
- Detail state
- Home compact counts/filter for Today/Overdue/Upcoming/No Next Action
- Jalali/Persian display
- no extra repository read

Slice B فقط بعد از base stability با fresh compare ادغام می‌شود.

## 9. Documentation Lane
Branch:
`docs/current-state-after-151`

Final scope دقیقاً چهار سند:
- `docs/AI_CONTINUATION_STATE.md`
- `docs/AI_HANDOFF_CURRENT_FA.md`
- `docs/YADNEGAR_OPERATION_PLAN.md`
- `docs/YADNEGAR_COMPREHENSIVE_PROJECT_DOCUMENT_FA.md`

Android #170 قبل از Merge باید Green و در هر چهار سند به Evidence نهایی تبدیل شود.

## 10. Maximum Parallel Contract
- Product / Release / Docs / Automation تا حد استقلال موازی
- Reuse قبل از Rebuild
- کوچک‌ترین Slice برگشت‌پذیر
- تست focused زودهنگام
- Full gates فقط exact head
- stale/fake evidence ممنوع
- stacked branch بعد base move باید fresh compare شود
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

## 12. Queue
- #151: فقط post-main Android #170 باقی مانده
- #160: next product lane؛ design/decomposition آماده
- #19: Platform-limited و مستقل

## 13. اصل سرعت
`Maximum Parallel = Independent Lanes + Safe Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Immediate Documentation`

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
