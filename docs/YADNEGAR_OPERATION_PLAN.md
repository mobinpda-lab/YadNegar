# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.5 — Delete Final Carrier + Automation Incident

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در چند ساعت به‌جای چند روز.

چرخه:
`Fresh Audit → Reuse → Small PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند.

## 2. main فعلی
`71d1d993e362be898be955963653eff832a7da0a`

Main شامل Timeline واحد، JSON persistence واقعی/crash-recoverable، Quick Capture/Load/Edit، پنج Type، Search/Type/Date، occurredAt capture/edit، card time context، Persian RTL، Fast CI و Android APK build/verify/upload است.

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — PR #56 / Issue #55
Exact head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`
- CI `33017606387`: success
- Android `33017606312`: success
- merged safely
- post-main CI `33017911498`: success
- post-main Android `33017911496`: success

## 4. Product Slice فعال — PR #61 / Issue #57
`feat(timeline): delete items with confirmation`

Branch: `feature/delete-timeline-item-final`  
Current exact head: `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`

Scope:
- `deleteById` در Repository موجود
- reuse مسیر `_readAll → _writeAll` امن
- `DeleteTimelineItem` use case کوچک
- production wiring روی shared repository
- confirmation فارسی در Edit dialog موجود
- reload با حفظ Search/Type/Date
- Application + Widget + real-file tests

No schema bump / parallel storage / soft-delete / tombstone.

## 5. Validation History
- PR #58 CI نقص دو test fake را پیدا کرد؛ اصلاح شد.
- Head میانی Fast CI + Android Green شد.
- تست نهایی filter-state Head را تغییر داد، بنابراین Green قبلی historical شد.
- PR #60 برای validation تازه ساخته شد ولی PR mergeability برای مدت غیرعادی unknown ماند و exact-head workflow register نشد.
- Final tree سپس به یک single clean commit مستقیم روی current main تبدیل شد و PR #61 باز شد.
- یک Contents API commit عادی نیز روی #61 اضافه شد تا synchronize استاندارد ایجاد شود.

قانون: historical Green هرگز برای Head جدید استفاده نشود.

## 6. Lane A — Core/Data
Delete persistence آماده است:
- حذف موجود با write path crash-safe
- missing delete بدون write/staging
- deleted id بعد از reload غایب
- staging cleanup test-covered

## 7. Lane B — Product/UX
Delete UX آماده است:
- داخل Edit موجود
- confirmation اجباری
- success/cancel coverage
- حفظ Search/Type/Date state

Next queued: Issue #59 — Undo after delete, با reuse `upsert(...)` و بدون soft-delete.
Branch #59 فقط بعد از settle شدن delete ساخته شود.

## 8. Lane C — CI/Automation/Docs
- PR #50 Draft و هم‌زمان refresh می‌شود
- Issue #62: delayed PR merge-ref/workflow registration
- Issue #19: Ruleset required-status gap

Workflow definitions روی main:
- Fast CI: PR to main + main push
- Android: PR to main برای lib/android/assets/pubspec/workflow paths

Actions globally فعال است؛ مشکل #62 intermittent/PR-specific است.

## 9. Merge Contract
1. exact current head
2. Fast CI Green همان head
3. Android Green همان head
4. live mergeability true
5. `expected_head_sha` lock
6. post-main Fast + Android proof

هیچ Gate دور زده نمی‌شود.

## 10. Automation Recovery Rule
اگر exact-head PR run ثبت نشد:
- workflow definition را Fresh audit کن
- current PR raw mergeability/workflow registration را ثبت کن
- duplicate workflow نساز
- historical run را rerun و به Head جدید نسبت نده
- incident را در #62 ثبت کن
- independent docs/product-audit laneها را ادامه بده

## 11. Ruleset — Issue #19
`main-protection` required-status-check ندارد و Connector فعلی write action ندارد.
Operational lock تا رفع واقعی اجباری است.

## 12. Documentation Contract
- PR #43 stale/closed
- PR #50 replacement/Draft
- docs هم‌زمان با Product refresh می‌شوند
- قبل از Merge docs: final main structural sync + Fresh Audit + exact-head gates + safe merge

## 13. Queue
### Active
1. PR #61 / Issue #57 — delete with confirmation
2. PR #50 — parallel docs reconciliation
3. Issue #62 — PR workflow registration incident
4. Issue #19 — Ruleset enforcement gap

### Queued
- Issue #59 — Undo after deletion

## 14. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- workaround با workflow دوم بدون نیاز معماری
- ادعای Ruleset enforcement بدون proof

## 15. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
