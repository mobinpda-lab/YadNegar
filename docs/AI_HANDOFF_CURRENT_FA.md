# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current verified main: `78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup/Restore`

روی main:
- Note/Event/Call/Idea/Activity روی یک TimelineItem
- فارسی و RTL
- `بسم الله الرحمن الرحیم` وسط هدر و بالای عنوان یادنگار
- JSON persistence واقعی و crash-recoverable
- Search + Type + Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن
- Undo با no-overwrite conflict protection
- کپی خروجی خوانا از آیتم‌های فعلی Timeline
- ساخت و Share یک Backup JSON معتبر و قابل‌حمل
- Restore امن با validation قبل از جایگزینی، rollback و حفظ فیلترهای فعال
- Fast CI + Android APK Build/Verify/Upload واقعی

Foundation موازی Model/Repository/Storage/AppShell وجود ندارد.

## PR #69 — Bismillah تکمیل شد
Exact pre-merge head: `e3d485b5df4686224a2358855a3754707f794a59`
- CI `33041625126`: success پس از rerun همان Head برای یک timeout flaky قدیمی
- Android `33041625147`: success
- Mergeability=true
- merge با expected-head lock

Merged main: `14bfd37a7304841db74133f5fd6524535350e49a`

Post-main:
- CI `33041864865`: success
- Android `33041864841`: success

## PR #68 / Issue #67 — Backup تکمیل و Verify شد
Exact final pre-merge head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`

Pre-merge proof:
- CI `33042505480`: success
- Android `33042505505`: success
- live mergeable=true
- final lockfile روی همان Head
- merge با expected-head lock

Merged main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Backup:
- Snapshot از همان JSON storage موجود
- recovery/validation قبل از Snapshot
- reuse serializer/parser production
- بدون schema/storage/serializer دوم
- Timeline خالی backup معتبر می‌دهد
- Share در composition root
- `share_plus 10.1.4` exact-pinned

Issue #67 بسته completed است.

Post-main:
- CI `33042973852`: success
- Android `33042973848`: success

## PR #73 / Issue #70 — Restore تکمیل و Verify شد
Exact final pre-merge head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`

Pre-merge proof:
- CI `33045126480`: success
- Android `33045126515`: success
- live mergeable=true
- final lockfile روی همان Head
- merge با expected-head lock

Merged main:
`78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

طراحی Restore:
- candidate bytes قبل از write با production parser/schema Validate می‌شوند
- malformed/unsupported/duplicate/blank/invalid UTF-8 قبل از تغییر primary رد می‌شوند
- همان `_writeAll` با `.tmp`/`.bak` و rollback reuse می‌شود
- raw overwrite و Storage دوم نداریم
- file selection در composition edge با `file_picker 8.3.7`
- تأیید و feedback فارسی
- Restore موفق همان `_reload()` موجود را اجرا می‌کند؛ Search/Type/Date حفظ می‌شوند

Issue #70 بسته completed است.

Post-main:
- CI `33045454060`: success
- Android `33045454024`: success

Restore wave fully verified است.

## Foundationهای تکمیل‌شده اخیر
- #65 / #64 — visible Export
- #63 / #59 — Undo
- #61 / #57 — Delete
- #56 / #55 — edit Type
- #54 / #53 — edit occurredAt
- #52 / #51 — display Timeline time
- #49 / #48 — Quick Capture occurredAt
- #47 / #46 — Date Range UI
- #42 / #41 — crash-recoverable persistence
- #45 — CI dedupe
- #44 — typography

این Foundationها دوباره ساخته نشوند.

## Docs فعال — PR #74
Branch: `docs/current-state-restore-active`

Branch روی Restore main `78b14a8...` Sync شده است. سه سند Canonical با Restore نهایی و Product بعدی refresh می‌شوند و فایل موقت Restore حذف می‌شود. بعد فقط exact-head Fast CI + Fresh mergeability + expected-head merge lock لازم است.

## Automation
Issue #62 بسته/recovered است.

Issue #19 باز است: Ruleset در سطح Platform هنوز required status check قابل‌نوشتن از Connector ندارد.

قرارداد Merge:
`exact current head + exact-head CI + exact-head Android برای Product + live mergeability + expected_head_sha + post-main proof`

## Product فعال — Issue #75 / PR #76
`feat(reminder): add safe reminder data contract with schema migration`

Fresh Audit:
- Roadmap جامع Wave 6 را Reminder / Backup / Export تعریف کرده است.
- Backup/Export/Restore تکمیل شده‌اند.
- main فعلی هیچ `reminderAt/scheduledAt` در TimelineItem ندارد.
- Storage main هنوز schema v1 است.
- Reminder/Notification implementation مستقلی وجود ندارد.

Slice اول:
- `DateTime? reminderAt` روی همان TimelineItem مشترک
- JSON write schema v2، با read سازگار v1
- read v1 بدون mutation؛ اولین write امن upgrade به v2
- حفظ reminderAt در Edit/Backup/Restore
- timelineAt و ترتیب Timeline دست‌نخورده
- بدون dependency جدید، Notification plugin، permission یا UI

Branch: `feature/timeline-reminder-contract`  
Draft PR: #76  
Head ثبت‌شده در زمان refresh: `b79d2775d59f8212b2a8a754b6a75beb7640157c`

Reminder UI و scheduling پلتفرمی Slice بعدی است و فقط بعد از Green و Merge این Data Contract شروع می‌شود.

## اصل سرعت
Product / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. PR #74 را با docs-only exact-head CI نهایی و merge کن.
2. PR #76 را روی Head دقیق با CI + Android validate کن.
3. Green → Fresh mergeability → expected-head Merge → post-main proof.
4. سپس Reminder UI/notification scheduling را به‌عنوان Slice مستقل ادامه بده.
5. #19 باز بماند تا Ruleset write واقعی ممکن شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
