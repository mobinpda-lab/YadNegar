# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.7 — Delete + Undo Integrated / Wave 6 Export Next

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
`dcdefb3155322b5d49972b196786e569bc541267`

Main شامل Timeline واحد، JSON persistence واقعی/crash-recoverable، Quick Capture/Load/Edit، پنج Type، Search/Type/Date، occurredAt capture/edit، اصلاح Type، حذف امن و Undo است.

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — Safe Delete
PR #61 / Issue #57
- exact head `b10f3d2f5fc82b8acc2ee39c4a882c279a502442`
- CI `33020857429`: success
- Android `33020857455`: success
- merged with expected-head lock
- post-main CI `33023724452`: success
- post-main Android `33023724492`: success

## 4. موج تکمیل‌شده — Undo Delete
PR #63 / Issue #59
- exact head `373a1b8cf18016d27e01297abc70ff6034ef6d2c`
- CI `33023943769`: success
- Android `33023943767`: success
- live mergeability clean
- merged with expected-head lock
- current main `dcdefb3155322b5d49972b196786e569bc541267`
- post-main CI `33024326747`: success
- post-main Android `33024326787`: success

Undo:
- reuses `findById + upsert`
- metadata اصلی را حفظ می‌کند
- conflict/no-overwrite دارد
- Search/Type/Date را حفظ می‌کند
- schema/storage/history foundation جدید ندارد

## 5. Lane A — Core/Data
Foundation اصلی پایدار است:
- one Timeline model
- one Repository contract
- one crash-recoverable JSON storage
- delete/restore روی همان contract موجود

Wave 6 نباید برای Export Foundation داده موازی بسازد.

## 6. Lane B — Product/UX
Vertical Slice بعدی: Issue #64 — Export به Clipboard.

Scope هدف:
- خروجی deterministic و خوانا از Timeline
- UI action فارسی برای کپی خروجی
- Clipboard فقط در Presentation/Integration edge
- empty/success/error behavior مشخص
- بدون dependency جدید

Reminder و Backup/Restore در PR #64 Out-of-scope هستند.

## 7. Lane C — CI/Automation/Docs
- PR #50 Final Documentation Reconciliation فعال است
- README stale نیز در همین Lane اصلاح شد
- Issue #62 recovered و بسته شد
- Issue #19 Ruleset required-status gap باز است

## 8. Merge Contract
1. exact current head
2. Fast CI Green همان head
3. Android Green همان head برای Product changes
4. live mergeability true
5. `expected_head_sha` lock
6. post-main proof

Historical Green معتبر نیست.

## 9. Automation Recovery
Incident #62 بسته شده، ولی recovery rule حفظ می‌شود:
- raw PR/workflow state را Fresh audit کن
- duplicate workflow نساز
- historical run را به Head جدید نسبت نده
- exact-head evidence را حفظ کن
- فقط در صورت recurrence Issue #62 را reopen کن

## 10. Ruleset — Issue #19
`main-protection` فعال است اما required-status-check ندارد. Connector فعلی Ruleset write ندارد.
Operational merge lock تا رفع واقعی اجباری است.

## 11. Documentation Contract
PR #50 اکنون باید:
- README + Current State + Handoff + Operation Plan را روی واقعیت نهایی نگه دارد
- structurally روی main `dcdefb3...` sync شود
- exact-head validation دریافت کند
- سپس safe merge شود

## 12. Wave 6 Selection
سند جامع Wave 6 را `Reminder / Backup / Export` تعریف می‌کند.
Fresh audit:
- هیچ implementation موجودی برای این سه نیست
- dependencies فعلی فقط Flutter + path_provider
- Reminder نیازمند permission/scheduling و احتمالاً contract جدید است
- Export-to-clipboard کم‌ریسک‌ترین user-facing slice است

Issue #64 ایجاد شده و بعد از Docs شروع می‌شود.

## 13. Queue
### Active
1. PR #50 — final docs reconciliation
2. Issue #64 — next product: Timeline export to clipboard
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- #63 / #59 — Undo deletion
- #61 / #57 — safe delete
- #62 — workflow registration incident recovered/closed

## 14. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof
- قاطی‌کردن Reminder/Backup با Export کوچک

## 15. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
