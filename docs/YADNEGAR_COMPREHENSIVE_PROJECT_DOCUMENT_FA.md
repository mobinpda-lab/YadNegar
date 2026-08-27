# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.3 — مرجع جامع محصول، مهندسی، اجرا و تداوم

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
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Main اکنون یک Flutter product واقعی با Foundation واحد و Flow زیر است:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema فعلی: v3  
Backward compatibility: v1/v2 reads  
UI: Persian RTL

Foundation موازی برای Timeline/Storage/Reminder/AppShell وجود ندارد.

---

## 3. مأموریت محصول
یادنگار اپلیکیشنی فارسی، سریع و کم‌اصطکاک برای ثبت و مرور اطلاعات روزمره است.

چرخه تجربه:
`Capture quickly → Organize minimally → Review in Timeline → Find/Edit later`

انواع فعلی Timeline:
- یادداشت
- رویداد
- تماس
- ایده
- فعالیت

اصول محصول:
- Capture-first
- Timeline-first
- RTL-native
- Progressive complexity
- Reuse before rebuild
- Data recoverability

---

## 4. معماری محصول
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

قواعد:
- Domain از Flutter UI/Storage مستقل بماند.
- Storage/Repository موازی بدون ADR ممنوع است.
- Shared core کوچک بماند.
- قابلیت جدید ابتدا نقاط Reuse موجود را Audit کند.
- پوشه/Service/Model بدون مصرف واقعی ساخته نشود.

---

## 5. Timeline و Persistence
یک `TimelineItem` مشترک برای انواع محتوای Timeline استفاده می‌شود.

Persistence فعلی:
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

## 6. Reminder Foundation
Reminder روی Foundation موجود Timeline سوار است؛ DB/Repository/Scheduler دوم وجود ندارد.

Recurrence contract:
- `none`
- `daily`
- `weekly`

رفتار:
- none => one-shot
- daily => ساعت محلی دستگاه
- weekly => روز هفته + ساعت محلی دستگاه
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

## 7. Reminder Product Waves
### Recurring Reminder — #93
- PR #96 / Issue #94: recurrence contract + schema v3 + v1/v2 compatibility
- PR #97 / Issue #95: device-local daily/weekly scheduling + Persian UX
- #98 documentation sync
- parent #93 completed

### Timeline Reminder Status — #99 / PR #100
Product merged to:
`8de412fa8aaefa7ecb23c9f7fbbb2f423070c318`

Final docs PR #101 merged to:
`fb2a02624421ba135de87357817d13922fed7abf`

Issue #99 is completed and closed.

### Reminder Presence Filter — #102 / PR #103
Final product head:
`256c2f05a5ce0d4bfaba6c9a711e7470d78f932a`

Merged main:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Scope واقعی فقط:
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_reminder_filter_test.dart`

رفتار:
- `همه موارد`
- `دارای یادآور`
- `بدون یادآور`
- reminder presence روی خروجی Search/Type/Date موجود اعمال می‌شود
- Clear موجود، فیلتر Reminder را هم Reset می‌کند
- Export موارد visible فعلی را استفاده می‌کند

Pre-merge evidence:
- Fast CI `33092820178`: success
- Android `33092820203`: success across Build/Candidate, Emulator Smoke/Recovery, Readiness, deterministic Release Draft, Approval/Rollback evidence

Post-main evidence روی SHA دقیق فعلی:
- Fast CI `33093725156`: success
- Android `33093725042`: success across the same full chain

---

## 8. Release Governance
زنجیره موجود و Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

هیچ‌یک از این موارد به‌صورت واقعی ایجاد نشده‌اند:
- production keystore/secret
- production signing
- release tag
- GitHub Release
- Play Store publish

این‌ها Owner/Security decision جداگانه هستند.

---

## 9. CI و Automation
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

اصل:
Evidence فقط برای SHA دقیق خودش معتبر است.

### Issue #19 — Platform Enforcement Gap
Ruleset `main-protection` زنده است:
- PR required
- deletion blocked
- non-fast-forward blocked

اما required status checks هنوز Platform-level enforce نشده‌اند و Connected tooling Ruleset Write ندارد.

تا زمان enforcement واقعی:
`exact current head + exact-head relevant gates + live mergeability + exact expected_head_sha + post-main proof`

---

## 10. مدل Maximum Parallel
YadNegar یک صف خطی نیست.

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

## 11. Merge Contract
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

---

## 12. وضعیت مستندات فعال #102
Branch:
`docs/timeline-reminder-filter-live`

این Branch چهار سند live/canonical را با outcome واقعی PR #103 و post-main Green همگام می‌کند.

پس از ادغام و Verify:
- Issue #102 بسته می‌شود.
- #104 به Lane ادغام محصول منتقل می‌شود.

---

## 13. Slice بعدی — #104
Issue #104:
`product: differentiate Timeline item types with icons`

Branch:
`product/timeline-type-icons`

هدف: پنج نوع فعلی Timeline با Material iconهای موجود سریع‌تر قابل اسکن شوند.

Scope مجاز:
- presentation-only
- استفاده از `TimelineItem.type`
- focused widget tests

ممنوع:
- schema/model contract change
- repository/storage change
- scheduler/platform change
- navigation/foundation change
- dependency یا asset pipeline جدید

آماده‌سازی موازی مجاز است؛ Integration فقط پس از تکمیل Docs #102، Fresh compare مستقل و exact-head gates.

---

## 14. خط قرمزهای پایدار
- duplicate Timeline/Reminder/Storage/Workflow foundation
- destructive migration بدون قرارداد
- stale/fake evidence
- direct risky main edits
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون Owner/Security decision
- merge با Head مبهم

---

## 15. Trigger ادامه
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
