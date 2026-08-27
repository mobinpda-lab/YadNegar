# YadNegar AI Continuation State

Last updated: 2026-08-27

## Source of Truth
`GitHub Reality > approved architecture decisions > canonical docs > exact CI/workflow evidence > conversation memory`

Fresh-audit before every write, merge, SHA/status or progress claim.

## Verified Main
Repository: `mobinpda-lab/YadNegar`  
Current main: `14bfd37a7304841db74133f5fd6524535350e49a`

Main includes:
`Quick Capture → JSON Persistence → Timeline → Search/Filter → View/Edit → Delete → Undo → Export`

Home header also includes centered `بسم الله الرحمن الرحیم` above the YadNegar title via merged PR #69. Post-merge Fast CI and Android Build are Green on the current main.

## Active Product — PR #68 / Issue #67
`feat(backup): share validated Timeline backup snapshot`

Branch: `feature/timeline-backup-share`  
Current final-validation head: `8057eca7ba4957d49bc51c54cbf278935744ccfa`  
Status: Draft until final exact-head gates complete.

Implemented:
- concrete JSON repository exposes validated snapshot bytes without changing `TimelineRepository`
- existing recovery/validation path runs before snapshot generation
- existing JSON encoder is reused; no second serializer or schema
- valid empty snapshot works without creating primary user storage
- timestamped snapshot is written to temporary storage and re-validated with production parser
- Persian Backup action is delivered through a small presentation scope; `TimelineHome` remains untouched
- `share_plus` is exact-pinned to `10.1.4` for Flutter 3.35 compatibility
- `pubspec.lock` is now synchronized to the exact package set resolved by CI
- real-file and widget coverage added
- branch was merged structurally onto current main through sync commit `529df3fd6656705fab3756a878c45d8ec2ed1bbc`
- Bismillah header and Backup action are both preserved in the combined `TimelineScreen`

Dependency-resolution proof before lock commit:
- Flutter 3.35 dependency resolution succeeded
- Analyze succeeded
- 85 tests passed

Final exact-head workflows on `8057eca7ba4957d49bc51c54cbf278935744ccfa`:
- YadNegar CI `33042505480`: active
- YadNegar Android Build `33042505505`: active

Only the final results on this exact head count as merge evidence.

## Dependency / Toolchain Audit
- Flutter CI: 3.35.0
- AGP: 8.9.1
- Gradle: 8.12
- current app source/target compatibility: Java 11
- `share_plus 10.1.4` resolved successfully on the actual CI toolchain
- newer major versions require newer Flutter/Android toolchains and are intentionally not used

No Toolchain upgrade is allowed unless exact Android evidence proves it is necessary.

## Documentation Lane
Branch: `docs/current-state-backup-active`
Tracks Product in parallel. Keep unmerged until Product settles; final-sync onto resulting main, refresh evidence, exact-head docs CI, then safe merge.

## Automation
Issue #19 remains open because Platform-level required status checks are not writable through the connected GitHub tooling.

Merge contract:
`exact current head + exact-head CI Green + exact-head Android Green for product + live mergeability + expected_head_sha + post-main proof`

## Next Actions
1. Read final CI and Android results on `8057eca7...`.
2. If both Green, mark PR #68 Ready.
3. Fresh-read exact head and live mergeability.
4. Merge with `expected_head_sha=8057eca7...` only if there is no drift.
5. Verify resulting main with Fast CI + Android.
6. Final-sync/merge this Docs lane.
7. Fresh-audit Restore/Import as a separate future slice; do not reuse Backup merge evidence for it.

## Trigger
`ادامه یادنگار`

## Owner Report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
