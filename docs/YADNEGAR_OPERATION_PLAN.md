# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.4 — Type Edit Integrated + Delete Slice Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در چند ساعت به‌جای چند روز.

چرخه:
`Fresh Audit → Reuse → Small PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

سه Lane موازی:
- Core/Data
- Product/UX
- CI/Automation/Documentation

Build یا Failure یک Lane، Lane مستقل دیگر را متوقف نمی‌کند.

## 2. main فعلی
`71d1d993e362be898be955963653eff832a7da0a`

Main دارد:
- Timeline Domain/Repository/Storage واحد
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Quick Capture / Load / Edit
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- optional occurredAt capture برای Event/Activity
- card date/time context با `timelineAt`
- edit/clear occurredAt
- اصلاح type داخل همان Edit flow
- Persian RTL + Vazirmatn
- Fast CI + Android debug APK build/verify/upload

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — PR #56 / Issue #55
Merged as current main with expected-head lock.

Exact head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`

Pre-merge:
- CI `33017606387`: success
- Android `33017606312`: success

Post-main:
- CI `33017911498`: success
- Android `33017911496`: success

## 4. Product Slice فعال — PR #58 / Issue #57
`feat(timeline): delete items with confirmation`

Branch: `feature/delete-timeline-item`  
Latest head: `58bce967c3d28fcd70d117ab114ee4d24625166f`

Scope واقعی:
- افزودن `deleteById` به همان `TimelineRepository`
- reuse مسیر crash-recoverable `_readAll → _writeAll`
- `DeleteTimelineItem` application use case کوچک
- wiring در production repository موجود
- حذف از همان Edit dialog با تأیید فارسی
- reload با حفظ مسیر state/filter موجود
- Application + Widget + real temp-file tests

ممنوع:
- Repository/Storage دوم
- schema bump بدون نیاز
- soft-delete/tombstone/sync foundation
- حذف بدون confirmation

Validation history:
- Head قبلی Android Green بود
- CI فقط به‌خاطر دو Fake Repository قدیمی فاقد `deleteById` Fail شد
- هر دو test fake روی latest head اصلاح شده‌اند
- Merge فقط بعد از exact-head Fast CI + Android Green و final live mergeability مجاز است

## 5. Lane A — Core/Data
Active در #58:
- Contract حذف در Repository موجود
- persistence حذف روی همان write path امن
- تست real-file برای حذف و staging cleanup

Foundation موازی ممنوع.

## 6. Lane B — Product/UX
Active در #58:
- حذف فقط از Edit flow موجود
- تأیید صریح کاربر
- reload بعد از حذف

بعد از Merge، Gap بعدی فقط با Fresh Audit و duplicate check انتخاب می‌شود.

## 7. Lane C — CI/Automation/Docs
- PR #50 Draft و در حال Sync با Product واقعیت
- Docs current main و #58 را track می‌کنند
- Issue #19 Ruleset gap باز است
- Ruleset write هنوز در Connector موجود نیست

## 8. Merge Contract
هر Product PR:
1. exact current head
2. Fast CI Green روی همان head
3. Android Build Green روی همان head
4. live mergeability
5. `expected_head_sha` merge lock
6. post-main Fast + Android proof

Historical Green معتبر نیست.

## 9. GitHub Automation
Fast Gate:
`flutter pub get → flutter analyze → flutter test`

Android Gate:
`flutter pub get → flutter build apk --debug → verify APK → upload artifact`

CI به‌عنوان detector خطای contract/test-double هم استفاده می‌شود، اما Failure واقعی باید روی همان Branch اصلاح شود؛ Gate دور زده نمی‌شود.

## 10. Ruleset — Issue #19
`main-protection` فعال است ولی required-status-check ندارد.

تا زمانی که Write واقعی Ruleset در دسترس و Verify نشده:
`exact-head gates + live mergeability + expected-head lock`
قانون اجباری است.

## 11. Documentation Contract
- PR #43 stale و بسته
- PR #50 replacement و Draft تا Stable Snapshot
- Docs هم‌زمان با Product refresh می‌شوند
- بعد از Product merge، Branch docs روی main نهایی Sync می‌شود
- قبل از Merge Docs: Final Fresh Audit + exact-head validation

## 12. Queue
### Active
1. PR #58 / Issue #57 — delete item with confirmation
2. PR #50 — parallel docs reconciliation
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- #56 / #55 — edit item type
- #54 / #53 — edit/clear occurredAt
- #52 / #51 — card time context
- #49 / #48 — occurredAt capture
- #47 / #46 — date range
- #42 / #41 — persistence reliability

## 13. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل به خاطر Build/Failure
- docs stale
- Ruleset enforcement ادعایی بدون proof
- درصد پیشرفت ساختگی

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
