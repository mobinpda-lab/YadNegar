# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.1 — Backup Final Validation

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
`14bfd37a7304841db74133f5fd6524535350e49a`

Main شامل Timeline واحد، persistence واقعی/crash-recoverable، پنج Type، Search/Type/Date، occurredAt، Edit/Delete/Undo و visible Export است.

PR #69 نیز Bismillah را در هدر صفحه اصلی بالای عنوان یادنگار اضافه کرده و post-main Fast CI + Android هر دو Green هستند.

No duplicate Model/Repository/Storage/AppShell.

## 3. Product فعال — PR #68 / Issue #67
Backup معتبر و قابل‌حمل.

Current final-validation head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`
Status: final exact-head gates Green؛ آماده Ready/Fresh mergeability/expected-head merge.

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
- Bismillah header بعد از sync با current main حفظ شده است

### Dependency
- `share_plus: 10.1.4` exact pin
- package resolution واقعی روی Flutter 3.35 موفق بوده
- `pubspec.lock` به package set واقعی CI Sync شده
- latest majors عمداً استفاده نشده‌اند چون Flutter/Android toolchain جدیدتری می‌خواهند

### Main Sync
Backup branch بعد از PR #69 با current main از طریق Merge Commit دووالدی Sync شد:
`529df3fd6656705fab3756a878c45d8ec2ed1bbc`

این Sync هم‌زمان Backup action و Bismillah header را حفظ می‌کند.

## 4. Tests
- valid snapshot preserves item + primary bytes
- recovery before snapshot
- valid empty snapshot while primary stays absent
- backup UI success
- backup UI failure
- no backup action without scope

Dependency-resolution validation اولیه:
- Analyze Green
- 85 tests passed

## 5. Final Validation
Head نهایی: `8057eca7ba4957d49bc51c54cbf278935744ccfa`

- CI `33042505480`: Green
- Android `33042505505`: Green

فقط Gateهای همین Head merge evidence هستند.

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
- Restore/Import داخل PR #68
- Reminder/notification
- second serializer/schema
- second Timeline storage
- toolchain upgrade بدون evidence

## 9. Queue
### Active
1. PR #68 / Issue #67 — validated portable Backup
2. docs/current-state-backup-active — parallel docs
3. Issue #19 — Ruleset gap

### Next audited slice
- Issue #70 — validated Timeline Restore/Import with validation + rollback؛ Branch فقط بعد از Merge و post-main proof #68.

### Completed
- PR #69 — Bismillah home header
- PR #66 — Export wave docs
- PR #65 / Issue #64 — visible Export
- PR #63 / Issue #59 — Undo
- PR #61 / Issue #57 — safe Delete

## 10. قدم بعد
- PR #68 Ready → Fresh mergeability → expected-head Merge
- post-main CI + Android proof
- final Docs structural sync/merge
- سپس Issue #70 به‌عنوان Slice مستقل Restore/Import

## 11. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
