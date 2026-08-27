# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.6 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Product Direction:** Persian RTL, Timeline-oriented personal memory/activity capture  
**Reality Authority:** GitHub Repository State  
**Current Execution Plan:** `docs/YADNEGAR_OPERATION_PLAN.md`

---

## 1. قانون حقیقت و ادامه
این سند Snapshot/Reference است و جای GitHub Reality را نمی‌گیرد.

ترتیب اعتبار:
`GitHub Reality > Approved Architecture Decisions > Canonical Governance > Comprehensive Reference > Current Handoff > Conversation Memory`

قبل از هر Write/Merge/گزارش وضعیت:
`Fresh Audit → exact SHA → current gates → live mergeability`

Green تاریخی برای Head جدید قابل انتقال نیست.

---

## 2. وضعیت Verify‌شده فعلی — 2026-08-27
Current product main:
`b8bd35976fe3a51834c56799525451eec145a2fd`

Flow اصلی محصول:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema: v3  
Backward compatibility: v1/v2 reads  
UI: Persian RTL

Foundation موازی برای Timeline/Storage/Reminder/AppShell وجود ندارد.

Timeline اکنون:
- Search/Type/Date composition دارد
- Reminder presence filter دارد
- Reminder status را روی کارت نشان می‌دهد
- پنج نوع canonical را با Material icon متمایز نشان می‌دهد
- Persian label + icon را از یک presentation mapping مشترک در کارت، فیلتر نوع، Quick Capture و Edit reuse می‌کند
- فیلتر نوع را می‌توان با گزینه واقعی `همه انواع` مستقل از query/date/reminder پاک کرد

---

## 3. مأموریت و اصول محصول
یادنگار اپلیکیشنی فارسی، سریع و کم‌اصطکاک برای ثبت و مرور اطلاعات روزمره است.

چرخه تجربه:
`Capture quickly → Organize minimally → Review in Timeline → Find/Edit later`

انواع Timeline:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت

اصول:
- Capture-first
- Timeline-first
- RTL-native
- Progressive complexity
- Reuse before rebuild
- Data recoverability

---

## 4. معماری و Data Safety
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

قواعد:
- Domain از Flutter UI/Storage مستقل بماند.
- Storage/Repository موازی بدون ADR ممنوع است.
- Shared core کوچک بماند.
- قابلیت جدید ابتدا نقاط Reuse موجود را Audit کند.
- Service/Model/Foundation بدون مصرف واقعی ساخته نشود.
- Presentation metadata تکراری در صورت امکان به منبع کوچک مشترک منتقل شود، بدون انتقال UI concern به Domain.

Persistence:
- JSON schema-versioned
- schema v3
- backward-compatible v1/v2 reads
- no read-time rewrite
- tmp/bak recovery path
- safe-write upgrade
- Backup/Restore موجود و reuse‌شده

اصل Data Safety:
`Schema Version + Compatibility + Validation + Recovery`

---

## 5. Reminder Foundation
Reminder روی همان Timeline foundation سوار است؛ DB/Repository/Scheduler دوم وجود ندارد.

Recurrence contract:
- `none`
- `daily`
- `weekly`

رفتار کلیدی:
- one-shot / daily / weekly device-local scheduling
- past recurring anchor => occurrence بعدی آینده
- device IANA timezone قبل از startup/Restore reconciliation
- timezone resolution failure => recurrence fail-closed
- notification failure => persisted Timeline data rollback نمی‌شود
- clear reminder => recurrence none
- Delete/Undo => cancel/reschedule امن
- exact-alarm permission اضافه نشده است

Persian UX:
`بدون تکرار / روزانه / هفتگی`

---

## 6. Product Waves
### Recurring Reminder — #93
- PR #96 / Issue #94: recurrence contract + schema v3 + v1/v2 compatibility
- PR #97 / Issue #95: device-local daily/weekly scheduling + Persian UX
- docs #98
- parent #93 completed

### Timeline Reminder Status — #99 / PR #100 + Docs #101
Reminder status روی کارت Timeline؛ completed.

### Reminder Presence Filter — #102 / PR #103 + Docs #105
فیلتر `همه موارد / دارای یادآور / بدون یادآور` روی خروجی Search/Type/Date موجود؛ completed.

### Timeline Type Card Icons — #104 / PR #106 + Docs #107
پنج type canonical با icon متمایز؛ completed.

### Shared Timeline Type Presentation — #108 / PR #109 + Docs #110
Final product head:
`e6195dc11eebbed7db9b83fcefc7bf52c7bd9268`

Product merged to:
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Final docs main:
`2c79d2e4f3d64571032560186229117df33dcafa`

Outcome:
- یک presentation mapping مشترک برای Persian label + Material icon
- reuse در Timeline card، type filter، Quick Capture و Edit
- mappingهای private/duplicate حذف شدند
- Domain/schema/repository/storage/scheduler/navigation/dependencies دست‌نخورده ماندند

Proof:
- pre-merge Fast CI `33099191968`: success
- pre-merge Android `33099192004`: success full chain
- product post-main Fast CI `33103519511`: success
- product post-main Android `33103519546`: success full chain
- docs exact-head Fast CI `33104664609`: success
- docs post-main Fast CI `33104816048`: success

Issue #108 completed.

### Independent Timeline Type Filter Clear — #111 / PR #112
Final product head:
`ee467aab71e682615d045acc5e363061e24a6ac5`

Product merged to:
`b8bd35976fe3a51834c56799525451eec145a2fd`

Fresh scope فقط دو فایل بود:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_filter_all_option_test.dart`

Outcome:
- `همه انواع` از hint صرف به گزینه واقعی nullable در همان Dropdown تبدیل شد.
- callback موجود `TimelineItemType?` با `null` reuse شد.
- فقط type constraint حذف می‌شود.
- query فعال حفظ می‌شود.
- date-range/reminder state با این action پاک نمی‌شود.
- Global Clear All بدون تغییر باقی ماند.
- State/Callback/Foundation دوم ساخته نشد.

Pre-merge exact-head proof:
- Fast CI `33105499667`: success
- Android `33105499651`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main proof on `b8bd3597...`:
- Fast CI `33109216102`: success
- Android `33109216100`: success full chain
  - Build/Candidate: success
  - emulator Smoke/Recovery: success
  - Release Readiness: success
  - deterministic Release Draft: success
  - Approval/Rollback evidence: success

Final docs branch:
`docs/timeline-type-filter-all-option-live`

Issue #111 فقط پس از docs exact-head CI، exact-head merge و docs post-main Fast CI بسته می‌شود.

---

## 7. Release Governance
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

موارد زیر عمداً ایجاد نشده‌اند:
- production keystore/secret
- production signing
- release tag
- GitHub Release
- Play Store publish

این‌ها Owner/Security decision جداگانه هستند.

---

## 8. CI و Automation
Fast CI:
- dependencies
- analyze
- tests

Android chain:
- debug APK
- candidate APK/evidence
- emulator startup + storage recovery
- readiness
- deterministic release draft
- approval/rollback package

Evidence فقط برای SHA دقیق خودش معتبر است.

### Issue #19 — Platform Enforcement Gap
Ruleset `main-protection` زنده است:
- PR required
- deletion blocked
- non-fast-forward blocked

Required status checks هنوز Platform-level enforce نشده‌اند و Connected tooling Ruleset Write ندارد.

تا زمان enforcement واقعی:
`exact current head + exact-head relevant gates + live mergeability + exact expected_head_sha + post-main proof`

---

## 9. مدل Maximum Parallel
Laneهای مستقل:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

قوانین:
1. Block یک Lane، Lane مستقل را متوقف نمی‌کند.
2. Stacked preparation فقط با Fresh compare و Scope مستقل.
3. Reuse قبل از Rebuild.
4. PR کوچک، reversible و قابل Review.
5. Docs همزمان با Implementation.
6. stale/fake evidence ممنوع.
7. حذف Gate برای سرعت ممنوع.

چرخه:
`Audit → Reuse → Decompose → Parallelize → Execute → Fast Feedback → Full Gate → Evidence → Integrate → Document`

---

## 10. Merge Contract
### Product / Release
1. exact current head
2. exact-head Fast CI Green
3. exact-head Android/relevant gates Green
4. Fresh compare برای Scope/Dependency
5. live mergeability=true
6. exact `expected_head_sha`
7. post-main proof
8. docs synchronization

### Docs-only
1. exact docs head
2. Fast CI Green همان Head
3. live mergeability=true
4. exact `expected_head_sha`
5. post-main Fast CI

Historical Green برای Head جدید معتبر نیست.

---

## 11. وضعیت مستندات فعال #111
Branch:
`docs/timeline-type-filter-all-option-live`

Branch از documented main قبلی `2c79d2e4...` آماده شد، در طول Product Gate دست‌نخورده ماند، سپس بعد از Green کامل post-main بدون Force به exact product main `b8bd3597...` Fast-forward شد و چهار سند live/canonical با Evidence واقعی به‌روزرسانی شدند.

پس از ادغام و Verify مستندات:
- Issue #111 completed/closed
- Issue #19 تا Ruleset Write واقعی باز می‌ماند
- Product queue دوباره از Fresh GitHub Reality ساخته می‌شود

---

## 12. انتخاب Slice بعدی
Feature جدید صرفاً برای پرکردن Backlog ساخته نمی‌شود.

Candidate Audit‌شده فعلی: **پاک‌کردن مستقل Date Range**.

Evidence کد روی `b8bd3597...`:
- `_dateStart` و `_dateEndExclusive` State مستقل هستند.
- `_openDateRangeFilter()` بازه را انتخاب/تعویض می‌کند.
- UI فعلی دکمه Date Range را برای انتخاب بازه دارد، اما clear مستقل ندارد.
- `_clearSearch()` تاریخ را همراه query/type پاک می‌کند.

پس از پایان #111 باید Fresh Audit تکرار شود. اگر Scope همچنان کوچک و presentation/reuse-first بود، Issue بعدی باید Definition of Done روشن داشته باشد: حذف فقط تاریخ و حفظ query/type/reminder، بدون Foundation/Data change.

---

## 13. خط قرمزهای پایدار
- duplicate Timeline/Reminder/Storage/Workflow foundation
- destructive migration بدون قرارداد
- stale/fake evidence
- direct risky main edits
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون Owner/Security decision
- merge با Head مبهم

---

## 14. Trigger ادامه
عبارت:
`ادامه یادنگار`

اجرای استاندارد:
1. Fresh Audit GitHub
2. وضعیت main/PR/Issue/CI
3. ادامه Laneهای مستقل با Maximum Parallel
4. ثبت Evidence در GitHub
5. گزارش کوتاه مالک:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

تاریخچه جزئی Waveهای قدیمی در Git history، PRها و Issueهای بسته حفظ شده است؛ این سند وضعیت و قواعد قابل‌عمل فعلی را نگه می‌دارد.
