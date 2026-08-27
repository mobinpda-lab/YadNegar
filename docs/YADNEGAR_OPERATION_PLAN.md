# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.1 — Backup Ready to Merge

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

Main شامل Timeline واحد، persistence واقعی/crash-recoverable، پنج Type، Search/Type/Date، occurredAt، Edit/Delete/Undo و visible Export است. PR #69 نیز Bismillah را در هدر صفحه اصلی اضافه کرده و post-main Fast CI + Android هر دو Green هستند.

## 3. Product فعال — PR #68 / Issue #67
Backup معتبر و قابل‌حمل.

Current final-validation head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`

Fresh proof:
- CI `33042505480`: Green
- Android `33042505505`: Green
- live mergeability: true
- no head drift observed

Implementation:
- همان JSON storage/recovery/parser/serializer موجود reuse می‌شود
- snapshot معتبر و timestamped در temp ساخته و با production parser دوباره Validate می‌شود
- empty Timeline نیز backup معتبر دارد
- `share_plus 10.1.4` exact-pinned است
- `pubspec.lock` با dependency set واقعی Flutter 3.35 نهایی شده
- Bismillah header پس از sync با main حفظ شده
- schema و TimelineRepository contract تغییر نکرده‌اند

Sync commit با current main:
`529df3fd6656705fab3756a878c45d8ec2ed1bbc`

## 4. Merge Contract
1. mark PR Ready
2. Fresh-read exact head + mergeability
3. expected-head merge روی `8057eca7...`
4. post-main Fast CI + Android proof

## 5. Docs Lane
`docs/current-state-backup-active`
بعد Product merge روی main نهایی structural sync می‌شود؛ سپس evidence نهایی، exact-head docs CI و Safe Merge.

## 6. Automation
Issue #19 required-status Ruleset gap باز است.

## 7. Queue
### Active
- PR #68 / Issue #67 — Backup
- docs/current-state-backup-active
- Issue #19 — Ruleset gap

### Next audited slice
- Issue #70 — Restore/Import امن با validation + rollback؛ Branch فقط بعد از post-main proof Backup.

## 8. Out of Scope PR #68
- Restore/Import
- Reminder/notification
- second serializer/schema/storage
- toolchain upgrade بدون evidence

## 9. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
