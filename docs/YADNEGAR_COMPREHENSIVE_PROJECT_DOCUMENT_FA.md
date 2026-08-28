# سند جامع پروژه یادنگار (YadNegar)
## نسخه 3.0 — مرجع محصول، داده، UX، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Reality Authority:** GitHub Repository State

## 1. قانون حقیقت
`GitHub Reality > Owner-approved Product Contract > Canonical Governance > Current Docs > Conversation Memory`

قبل از هر Write/Merge/گزارش:
`Fresh Audit → exact SHA → exact-head gates → fresh scope → live mergeability`

Green تاریخی برای Head جدید معتبر نیست.

## 2. وضعیت محصول
Current merged product main:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

مدل اصلی:
- یک tracked-task/root ثابت
- هر FollowUp یک child persistent همان root
- FollowUp جدید root تازه نمی‌سازد
- ویرایش FollowUp، parent و sibling history را حفظ می‌کند
- Project عضویت اختیاری root است و FollowUp Project مستقل ندارد
- یک Repository/JSON foundation منبع حقیقت است

## 3. تجربه فعلی کاربر
### Home
- فقط rootها نمایش داده می‌شوند.
- داده rootها و FollowUpها با یک repository snapshot در هر reload بارگذاری می‌شود.
- ترتیب کارت بر اساس latest real FollowUp است؛ اگر FollowUp وجود نداشته باشد زمان root استفاده می‌شود.
- Search روی title + description + FollowUp text کار می‌کند.
- Project context و رنگ Project دیده می‌شود.
- بالای Home عبارت «بسم الله الرحمن الرحیم» نمایش داده می‌شود.
- Swipe چپ یا راست یک task، فرم FollowUp همان root را باز می‌کند.
- Swipe همیشه `confirmDismiss=false` دارد و task را حذف یا Dismiss نمی‌کند.

### FollowUp
- فرم مستقل ثبت/ویرایش پیگیری.
- عنوان اختیاری؛ خالی => `پیگیری`.
- تاریخ/زمان قابل انتخاب است.
- Date Picker یک تقویم ماهانه جدولی جلالی است.
- Time Picker حالت dial و ۲۴ساعته دارد.
- ارقام نمایشی فارسی و UI RTL است.

### Detail
- title و description
- latest real FollowUp
- elapsed duration محاسباتی
- history newest-first
- فاصله محاسباتی بین FollowUpها
- افزودن و ویرایش FollowUp
- PDF action

### Project
- Projectها در همان JSON storage نگهداری می‌شوند.
- هر root می‌تواند صفر یا یک Project داشته باشد.
- Project با Tag یکی نیست.
- FollowUp Project مستقل ندارد و context را از parent می‌گیرد.

## 4. Search Contract
Home search روی memory از قبل loadشده اجرا می‌شود:
1. `subject.text`
2. `subject.description`
3. child FollowUp text

هیچ repository/disk query هنگام تایپ اضافه نمی‌شود و root تکراری برنمی‌گردد.

## 5. PDF / Reporting / Portability
یک read-only export projection روی Repository موجود استفاده می‌شود.

Scopeهای پایه:
- همه tracked taskها
- selected taskها
- یک task با history کامل

Date report:
- یک روز جلالی
- بازه جلالی inclusive
- root فقط یک‌بار
- فقط FollowUpهای منطبق
- root creation date به‌تنهایی event گزارش محسوب نمی‌شود

PDF properties:
- RTL Persian
- Persian digits
- Jalali date/time
- bundled Vazirmatn
- deterministic root → child grouping
- description در صورت وجود

Print و Share همان document/report foundation را reuse می‌کنند.

## 6. معماری و Data Safety
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

Persistence:
- JSON schema-versioned
- current schema **v6**
- backward-compatible reads **v1-v5**
- v4: optional `parentId`
- v5: optional root `description`
- v6: Projects + optional root `projectId`
- safe-write upgrade
- no read-time rewrite
- tmp/bak crash recovery
- validated Backup/Restore
- unsupported future schema fail-closed

یک Store/DB دوم برای Task/FollowUp/Project وجود ندارد.

Derived data مانند elapsed duration، inter-FollowUp interval و Home status Persist نمی‌شوند.

## 7. تاریخ، زبان و فونت
- UI فارسی و RTL-first
- persistence با Gregorian/ISO DateTime
- Jalali conversion در Presentation/Input boundary
- Persian visible digits
- Date Picker جلالی مشترک
- Time Picker dial 24h مشترک
- default bundled font: Vazirmatn
- Licensed IRANSansX در صورت configuration از مسیر موجود load می‌شود و blocker نیست

## 8. Reminder Foundation
Reminder با Next Action یکی نیست.

Reminder فعلی:
- none
- daily
- weekly
- device-local timezone
- startup reconciliation
- fail-closed روی timezone failure
- persistence مستقل از scheduling success باقی می‌ماند

## 9. Delivery History مهم
### Canonical tracked-task foundation — #121
Completed:
- root + persistent FollowUp
- Jalali/Persian date-time
- computed Persian duration
- FollowUp capture/edit
- PDF/share/print
- optional description

### Search — #144
Completed؛ title + description + FollowUp text با reuse Home memory.

### Date Reports — #153
Completed؛ one-day/range reports با reuse PDF/Print/Share.

### Projects — schema v6
Completed؛ Project collection و root membership در همان JSON foundation.

### Home Performance — #149 / PR #157
Completed؛ N+1 repository reads حذف و Home از یک snapshot ساخته می‌شود.

### Home/FollowUp UX — #151 / PR #159
Final PR head:
`0e27cfd8083ca5428b1fb7a321982cc6d4b7f936`

Fresh final scope:
- `lib/features/timeline/presentation/tracked_subject_home.dart`
- `test/features/timeline/presentation/tracked_subject_home_swipe_follow_up_test.dart`
- `behind=0`

Exact-head evidence:
- CI #396 `33209126088`: success
- UI Evidence #39 `33209126046`: success
- Android #169 `33209126028`: full chain success

Merged with expected-head lock:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

Post-main:
- CI #397 `33209875036`: success
- Android #170 `33209875095`: **در حال اجرا** در لحظه آماده‌سازی این docs branch

تا Green کامل Android #170، #151 و docs sync نهایی نمی‌شوند.

## 10. Release Governance
Verified chain:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

Release status:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

عمداً بدون تصمیم صریح انجام نمی‌شود:
- production keystore/secret
- production signing claim
- real release tag
- GitHub Release
- Play Store publish

## 11. CI / Ruleset
Fast CI:
- dependency resolution
- analyze
- full tests

Android chain:
- debug APK
- release-candidate APK
- emulator startup/storage recovery
- readiness
- deterministic draft
- approval/rollback

Issue #19 Platform-limited باقی است: main ruleset PR را الزام می‌کند و deletion/non-fast-forward را می‌بندد، اما Ruleset Write برای required status contexts در connector وجود ندارد.

Operational merge safety:
`exact head + exact-head relevant gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## 12. Maximum Parallel
Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

قواعد:
- Block یک Lane، Lane مستقل را متوقف نمی‌کند.
- Reuse قبل از Rebuild.
- Slice کوچک و reversible.
- Stacked preparation بعد base move باید fresh compare شود.
- stale/fake evidence ممنوع.
- حذف Gate برای سرعت ممنوع.
- main مستقیم و risky edit ممنوع.

## 13. مسیر بعدی — Today Center / #160
هدف کاربر:
بداند امروز چه کاری دارد، چه چیزی عقب افتاده، چه چیزی آینده است و کدام کار اقدام بعدی ندارد.

### Domain contract
Root می‌تواند optional `nextActionAt` داشته باشد.

`nextActionAt` با `reminderAt` متفاوت است:
- Next Action = برنامه زمانی اقدام/پیگیری بعدی
- Reminder = زمان Notification

FollowUp مستقل `nextActionAt` ندارد.

### Bucket contract
بر اساس local calendar day:
- Today: داخل روز امروز
- Overdue: قبل از شروع امروز
- Upcoming: بعد از پایان امروز
- No Next Action: null

این bucketها derived هستند و Persist نمی‌شوند.

### Reuse plan
- TimelineItem
- QuickCapture
- EditTimelineItem
- JSON repository
- Jalali date picker
- 24h time picker
- Home one-snapshot projection

### Slice A — Data/Application
- schema v7 additive
- root-only `nextActionAt`
- v1-v6 reads
- safe-write upgrade to v7
- set/edit/clear
- bucket helper
- storage/mutation/boundary/backup tests

### Slice B — Product/UI
- Create/Edit set/change/clear Next Action
- Detail display
- compact Home Today/Overdue/Upcoming/No Next Action counts/filter
- Persian/Jalali presentation
- no additional repository read

No second DB/Store/Calendar/Search/Reminder foundation is allowed.

## 14. Documentation Lane
Branch:
`docs/current-state-after-151`

Final scope exactly four canonical docs. Android #170 status must be converted from running to exact Green evidence before docs PR merge.

## 15. Current Queue
- #151: awaiting final post-main Android #170 proof
- #160: next product work; design and decomposition ready
- #19: independent Platform-limited governance gap

## 16. Trigger
`ادامه یادنگار`

Standard execution:
`Fresh Audit → Real Gap → Reuse → Small Slice → Exact Gates → Merge Lock → Post-Main → Docs`

Owner report:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
