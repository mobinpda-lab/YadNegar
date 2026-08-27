# YadNegar — Live AI Handoff

## مرجع حقیقت
GitHub Reality مقدم است. قبل از Write/Merge/گزارش وضعیت، Fresh Audit الزامی است.

Repository: `mobinpda-lab/YadNegar`  
Current main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

## وضعیت واقعی محصول
Flow اصلی:
`Quick Capture → Persist → Timeline → Search/Filter → View/Edit → Delete → Undo → Export → Backup`

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

## PR #68 / Issue #67 — Backup تکمیل شد
Exact final pre-merge head:
`8057eca7ba4957d49bc51c54cbf278935744ccfa`

Pre-merge proof:
- CI `33042505480`: success
- Android `33042505505`: success
- live mergeable=true
- final lockfile روی همان Head
- merge با expected-head lock

Merged main:
`edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

طراحی Backup:
- Snapshot از همان JSON storage موجود
- recovery/validation قبل از Snapshot
- reuse همان serializer/parser داخلی؛ serializer/schema دوم نداریم
- Timeline خالی backup معتبر می‌دهد بدون ساخت primary user storage
- snapshot موقت دوباره با production parser Validate می‌شود
- Backup action از Presentation Scope کوچک می‌آید
- TimelineHome دست‌نخورده
- Share در composition root
- `share_plus 10.1.4` exact-pinned و با Flutter 3.35 Resolve شده
- `pubspec.lock` با package set واقعی CI نهایی شده
- Branch با Bismillah main از طریق sync commit `529df3fd6656705fab3756a878c45d8ec2ed1bbc` یکپارچه شده

Issue #67 بسته completed است.

Post-main `edf0c72...`:
- CI `33042973852`: success
- Android `33042973848`: در آخرین Fresh Audit هنوز در حال Build بود

تا Android همین main success نشود، موج Backup را post-main fully verified اعلام نکن.

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

## Docs فعال
Branch: `docs/current-state-backup-active`

از نظر تاریخچه روی Backup main `edf0c72...` Sync شده است. قبل از Merge Docs:
1. نتیجه نهایی Android post-main Backup ثبت شود
2. Diff فقط Docs باشد
3. PR کوچک Docs باز شود
4. exact-head Fast CI Green
5. Fresh head/mergeability
6. expected-head merge lock

## Automation
Issue #62 بسته/recovered است.

Issue #19 باز است: Ruleset در سطح Platform هنوز required status check قابل‌نوشتن از Connector ندارد.

قرارداد Merge:
`exact current head + exact-head CI + exact-head Android برای Product + live mergeability + expected_head_sha + post-main proof`

## Product بعدی — Issue #70
`feat(backup): restore a validated Timeline snapshot safely`

Fresh Audit:
- Restore implementation مستقل وجود ندارد
- Issue تکراری مستقل برای Restore وجود نداشت
- PR #68 Restore را عمداً خارج Scope گذاشت
- فایل ورودی باید قبل از دست‌زدن به primary با production parser/schema Validate شود
- replacement نهایی باید rollback داشته باشد
- raw overwrite مستقیم ممنوع
- file selection boundary نباید به Domain نشت کند

Branch #70 فقط بعد از Green شدن Android post-main Backup ساخته شود.

## اصل سرعت
Product / CI-Automation / Docs تا حد امن موازی‌اند. Block یک Lane، Lane مستقل را متوقف نمی‌کند. سرعت از reuse، PR کوچک، CI واقعی و مستندسازی هم‌زمان می‌آید؛ نه از حذف Gate.

## ادامه
1. Android `33042973848` را Fresh Verify کن.
2. Green → Backup wave fully verified.
3. Docs branch را Final Refresh کن، Diff را کنترل کن، PR باز کن و exact-head CI بگیر.
4. Docs Green → Fresh mergeability → expected-head Merge.
5. سپس Issue #70 را از verified main به‌عنوان Slice مستقل شروع کن.
6. #19 را باز نگه دار تا Ruleset write واقعی ممکن شود.

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
