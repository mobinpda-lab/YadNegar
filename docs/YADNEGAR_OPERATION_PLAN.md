# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.3 — Restore Active

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در چند ساعت به‌جای چند روز.

چرخه:
`Fresh Audit → Reuse → Small/Batched PR → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند.

## 2. main فعلی
`9e31b6e4db22ca5d9a34231eb4205f01027d0655`

Main شامل Timeline واحد، crash-recoverable JSON persistence، پنج Type، Search/Type/Date، occurredAt، Edit/Delete/Undo، Export، validated Backup و Bismillah header است.

No duplicate Model / Repository / Storage / AppShell.

## 3. موج‌های Verify‌شده اخیر
### Bismillah — PR #69
Pre-merge CI/Android Green؛ merged main `14bfd37a...`؛ post-main Green.

### Validated Backup — PR #68 / Issue #67
Final head `8057eca7...`؛ exact-head CI `33042505480` Green؛ Android `33042505505` Green؛ final lockfile؛ expected-head merge.
Merged main `edf0c72b...`؛ post-main CI `33042973852` و Android `33042973848` Green. Issue #67 completed.

### Canonical Docs — PR #72
Head `9689dd3f...`؛ docs-only؛ CI `33043437075` Green؛ expected-head merge.
Current main `9e31b6e4...`؛ post-main CI `33044169143` Green.

## 4. Lane A — Core/Data Restore
Active PR #73 / Issue #70.

Core implementation:
- `restoreValidatedSnapshotBytes(List<int>)` روی concrete `JsonFileTimelineRepository`
- strict UTF-8 decode
- blank/malformed candidate rejection
- production parser/schema reuse
- unsupported schema typed error
- duplicate ID typed error
- primary untouched on rejection
- existing `_writeAll` reused for staged replacement, `.bak` preservation and rollback
- no TimelineRepository Domain contract change
- no second parser/serializer/storage

Real-file tests cover valid restore and all major rejection/data-preservation paths.

## 5. Lane B — Product/UX Restore
- Restore action در AppBar کنار Backup/Export
- confirmation فارسی قبل از replacement
- File Picker در platform/composition edge
- exact pin: `file_picker 8.3.7`
- success/invalid/unsupported/duplicate/failure feedback فارسی
- cancel بدون mutation
- Restore موفق → existing `TimelineHome._reload()`
- active Search/Type/Date state پاک نمی‌شود
- Bismillah، Backup و Export حفظ می‌شوند

Widget tests confirmation، successful reload with active search و unsupported feedback را پوشش می‌دهند.

## 6. Dependency / Toolchain Gate
Flutter: 3.35.0

Pre-lock head `f04419ee...`:
- CI `33044782989`: success
- Analyze: clean
- Tests: 93 passed
- dependency resolution: `file_picker 8.3.7` + `flutter_plugin_android_lifecycle 2.0.34`

Final lockfile روی current product head:
`fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`

Final exact-head runs:
- CI `33045126480`: active at last refresh
- Android `33045126515`: active at last refresh

Pre-lock Green برای Merge قابل reuse نیست.

## 7. Lane C — CI/Automation/Docs
Active docs branch:
`docs/current-state-restore-active`

Docs مستقل از Product جلو می‌روند اما تا Product settle Merge نمی‌شوند. بعد Product merge:
- structural sync onto resulting main
- final exact evidence refresh
- docs-only diff
- exact-head Fast CI
- live mergeability + expected-head merge
- post-main Fast CI

Issue #19 required-status Ruleset gap باز است.

## 8. Merge Contract
1. exact current head
2. Fast CI Green on that head
3. Android Green on that head for Product
4. live mergeability true
5. expected-head SHA lock
6. post-main CI + Android proof

Historical Green هرگز برای Head جدید reuse نمی‌شود.

## 9. Queue
### Active
1. PR #73 / Issue #70 — validated Restore/Import
2. `docs/current-state-restore-active`
3. Issue #19 — Ruleset enforcement gap

### Completed recently
- PR #72 — Backup/Bismillah/Restore-next canonical docs
- PR #68 / Issue #67 — validated Backup
- PR #69 — Bismillah header
- PR #65 / Issue #64 — visible Export
- PR #63 / Issue #59 — Undo
- PR #61 / Issue #57 — Delete

## 10. خط قرمز
- duplicate foundation
- fake CI/build/persistence
- stale merge evidence
- توقف Lane مستقل
- stale docs
- duplicate workflow workaround
- ادعای Ruleset enforcement بدون proof
- duplicate JSON parser/serializer/storage
- raw overwrite در Restore
- Merge قبل از final lockfile exact-head gates
- mixing Reminder into Restore Slice

## 11. قدم بعد
1. final Head PR #73 را Fresh Verify کن.
2. فقط failure واقعی را اصلاح کن.
3. Green → Ready → Fresh mergeability → expected-head merge.
4. resulting main → CI + Android post-main proof + Issue #70 closure.
5. Restore Docs → final sync + docs-only CI + safe merge.
6. Fresh Audit برای Product gap بعدی.

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`

کوتاه، غیر فنی، نتیجه‌محور.
