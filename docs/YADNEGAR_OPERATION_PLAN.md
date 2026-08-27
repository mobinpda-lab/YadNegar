# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.3 — Restore Verified / Reminder Contract Active

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
`78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

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
- Restore معتبر و rollback-safe
- Bismillah centered header

No duplicate Model / Repository / Storage / AppShell.

## 3. موج تکمیل‌شده — Bismillah Header
PR #69

Exact pre-merge head: `e3d485b5df4686224a2358855a3754707f794a59`
- CI `33041625126`: success
- Android `33041625147`: success
- mergeable=true
- expected-head merge lock

Merged main: `14bfd37a7304841db74133f5fd6524535350e49a`

Post-main:
- CI `33041864865`: success
- Android `33041864841`: success

## 4. موج تکمیل‌شده — Validated Backup
PR #68 / Issue #67

Exact final pre-merge head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
- CI `33042505480`: success
- Android `33042505505`: success
- final lockfile روی همان Head
- live mergeable=true
- expected-head merge lock

Merged main: `edf0c72ba5ccf97ce5229c1e3a74095bff7237d6`

Backup behavior:
- validated snapshot bytes از concrete JSON repository
- reuse recovery/parser/serializer موجود
- بدون TimelineRepository contract جدید
- بدون schema/storage/serializer دوم
- primary data هنگام Backup تغییر نمی‌کند
- empty Timeline backup معتبر دارد
- temp snapshot با production parser دوباره Validate می‌شود
- Presentation Scope کوچک برای Backup action
- `share_plus 10.1.4` exact-pinned

Issue #67 closed completed.

Post-main:
- CI `33042973852`: success
- Android `33042973848`: success

## 5. موج تکمیل‌شده — Validated Restore
PR #73 / Issue #70

Exact final pre-merge head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`
- CI `33045126480`: success
- Android `33045126515`: success
- final lockfile روی همان Head
- live mergeable=true
- expected-head merge lock

Merged main: `78b14a8f50b9b0ccee02174fd6739c2cabcead7d`

Restore behavior:
- candidate bytes قبل از write Validate می‌شوند
- malformed / unsupported schema / duplicate IDs / blank / invalid UTF-8 قبل از mutation رد می‌شوند
- production parser و همان staged `_writeAll` reuse می‌شود
- `.tmp` / `.bak` و rollback موجود حفظ شده
- raw overwrite و Storage دوم وجود ندارد
- `file_picker 8.3.7` در composition boundary است
- confirmation و feedback فارسی
- TimelineHome همان `_reload()` را اجرا می‌کند و فیلترهای Search/Type/Date حفظ می‌شوند

Issue #70 closed completed.

Post-main:
- CI `33045454060`: success
- Android `33045454024`: success

موج Restore fully verified است.

## 6. Lane A — Core/Data
Foundation main پایدار:
- یک Timeline model
- یک Repository contract
- یک crash-recoverable JSON storage
- schema-versioned parser/serializer production
- validated Backup/Restore path
- staged `_writeAll` با `.tmp` / `.bak` و restore-on-failure

Active Core Slice:
Issue #75 / PR #76 — Reminder Data Contract.

Audit:
- TimelineItem main هنوز `reminderAt` ندارد
- schema main هنوز v1 است
- Reminder storage/model موازی وجود ندارد

Contract فعال:
- optional `reminderAt` روی همان TimelineItem
- write schema v2
- read سازگار v1 و v2
- v1 read بدون mutation؛ اولین write امن upgrade
- reminderAt در Edit/Backup/Restore حفظ شود
- timelineAt/order تغییر نکند
- dependency جدید در این Slice ممنوع/غیرلازم

## 7. Lane B — Product/UX
Restore Verify شده است.

Reminder UI/Notification هنوز شروع نشده و عمداً بعد از تثبیت Data Contract قرار دارد.

Slice بعد از Merge #76:
- UX فارسی برای تعیین/پاک‌کردن reminderAt
- audit plugin notification سازگار با Flutter 3.35
- permission boundary پلتفرم
- scheduling/cancel contract
- widget/application tests
- Android gate واقعی

Recurring Reminder تا Audit جدا خارج Scope بماند.

## 8. Lane C — CI/Automation/Docs
- PR #74: `docs/current-state-restore-active`
- branch structurally روی Restore main `78b14a8...` Sync شده
- سه Canonical doc با evidence نهایی Restore و Product #75 refresh می‌شوند
- فایل موقت Restore در final docs commit حذف می‌شود
- مرحله بعد: docs-only diff → exact-head Fast CI → safe merge
- Issue #62 recovered/closed
- Issue #19 required-status Ruleset gap باز است

## 9. Merge Contract
1. exact current head
2. Fast CI Green on that head
3. Android Green on that head for Product changes
4. live mergeability true
5. `expected_head_sha` lock
6. post-main proof

Historical Green هرگز برای Head جدید reuse نمی‌شود.

## 10. Queue
### Active
1. PR #74 — canonical docs after Restore
2. Issue #75 / PR #76 — Reminder schema-v2 data contract
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- PR #73 / Issue #70 — validated Restore
- PR #68 / Issue #67 — validated portable Backup
- PR #69 — Bismillah header
- PR #65 / Issue #64 — visible Timeline Export
- PR #63 / Issue #59 — Undo deletion
- PR #61 / Issue #57 — safe delete
- Issue #62 — workflow registration incident recovered/closed

## 11. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- docs stale
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof
- duplicate JSON serializer/parser
- raw overwrite در Restore
- sidecar Reminder storage
- افزودن Notification dependency قبل از compatibility audit
- mixing recurring reminder into first Reminder contract slice

## 12. قدم بعد
1. PR #74 را با docs-only exact-head Fast CI نهایی کن.
2. PR #76 exact-head CI + Android را بررسی کن.
3. PR #76 Green → Fresh mergeability → expected-head merge → post-main proof.
4. سپس Reminder UI/notification scheduling را در Slice مستقل شروع کن.
5. #19 باز بماند تا Platform-level enforcement واقعاً writable شود.

## 13. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
