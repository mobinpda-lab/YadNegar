# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit before every write, merge, SHA/status or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Current main: `ecd088c7d880b925cbb3240ad7ee0230a911d42e`

Main includes:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export`

Export PR #65 is integrated and post-main CI/Android are Green. Docs PR #66 is integrated and post-main Fast CI is Green.

## Active Product — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Branch: `feature/timeline-backup-share`  
Initial exact PR head: `65dd346b6203efa8a1d70a5908024c252d49dfba`  
Status: Draft during dependency-resolution and full validation.

Implemented so far:
- concrete JSON repository exposes validated snapshot bytes without changing `TimelineRepository`
- existing recovery/validation path runs before snapshot generation
- existing JSON encoder is reused; no second serializer or schema
- valid empty snapshot works without creating primary user storage
- timestamped snapshot is written to temporary storage and re-validated with production parser
- Persian Backup action is delivered through a small presentation scope; `TimelineHome` remains untouched
- `share_plus` is pinned to `10.1.4` pending exact lockfile resolution on Flutter 3.35
- real-file and widget coverage added

Initial live diff: 8 files, no Domain contract/schema/Restore/Reminder changes.

Initial exact-head workflows:
- YadNegar CI `33027569106`: active
- YadNegar Android Build `33027569115`: active

Important: this first Head is dependency-resolution feedback only. `pubspec.lock` must be synchronized to the actual resolved set, and all final exact-head gates must run again after that later Head.

## Dependency / Toolchain Audit
- Flutter CI: 3.35.0
- AGP: 8.9.1
- Gradle: 8.12
- current app source/target compatibility: Java 11
- `share_plus` 10.1.4 supports Flutter >=3.22 and requires Android Java 17 / AGP >=8.3 / Gradle >=8.4
- latest major versions require newer Flutter/Android toolchains and are intentionally not used

No Toolchain upgrade is allowed unless exact Android evidence proves it is necessary.

## Documentation Lane
Branch: `docs/current-state-backup-active`
Tracks PR #68 in parallel. Keep Draft until Product settles; final-sync onto resulting main, refresh evidence, exact-head docs CI, then safe merge.

## Automation
Issue #19 remains open because Platform-level required status checks are not writable through the connected GitHub tooling.

Merge contract:
`exact current head + exact-head CI Green + exact-head Android Green for product + live mergeability + expected_head_sha + post-main proof`

## Next Actions
1. Read dependency-resolution / analyze / test / Android feedback on PR #68.
2. Synchronize `pubspec.lock` to the exact resolved package set.
3. Fix only evidence-backed compile/test issues; no speculative foundation.
4. Re-run exact-head CI + Android on final Product head.
5. Green → Ready → Fresh mergeability → expected-head Merge → post-main proof.
6. Final-sync/merge this Docs lane.
7. Restore/Import remains a separate future slice.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
