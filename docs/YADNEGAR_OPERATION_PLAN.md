# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.8 — Wave 6 Export Active

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
`99f672d53045782d18847380fc335fe1da25c0c6`

Main شامل Timeline واحد، JSON persistence واقعی/crash-recoverable، Quick Capture/Load/Edit، پنج Type، Search/Type/Date، occurredAt capture/edit، اصلاح Type، حذف امن و Undo است.

PR #50 documentation reconciliation نیز روی همین main ادغام شده است.

No duplicate Model/Repository/Storage/AppShell.

## 3. Product Slice فعال — PR #65 / Issue #64
`feat(export): copy visible Timeline items to clipboard`

Branch: `feature/timeline-export-clipboard`  
Exact head: `114fca4cdfd2269d5d4ff906ce96afe0590a7162`  
Base: `main` at `99f672d...`  
Diff: فقط 4 فایل Export-related.

طراحی نهایی:
- `ExportTimelineText` formatter خالص در application layer
- ورودی: همان visible items در TimelineScreen
- Search/Type/Date با reuse state موجود حفظ می‌شوند
- query دوم روی Repository وجود ندارد
- Clipboard فقط در presentation edge
- no dependency / schema / storage / Repository contract change
- success / empty / error feedback فارسی
- unit + widget tests

## 4. Lane A — Core/Data
Foundation اصلی پایدار است و برای Export تغییر نمی‌کند:
- one Timeline model
- one Repository contract
- one crash-recoverable JSON storage

Export user-facing representation است و storage format جدید محسوب نمی‌شود.

## 5. Lane B — Product/UX
PR #65 یک action فارسی برای کپی موارد نمایش‌داده‌شده اضافه می‌کند.

رفتار:
- اگر Timeline فعلی خالی باشد Clipboard write انجام نمی‌شود
- خروجی ترتیب visible items را حفظ می‌کند
- type / text / effective Timeline time در خروجی است
- success/error Snackbar فارسی دارد

## 6. Lane C — CI/Automation/Docs
Exact-head gates PR #65:
- YadNegar CI `33026398124`: in progress
- YadNegar Android Build `33026398078`: in progress
- live mergeable=true؛ state تا settle شدن checks unstable است

Automation:
- Issue #62 recovered/closed
- هر دو workflow برای PR #65 طبیعی ثبت شده‌اند
- duplicate workflow/carrier لازم نیست
- Issue #19 required-status Ruleset gap باز است

Documentation:
- branch `docs/current-state-wave6-export` هم‌زمان وضعیت PR #65 را ثبت می‌کند
- پس از Merge Product، این branch روی main جدید Final Sync می‌شود و exact-head CI می‌گیرد

## 7. Merge Contract
1. exact current head
2. Fast CI Green همان head
3. Android Green همان head برای Product changes
4. live mergeability true
5. `expected_head_sha` lock
6. post-main Fast CI + Android proof

Historical Green معتبر نیست.

## 8. Wave 6 Governance
Wave 6: `Reminder / Backup / Export`

Export به‌عنوان کوچک‌ترین Slice کم‌ریسک شروع شده است.
Backup فقط candidate بعدی است؛ قبل از ساخت Issue/Branch باید Fresh Audit انجام شود.
Reminder همچنان permission/scheduling/data-contract ریسک بالاتری دارد و نباید زودتر از Audit Foundation ساخته شود.

## 9. Queue
### Active
1. PR #65 / Issue #64 — visible Timeline export to clipboard
2. `docs/current-state-wave6-export` — parallel documentation lane
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- PR #50 — docs reconciliation
- PR #63 / Issue #59 — Undo deletion
- PR #61 / Issue #57 — safe delete
- Issue #62 — workflow registration incident recovered/closed

## 10. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof
- قاطی‌کردن Backup/Reminder با Export کوچک

## 11. قدم بعد
- exact-head CI + Android PR #65 را کامل کن
- Green → Ready → Fresh mergeability → expected-head merge
- main را دوباره Verify کن
- Docs lane را Final Sync/Validate/Merge کن
- بعد Wave 6 را Fresh Audit کن

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
