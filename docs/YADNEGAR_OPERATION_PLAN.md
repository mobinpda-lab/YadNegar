# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.2 — Backup Verified / Restore Active Next

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
`edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Main شامل:
- Timeline واحد
- JSON persistence واقعی و crash-recoverable
- Quick Capture / Load / Edit
- Note / Event / Call / Idea / Activity
- Search / Type / Date Range
- occurredAt capture/edit
- اصلاح Type
- حذف امن
- Undo با conflict protection
- Export visible Timeline
- Backup معتبر و قابل‌حمل
- Bismillah centered header

No duplicate Model / Repository / Storage / AppShell.

## 3. موج تکمیل‌شده — Bismillah Header
PR #69

Exact pre-merge head:
`e3d485b5df4686224a2358855a3754707f794a59`

Pre-merge proof:
- CI `33041625126`: success پس از rerun همان Head برای یک timeout flaky قدیمی
- Android `33041625147`: success
- mergeable=true
- expected-head merge lock

Merged main:
`14bfd37a7304841db74133f5fd6524535350e49a`

Post-main:
- CI `33041864865`: success
- Android `33041864841`: success

## 4. موج تکمیل‌شده — Validated Backup
PR #68 / Issue #67

Exact final pre-merge head:
`8057eca7ba4957d49bc51c54cbf278935744ccfa`

Pre-merge proof:
- CI `33042505480`: success
- Android `33042505505`: success
- final `pubspec.lock` روی همان Head
- live mergeable=true
- expected-head merge lock

Merged main:
`edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Backup behavior:
- validated snapshot bytes از concrete JSON repository
- reuse recovery/parser/serializer موجود
- بدون TimelineRepository contract جدید
- بدون schema/storage/serializer دوم
- primary data هنگام Backup تغییر نمی‌کند
- empty Timeline backup معتبر دارد
- temp snapshot با production parser دوباره Validate می‌شود
- Presentation Scope کوچک برای Backup action
- `TimelineHome` دست‌نخورده
- Share در composition root
- `share_plus 10.1.4` exact-pinned و compatible با Flutter 3.35
- branch با Bismillah main در sync commit `529df3fd6656705fab3756a878c45d8ec2ed1bbc` یکپارچه شد

Issue #67 closed completed.

Post-main `edf0c72...`:
- CI `33042973852`: success
- Android `33042973848`: success
- Android build + verify + upload: success

موج Backup fully verified است.

## 5. Lane A — Core/Data
Foundation پایدار:
- یک Timeline model
- یک Repository contract
- یک crash-recoverable JSON storage
- schema-versioned parser/serializer production
- validated snapshot path برای Backup
- staged `_writeAll` با `.tmp` / `.bak` و restore-on-failure

Restore بعدی باید همین parser و write/rollback path را reuse کند؛ Foundation موازی ممنوع.

## 6. Lane B — Product/UX
Backup Verify شده است.

Next audited slice:
Issue #70 — Restore/Import امن.

Audit عملی #70:
- candidate bytes قبل از هر write با production parser/schema Validate شوند
- duplicate-id safety قبل از replacement
- `_writeAll` موجود برای staged replacement + rollback reuse شود
- `TimelineRepository` Domain contract لازم نیست تغییر کند
- file selection فقط در platform/composition boundary
- confirmation فارسی قبل از replacement
- success/invalid/unsupported/duplicate/failure feedback فارسی
- `TimelineHome` همان `_reload()` فعلی را بعد از Restore موفق اجرا کند تا Search/Type/Date state حفظ شود
- raw overwrite ممنوع

Backup post-main Green است؛ Branch #70 اکنون می‌تواند از `edf0c72...` شروع شود.

## 7. Lane C — CI/Automation/Docs
- docs branch: `docs/current-state-backup-active`
- branch structurally روی merged Backup main `edf0c72...` Sync شده
- Canonical docs کامل حفظ شده‌اند
- final Backup evidence ثبت شده
- مرحله بعد: Diff docs-only → PR → exact-head Fast CI → safe merge
- Issue #62 recovered/closed
- Issue #19 required-status Ruleset gap باز است

## 8. Merge Contract
1. exact current head
2. Fast CI Green on that head
3. Android Green on that head for Product changes
4. live mergeability true
5. `expected_head_sha` lock
6. post-main proof

Historical Green هرگز برای Head جدید reuse نمی‌شود.

## 9. Queue
### Active
1. docs/current-state-backup-active — final docs after Backup
2. Issue #70 — validated Restore/Import with rollback
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- PR #68 / Issue #67 — validated portable Backup
- PR #69 — Bismillah header
- PR #65 / Issue #64 — visible Timeline Export
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
- duplicate JSON serializer/parser
- raw overwrite در Restore
- mixing Reminder into Restore Slice

## 11. قدم بعد
1. Docs diff را کنترل کن و PR باز کن.
2. Docs exact-head Fast CI Green → Fresh mergeability → expected-head merge → main Fast CI.
3. هم‌زمان Branch #70 را از `edf0c72...` بساز و Core/Data Restore را با production parser + `_writeAll` reuse شروع کن.
4. File picker dependency فقط بعد از compatibility proof و Android gate واقعی قطعی شود.
5. #19 باز بماند تا Platform-level enforcement واقعاً writable شود.

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
