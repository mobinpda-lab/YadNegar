# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.0 — Validated Backup Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
`Fresh Audit → Reuse → Small PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- CI/Automation/Documentation

هدف: نرم‌افزار Verify‌شده در ساعت‌ها، نه روزها. Block یک Lane نباید Lane مستقل را متوقف کند.

## 2. main فعلی
`ecd088c7d880b925cbb3240ad7ee0230a911d42e`

Main شامل Timeline واحد، persistence واقعی/crash-recoverable، پنج Type، Search/Type/Date، occurredAt، Edit/Delete/Undo و visible Export است.

No duplicate Model/Repository/Storage/AppShell.

## 3. Product فعال — PR #68 / Issue #67
Backup معتبر و قابل‌حمل.

Initial head: `65dd346b6203efa8a1d70a5908024c252d49dfba`
Status: Draft dependency-resolution/validation.

### Core/Data
- `JsonFileTimelineRepository.readValidatedSnapshotBytes()` روی concrete implementation
- recovery/validation موجود reuse می‌شود
- `_encodeItems` بین persistence و empty snapshot مشترک است
- schema version و Domain Repository contract تغییر نکرده
- primary valid bytes بدون تغییر Snapshot می‌شوند
- empty Timeline بدون ساخت primary storage یک payload معتبر می‌گیرد

### Backup Service
- snapshot timestamped در temp
- write with flush
- final snapshot دوباره با production JSON repository Validate می‌شود
- primary user data تغییر نمی‌کند

### Product/UX
- Presentation Scope کوچک برای Backup action
- TimelineHome دست‌نخورده
- TimelineScreen action فارسی + success/error feedback
- Share composition در `main.dart`

### Dependency
- `share_plus: 10.1.4` exact pin
- latest majors عمداً استفاده نشده‌اند چون Flutter/Android toolchain جدیدتری می‌خواهند
- اولین PR runs برای dependency resolution هستند
- final `pubspec.lock` باید بعد از resolution واقعی Commit شود

## 4. Tests
- valid snapshot preserves item + primary bytes
- recovery before snapshot
- valid empty snapshot while primary stays absent
- backup UI success
- backup UI failure
- no backup action without scope

## 5. Initial Validation
- CI `33027569106`: active
- Android `33027569115`: active

Green این Head به‌تنهایی merge evidence نهایی نیست چون lockfile هنوز final نشده. پس از lock sync Head جدید و exact-head gates جدید لازم است.

## 6. Docs Lane
`docs/current-state-backup-active`
Docs هم‌زمان با Product پیش می‌روند؛ بعد Product merge باید structurally روی main جدید Sync و Fresh CI شوند.

## 7. Automation
Issue #19 required-status Ruleset gap باز است.

Merge contract:
1. exact current head
2. Fast CI Green
3. Android Green
4. live mergeability true
5. expected-head lock
6. post-main proof

## 8. Out of Scope
- Restore/Import
- Reminder/notification
- second serializer/schema
- second Timeline storage
- toolchain upgrade بدون evidence

## 9. Queue
### Active
1. PR #68 / Issue #67 — validated portable Backup
2. docs/current-state-backup-active — parallel docs
3. Issue #19 — Ruleset gap

### Completed
- PR #66 — Export wave docs
- PR #65 / Issue #64 — visible Export
- PR #63 / Issue #59 — Undo
- PR #61 / Issue #57 — safe Delete

## 10. قدم بعد
- dependency resolve/compile feedback #68
- final lockfile sync
- final CI + Android
- Safe Merge + post-main proof
- final Docs sync/merge
- Restore/Import فقط به‌عنوان Slice بعدی مستقل و بعد از Fresh Audit

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
