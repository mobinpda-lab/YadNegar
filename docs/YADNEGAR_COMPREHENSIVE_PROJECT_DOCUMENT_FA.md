# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.5 — مرجع جامع محصول، مهندسی، اجرا و تداوم

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
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Main یک Flutter product واقعی با Foundation واحد و Flow زیر است:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete/Undo → Export → Backup/Restore → Reminder`

Storage schema فعلی: v3  
Backward compatibility: v1/v2 reads  
UI: Persian RTL

Foundation موازی برای Timeline/Storage/Reminder/AppShell وجود ندارد.

Timeline اکنون:
- Search/Type/Date composition دارد
- Reminder presence filter دارد
- Reminder status را روی کارت نشان می‌دهد
- پنج نوع canonical آیتم را با Material icon متمایز نشان می‌دهد
- همان Persian label + icon را از یک presentation mapping مشترک در کارت، فیلتر نوع، Quick Capture و Edit reuse می‌کند

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
- Presentation metadata تکراری در صورت امکان به یک منبع کوچک مشترک منتقل شود، بدون انتقال UI concern به Domain.

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

## 7. Product Waves
### Recurring Reminder — #93
- PR #96 / Issue #94: recurrence contract + schema v3 + v1/v2 compatibility
- PR #97 / Issue #95: device-local daily/weekly scheduling + Persian UX
- #98 documentation sync
- parent #93 completed

### Timeline Reminder Status — #99 / PR #100
- وضعیت Reminder مستقیماً روی کارت Timeline نمایش داده می‌شود.
- final docs PR #101 integrated
- Issue #99 completed

### Reminder Presence Filter — #102 / PR #103
Product merged to:
`3428c1798a43fd39fadd5f47673d1bd0366583ca`

Final docs PR #105 merged to:
`4d6dc18021b5d327b3a55972288df2b2a4d1c197`

Final proof:
- product Fast CI `33092820178`: success
- product Android `33092820203`: success full chain
- product post-main Fast CI `33093725156`: success
- product post-main Android `33093725042`: success full chain
- docs exact-head Fast CI `33095665307`: success
- docs post-main Fast CI `33095853727`: success

Issue #102 completed.

### Timeline Type Card Icons — #104 / PR #106 + Docs #107
Final product head:
`042491caadb405a31473b51986c263a6f9ba5d5c`

Product merged to:
`9728306e7a5baa5fb8258d6cb3350cc4e0305c5c`

Final docs PR #107 merged to:
`09d3bf13a8f4a7525b7619247095f4974774de67`

Mapping introduced on Timeline cards:
- note => `Icons.note_outlined`
- event => `Icons.event_outlined`
- call => `Icons.call_outlined`
- idea => `Icons.lightbulb_outline`
- activity => `Icons.check_circle_outline`

Product proof:
- Fast CI `33095681567`: success
- Android `33095681514`: success full chain
- post-main Fast CI `33096491732`: success
- post-main Android `33096491859`: success full chain

Docs proof:
- docs exact-head Fast CI `33097974085`: success
- docs post-main Fast CI `33098163806`: success

Issue #104 completed.

### Shared Timeline Type Presentation — #108 / PR #109
Final product head:
`e6195dc11eebbed7db9b83fcefc7bf52c7bd9268`

Merged main:
`885b988d996e7daf8e79e82ebe25b2d55e14f95a`

Fresh scope فقط چهار فایل Presentation/Test بود:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_item_type_presentation.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_type_selector_icon_test.dart`

Outcome:
- یک presentation mapping مشترک برای Persian label + Material icon
- Timeline card از همان mapping استفاده می‌کند
- Type filter از همان mapping استفاده می‌کند
- Quick Capture selector از همان mapping استفاده می‌کند
- Edit selector از همان mapping استفاده می‌کند
- mappingهای private/duplicate قبلی حذف شدند
- Domain/schema/repository/storage/scheduler/navigation/dependencies دست‌نخورده ماندند

Pre-merge exact-head proof:
- Fast CI `33099191968`: success
- Android `33099192004`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main proof on exact `885b988d...`:
- Fast CI `33103519511`: success
- Android `33103519546`: success full chain
  - Build/Candidate: success
  - emulator Smoke/Recovery: success
  - Release Readiness: success
  - deterministic Release Draft: success
  - Approval/Rollback evidence: success

Final documentation branch:
`docs/timeline-type-selector-icons-live`

Issue #108 closes only after docs exact-head CI, exact-head merge, and docs post-main Fast CI are verified.

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

Historical Green برای Head جدید معتبر نیست.

---

## 12. وضعیت مستندات فعال #108
Branch:
`docs/timeline-type-selector-icons-live`

Branch قبل از Product Merge آماده شد ولی هیچ Write روی آن انجام نشد. پس از ادغام PR #109، بدون Force از main قبلی به exact main `885b988d...` Fast-forward شد و سپس چهار سند live/canonical با outcome واقعی و post-main Green به‌روزرسانی شدند.

پس از ادغام و Verify مستندات:
- Issue #108 completed/closed
- Product queue از Fresh GitHub Reality دوباره ساخته می‌شود
- Issue #19 تا Ruleset Write واقعی باز می‌ماند

---

## 13. انتخاب Slice بعدی
هیچ Feature جدید صرفاً برای پرکردن Backlog ساخته نمی‌شود.

روش:
1. Fresh Audit محصول و open issues
2. پیدا کردن یک نیاز کوچک با reuse بالا
3. اثبات اینکه schema/storage/scheduler/foundation جدید لازم نیست
4. Issue با Definition of Done روشن
5. Branch از main تازه
6. focused tests + exact-head gates

در Audit فعلی هیچ TODO/FIXME آشکاری پیدا نشده و پس از #108 هیچ Issue محصولی از پیش‌ساخته‌ای در صف نیست؛ بنابراین Candidate بعدی فقط بعد از Audit واقعی UX/code پذیرفته می‌شود.

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
