# سند جامع پروژه یادنگار (YadNegar)
## نسخه 1.7 — مرجع جامع محصول، مهندسی، اجرا و تداوم

**Project:** YadNegar / یادنگار  
**Repository:** `mobinpda-lab/YadNegar`  
**Default Branch:** `main`  
**Technology:** Flutter / Dart  
**Product Direction:** Persian RTL, Timeline-oriented personal memory/activity capture  
**Reality Authority:** GitHub Repository State  
**Current Execution Plan:** `docs/YADNEGAR_OPERATION_PLAN.md`

---

## 1. قانون حقیقت و ادامه
ترتیب اعتبار:
`GitHub Reality > Approved Architecture Decisions > Canonical Governance > Comprehensive Reference > Current Handoff > Conversation Memory`

قبل از هر Write/Merge/گزارش وضعیت:
`Fresh Audit → exact SHA → current gates → live mergeability`

Green تاریخی برای Head جدید قابل انتقال نیست.

---

## 2. وضعیت Verify‌شده فعلی — 2026-08-28
Current product main:
`0fbdb1c9dc3473112530843620480a3e7283e7ae`

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
- Persian label + icon را از یک presentation mapping مشترک در کارت، فیلتر نوع، Quick Capture و Edit reuse می‌کند
- Type filter را با گزینه واقعی `همه انواع` مستقل پاک می‌کند
- Date Range فعال را با کنترل مستقل پاک می‌کند بدون Reset شدن query/type/reminder filter

---

## 3. معماری و Data Safety
Dependency direction:
`Presentation → Application → Domain`

`Infrastructure/Data → Domain Contracts`

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

قواعد:
- Domain از Flutter UI/Storage مستقل می‌ماند.
- Storage/Repository موازی بدون ADR ممنوع است.
- Presentation metadata تکراری در صورت نیاز در یک منبع کوچک مشترک نگه داشته می‌شود.
- قابلیت جدید ابتدا نقاط Reuse موجود را Audit می‌کند.

---

## 4. Reminder Foundation
Reminder روی Foundation موجود Timeline است و DB/Repository/Scheduler دوم ندارد.

Recurrence contract:
- `none`
- `daily`
- `weekly`

رفتار recurring با timezone محلی دستگاه، reconciliation و recovery موجود Verify شده است. Notification failure باعث rollback شدن Timeline persistence نمی‌شود.

Persian UX:
`بدون تکرار / روزانه / هفتگی`

---

## 5. Product Waves
- Recurring Reminder — parent #93 / PR #96 / PR #97 + docs #98: completed
- Timeline Reminder Status — #99 / PR #100 + docs #101: completed
- Reminder Presence Filter — #102 / PR #103 + docs #105: completed
- Timeline Type Card Icons — #104 / PR #106 + docs #107: completed
- Shared Timeline Type Presentation — #108 / PR #109 + docs #110: completed
- Independent Type Filter Clear — #111 / PR #112 + docs #113: completed; documented main `654cb4897b8321c633931506e6a12e90695da338`

### Independent Date-Range Clear — #114 / PR #115
Final product head:
`6cb084ae12c9dbab1e2fcd2dc812374522f1f895`

Merged main:
`0fbdb1c9dc3473112530843620480a3e7283e7ae`

Fresh scope exactly three Presentation/Test files:
- `lib/features/timeline/presentation/timeline_home.dart`
- `lib/features/timeline/presentation/timeline_screen.dart`
- `test/features/timeline/presentation/timeline_date_filter_clear_test.dart`

Outcome:
- dedicated clear action exists only when Date Range is active
- existing `_dateStart/_dateEndExclusive` state is reused
- existing reload/search/filter composition is reused
- date-only clear preserves text query
- date-only clear preserves type filter
- date-only clear preserves reminder-presence filter
- Global Clear All remains unchanged
- Domain/schema/repository/storage/scheduler/navigation/dependencies/workflows remain untouched

Pre-merge exact-head proof:
- Fast CI `33114258026`: success
- Android `33114258075`: success full chain
- live mergeability=true
- exact expected-head merge: success

Post-main proof on exact `0fbdb1c9...`:
- Fast CI `33115076694`: success
- Android `33115076613`: success full chain
  - Build/Candidate: success
  - emulator Smoke/Recovery: success
  - Release Readiness: success
  - deterministic Release Draft: success
  - Approval/Rollback evidence: success

---

## 6. Release Governance
زنجیره Verify‌شده:
`Fast CI → Android Build → Candidate/Manifest → Smoke/Recovery → Readiness → Version/Release Notes Draft → Approval/Rollback Evidence`

وضعیت:
`candidate verified / release governance verified / production signing blocked / not Play-Store-ready`

موارد زیر عمداً ساخته نشده‌اند:
- production keystore/secret
- production signing
- real release tag
- GitHub Release
- Play Store publish

این‌ها Owner/Security decision جداگانه هستند.

---

## 7. CI و Automation
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

اما required status checks هنوز Platform-level enforce نشده‌اند و Connected tooling Ruleset Write ندارد.

تا enforcement واقعی:
`exact current head + exact-head relevant gates + live mergeability + exact expected_head_sha + post-main proof`

---

## 8. مدل Maximum Parallel
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
5. Docs همزمان ولی فقط با Evidence واقعی.
6. stale/fake evidence ممنوع.
7. حذف Gate برای سرعت ممنوع.

چرخه:
`Audit → Reuse → Decompose → Parallelize → Execute → Fast Feedback → Full Gate → Evidence → Integrate → Document`

---

## 9. Merge Contract
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

## 10. مستندات فعال #114
Branch:
`docs/timeline-date-filter-clear-live`

Branch قبل از Product Merge از `654cb489...` آماده شد و هیچ Write نداشت. بعد از ادغام و Green کامل post-main، بدون Force به exact main `0fbdb1c9...` Fast-forward شد و سپس چهار سند canonical با Evidence واقعی به‌روزرسانی شدند.

Issue #114 فقط بعد از docs exact-head CI، merge قفل‌شده و docs post-main Fast CI بسته می‌شود.

---

## 11. انتخاب Slice بعدی
Feature جدید صرفاً برای پرکردن Backlog ساخته نمی‌شود.

روش:
1. Fresh Audit محصول و open issues
2. پیدا کردن نیاز کوچک واقعی با reuse بالا
3. اثبات اینکه schema/storage/scheduler/foundation جدید لازم نیست
4. Issue با Definition of Done روشن
5. Branch از main تازه
6. focused tests + exact-head gates

پس از #114، Queue باید دوباره از GitHub Reality ساخته شود. #19 تا زمانی که Ruleset Write در دسترس نباشد Platform-limited باقی می‌ماند.

---

## 12. خط قرمزهای پایدار
- duplicate Timeline/Reminder/Storage/Workflow foundation
- destructive migration بدون قرارداد
- stale/fake evidence
- direct risky main edits
- secret/keystore داخل Repository
- production-ready claim بدون signing واقعی
- Tag/Release/Publish بدون Owner/Security decision
- merge با Head مبهم

---

## 13. Trigger ادامه
عبارت:
`ادامه یادنگار`

اجرای استاندارد:
1. Fresh Audit GitHub
2. وضعیت main/PR/Issue/CI
3. ادامه Laneهای مستقل با Maximum Parallel
4. ثبت Evidence در GitHub
5. گزارش کوتاه مالک:
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
