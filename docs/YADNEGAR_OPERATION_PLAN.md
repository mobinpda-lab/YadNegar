# برنامه عملیاتی شتاب‌یافته پروژه YadNegar
## نسخه 3.9 — Release Governance Verified / Recurring Reminder Next

**تاریخ مبنا:** 2026-08-27  
**مرجع حقیقت:** GitHub Repository State

## 1. مدل اجرا
هدف: تولید نرم‌افزار Verify‌شده در ساعت‌ها به‌جای روزها.

چرخه:
`Fresh Audit → Reuse → Small/Safe Parallel Slice → Tests → exact-head CI/Android → expected-head merge → post-main proof → docs sync → next slice`

Laneها:
- Core/Data
- Product/UX
- Release/Platform
- CI/Automation/Documentation

Block یک Lane، Lane مستقل را متوقف نمی‌کند. Stacked preparation فقط بعد از Fresh compare و اثبات Scope مستقل قابل Merge است.

## 2. main فعلی
Current main:
`4b792ba53a33e6153db35014ccdf3a15968a5383`

Main شامل Release Governance غیرمخرب کامل است:
- Debug APK + Release Candidate
- SHA/size evidence
- `RELEASE_MANIFEST.txt`
- Android Emulator Smoke/Recovery
- `RELEASE_READINESS.txt`
- `RELEASE_VERSION.txt`
- `RELEASE_NOTES_DRAFT.md`
- tag-availability verification بدون mutation
- `RELEASE_APPROVAL.txt`
- `ROLLBACK_PLAN.md`

## 3. آخرین Integration — PR #92 / Issue #91
Final head:
`1990e70dfe5662aac31ed8859d7906ff274c6371`

Pre-merge:
- CI `33075612499`: success
- Android `33075612644`: success
- Build: success
- Smoke/Recovery: success
- Readiness: success
- Release Draft: success
- Release Approval: success

Merge با exact `expected_head_sha` انجام شد.

Post-main روی `4b792ba53a33e6153db35014ccdf3a15968a5383`:
- CI `33076475799`: success
- Android `33076475804`: success
- Build: success
- Smoke/Recovery: success
- Readiness: success
- Release Draft: success
- Release Approval: success

Issue #91 completed است.

## 4. Release Safety
Current release build هنوز debug-signed است.

وضعیت صحیح:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

Approval فعلی intentionally blocked است تا Production signing واقعی تعریف شود.

ممنوع/انجام‌نشده:
- Tag creation/update
- GitHub Release creation
- Play Store publication
- production keystore/secret commit

## 5. Product Foundation — Stable
Main شامل:
- Timeline واحد
- Note/Event/Call/Idea/Activity
- Persian RTL
- crash-recoverable JSON persistence
- Search / Type / Date Range
- occurredAt capture/edit
- safe Delete + Undo
- Export
- validated Backup/Restore
- schema-v2 optional reminderAt + backward-compatible v1 reads
- Persian Reminder UX
- Android local notifications
- startup + Restore Reminder reconciliation

هیچ Model / Repository / Storage / AppShell / Reminder DB موازی وجود ندارد.

## 6. Product Next — Issue #93
`product: add safe recurring reminders on the existing Timeline`

هدف: Reminder تکرارشونده امن با reuse کامل foundation فعلی.

Scope اولیه:
- recurrence: `none`, `daily`, `weekly`
- schema v3
- backward-compatible read برای v1/v2
- همان TimelineItem + JSON repository/parser/serializer/recovery
- همان Reminder scheduler و stable notification payload/id
- Persian Quick Capture/Edit recurrence UX
- startup/Restore reconciliation برای recurrence
- focused domain/application/schema/scheduler/UI tests

Safety:
- no second Reminder DB/repository
- no destructive migration
- recurrence بدون reminderAt معتبر نیست
- حذف reminder باید notification را cancel کند
- no exact-alarm permission بدون نیاز اثبات‌شده

Implementation فقط بعد از بسته‌شدن docs baseline فعلی شروع می‌شود.

## 7. Automation / Documentation
### Issue #19 — Automation Gap
Ruleset فعلی:
- PR required
- deletion blocked
- non-fast-forward blocked
- required status checks هنوز Platform-level enforce نشده‌اند

Connected tooling Ruleset read دارد اما write ندارد.

### PR #86 — Documentation
Branch:
`docs/release-wave7-final`

چهار سند اجرایی با main `4b792ba...`، #92 post-main Green و Issue #93 Sync شده‌اند.

Merge فقط با:
`exact docs head + Fast CI Green + live mergeability + expected_head_sha + post-main Fast CI`

## 8. Merge Contract
### Product / Release
1. exact current head
2. Fast CI Green همان Head
3. Android/relevant gates Green همان Head
4. live mergeability=true
5. `expected_head_sha`
6. post-main proof
7. docs sync

### Docs-only
1. exact current head
2. Fast CI Green
3. live mergeability=true
4. `expected_head_sha`
5. post-main Fast CI

Historical Green برای Head جدید معتبر نیست.

## 9. خط قرمز
- duplicate workflow/foundation/storage
- fake/stale evidence
- risky direct main edits
- destructive schema migration
- secret/keystore inside repository
- production-signing claim بدون verified config
- Tag/Release/Play Store mutation بدون تصمیم Owner/Security
- حذف Gate برای سرعت

## 10. Queue
### Active
1. PR #86 — final docs integration
2. Issue #19 — required-status enforcement gap

### Next
3. Issue #93 — safe recurring reminders / schema v3
4. post-main proof برای هر Merge
5. Production signing در Slice امنیتی جدا
6. real Tag/Release/Publish فقط بعد از signing readiness و تصمیم صریح مالک

## 11. اصل سرعت
`Parallel Independent Work + Safe Stacked Preparation + Automation + Reuse + Fast Feedback + Exact Evidence + Controlled Integration + Concurrent Documentation`

## 12. گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
