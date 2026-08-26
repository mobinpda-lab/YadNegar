# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 2.3 — occurredAt Edit Integrated + Type Edit Active

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

Build یک Lane، Lane مستقل دیگر را متوقف نمی‌کند.

## 2. main فعلی
`740c290f8c2c3104dbca6518ee8c3de54b9abc51`

Main دارد:
- Timeline Domain/Repository/Storage واحد
- JSON persistence واقعی، schema-versioned و crash-recoverable
- Quick Capture / Load / Edit
- Note/Event/Call/Idea/Activity
- Search + Type + Date Range
- optional occurredAt capture برای Event/Activity
- card date/time context با `timelineAt`
- edit/clear occurredAt برای Event/Activity
- Persian RTL + Vazirmatn
- Fast CI + Android debug APK build/verify/upload

No duplicate Model/Repository/Storage/AppShell.

## 3. موج تکمیل‌شده — PR #54 / Issue #53
Merged as current main with expected-head lock.

Exact head: `183cddb533b58284c534ad2dacee74b88d6dbaff`

Pre-merge:
- CI `33016928847`: success
- Android `33016928837`: success

Post-main snapshot:
- CI `33017214825`: success
- Android `33017214826`: in progress

## 4. Product Slice فعال — PR #56 / Issue #55
`feat(edit): allow Timeline item type changes`

Branch: `feature/edit-item-type`  
Latest head: `ff59496fd12c098a5ebce7cd60dc301bb0fb8724`

Scope:
- optional type replacement در همان `EditTimelineItem`
- Dropdown نوع در همان Edit dialog
- non-occurredAt type مقصد، occurredAt پنهان را clear می‌کند
- Event/Activity مقصد، occurredAt controls موجود را reuse می‌کنند
- تست Application + Widget

ممنوع:
- Use Case دوم
- Model/Repository/Storage/Schema جدید
- dependency جدید

در Snapshot فعلی Check Run روی latest head هنوز ثبت نشده؛ بدون exact-head Gate واقعی Merge ممنوع.

## 5. Lane A — Core/Data
پایدار:
- shared Domain
- real JSON storage
- crash recovery

هر تغییر Core فقط با Gap واقعی. Foundation موازی ممنوع.

## 6. Lane B — Product/UX
Active: #56.

بعد از settle شدن #56، Gap بعدی با Fresh Audit انتخاب شود. حذف Timeline Item یکی از Gapهای قابل بررسی است، چون Repository فعلی `delete` ندارد؛ اما قبل از Issue/Implementation باید duplicate/open-work و storage implications دوباره Audit شوند.

## 7. Lane C — CI/Automation/Docs
- PR #50 Draft و Sync‌شده روی main #54
- Docs وضعیت #56 را track می‌کنند
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

PR quality و main push جدا و deduplicated هستند.

اگر یک PR Run ایجاد نشد، نباید Green فرض شود؛ Trigger باید از GitHub Reality بررسی و به‌شکل امن دوباره ایجاد/تأیید شود.

## 10. Ruleset — Issue #19
`main-protection` فعال است ولی required-status-check ندارد.

تا زمانی که Write واقعی Ruleset در دسترس و Verify نشده:
`exact-head gates + live mergeability + expected-head lock`
قانون اجباری است.

## 11. Documentation Contract
- canonical governance ثابت
- PR #43 stale و بسته
- PR #50 replacement و Draft تا Stable Snapshot
- Docs branch بعد از هر Product merge روی main جدید Sync می‌شود
- قبل از Merge Docs: Final Fresh Audit + exact-head validation

## 12. Queue
### Active
1. PR #56 / Issue #55 — edit type
2. PR #50 — parallel docs reconciliation
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- #54 / #53 — edit/clear occurredAt
- #52 / #51 — card time context
- #49 / #48 — occurredAt capture
- #47 / #46 — date range
- #42 / #41 — persistence reliability

## 13. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل به خاطر Build
- docs stale
- Ruleset enforcement ادعایی بدون proof
- درصد پیشرفت ساختگی

## 14. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
