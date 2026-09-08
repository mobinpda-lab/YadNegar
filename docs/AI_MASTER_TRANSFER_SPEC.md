# YADNEGAR — AI MASTER TRANSFER SPEC
IDENTITY: YadNegar / یادنگار | Repo: mobinpda-lab/YadNegar | Platform: Flutter/Dart/Android | Main: main | Mission: Lightweight but production-grade Persian timeline/task/follow-up journal with durable history, reminders, reports and autonomous delivery.
AUTHORITY: GitHub Reality > Approved Product Contract > Governance > Current-State Docs > Conversation Memory. Fresh GitHub audit is mandatory before continuation.
CORE PRODUCT MODEL: Tracked Task Root→Persistent FollowUps→Jalali/Persian History→Search→PDF/Print/Share. Flat Timeline is legacy tooling, never a second foundation.
DATA FOUNDATION: One canonical JSON persistence foundation. No duplicate Task/FollowUp/Reminder/Search/PDF/Backup/Project/Calendar stores. Reuse Before Add.
STORAGE: Backward-compatible schema; safe-write upgrade; tmp/bak crash recovery; validated Backup/Restore; unsupported newer schema fails closed; preserve historical data.
SCHEMA: Current foundation includes migration continuity through projects; historical versions must remain readable according to contract.
CORE CAPABILITIES [IMPLEMENTED/FOUNDATION]: Tracked Task Root; Persistent FollowUps; Persian/Jalali history; Description; Search; Project membership; root-only Home; single repository snapshot per reload; latest real FollowUp semantics; safe FollowUp swipe; Jalali monthly grid; 24-hour time picker; PDF/Print/Share; date reports; JSON Backup/Restore; Reminder foundation; none/daily/weekly recurrence; Today Center; Next Action.
HOME CONTRACT: Home displays Root Tasks only. FollowUps live in Root history/detail. One repository snapshot per reload. Root creation time must never masquerade as a FollowUp.
FOLLOWUP: Every FollowUp belongs to one Root; preserves Parent/Sibling history; inherits Project from Parent; safe edit; optional independent Reminder; swipe opens capture and never deletes/dismisses Root.
REMINDER: Reuse Reminder model + JSON persistence + TimelineReminderScheduler + AndroidLocalTimelineReminderScheduler + flutter_local_notifications + startup/restore reconciliation + Persian picker. Durable Save→Schedule/Reschedule/Cancel. No second scheduler/store/engine.
REMINDER SAFETY: set/change/clear/delete/restart/restore/reconcile/permission-denied/past-time fail-safe/daily/weekly; FollowUp Reminder cannot alter Parent history.
NEXT ACTION: Distinct from Reminder. Root-only nextActionAt; derived Today/Overdue/Upcoming/No Next Action buckets; local calendar-day semantics; not persisted as duplicate state.
PROJECTS: First-class. Root may have Project; FollowUp inherits Parent Project and cannot create independent Project context. Create/rename/color/assign/reassign/safe-delete while preserving canonical Task data.
SEARCH: Canonical reuse-based search over Root title, Description and FollowUp text; no separate index/store unless proven performance need.
REPORTS: Shared PDF/Print/Share foundation; Persian RTL/Jalali/history-aware; All/Selected/Single Task/Selected Jalali Day/Inclusive Date Range; FollowUp date matching must be semantically correct.
BACKUP/RESTORE: Release contract; schema validation; backward compatibility; crash-safe writes; newer-schema fail-closed; restore + Reminder reconciliation; every persistent feature requires Backup/Restore coverage.
ANDROID VALIDATION: Relevant Debug APK, RC, emulator startup/recovery, Reminder scheduling, RTL/Jalali, Home, FollowUp, Backup/Restore, readiness and release evidence. Screenshots/mock evidence never substitutes for executable evidence.
RELEASE: Current target=stable Production Local APK. Production signing/Play Store are separate decisions and not prerequisites for local production usability.
SIGNING/PLAY: Without explicit Owner/Security decision, do not create production keystore, secrets, final release tag, final GitHub Release or Play Store publish.
CI CHAIN: Fast CI→Android Build→Candidate→Smoke/Recovery→Readiness→Release Draft→Approval/Rollback. Exact-head evidence only.
FACTORY ORCHESTRATOR: Maximum Parallel development; serial protected evidence-based merge. Production Orchestrator wakes every 8 minutes, checks eligible PRs/current main/exact head/gates/freshness/base/mergeability, merges max one per invocation, validates post-main, continues queue.
AUTOMATION TARGET: 100% practical autonomy across issue/task orchestration, workers, implementation, testing, self-fix, documentation, PR, CI, build, Android validation, evidence, merge, release, monitoring, recovery and rollback, subject to explicit human decisions and external credentials.
SELF-FIX: bounded detect→classify→fix→retest→evidence loop; repeated/unresolved/security/destructive failures escalate and never bypass gates.
RECOVERY: idempotent recovery queue; stale evidence invalidation; exact-head revalidation; retry/backoff/escalation; post-recovery proof.
MONITORING: Factory health, queue health, CI freshness, Android/release chain, mergeability, failed gates, stale PRs/evidence, production release health.
ROLLBACK: Known-good commit/artifact; controlled rollback; restore/reconcile data where needed; validate; document incident and corrective action.
DOCUMENTATION: Canonical Operating Package; AI Continuation State; Operation Plan; Comprehensive Project Document; Issues/PRs; CI/release evidence; historical records. Documentation is Definition of Done.
REPORT STANDARD: Compact: CURRENT STATE|DONE|STATUS|EVIDENCE|BLOCKER/RISK|NEXT ACTION. Separate REALITY vs PLAN vs BLOCKED vs OWNER DECISION.
PARALLEL LANES: Product; Reminder; Home/Today; FollowUp UX; Reports; Projects; Search; Release; Android Validation; Automation; Documentation; Governance. Independent lanes run concurrently; dependent/shared changes are coordinated.
GOVERNANCE GAP: Ruleset Required Status Checks remains dependent on GitHub Ruleset write capability (#19). Never pretend this platform control is active until verified.
KNOWN REMAINING TARGETS: Real GitHub Release; production signing/external credentials (#185); persistent autonomous code-worker backend (#184); auto-release/post-release monitoring/rollback (#188/#191); stronger queue/worker idempotency; explicit exclusion/escalation for security/destructive failures.
CURRENT ESTIMATE: ~90% engineering completion; ~10% remaining; estimate only.
AI CONTINUATION: «ادامه یادنگار» means fresh-audit GitHub, reconcile current main with canonical docs, select nearest real unfinished slice, execute maximum-safe parallel work, validate exact head, document and report.
TRANSFER RULE: This spec transfers the product contract, architecture, roadmap and factory model; GitHub source remains authority for actual implementation.