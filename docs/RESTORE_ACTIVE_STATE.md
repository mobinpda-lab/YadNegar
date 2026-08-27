# YadNegar — Restore Active State

Last updated: 2026-08-27

## Source of Truth
GitHub Reality. This file is a temporary parallel execution note while Restore PR #73 is active. Canonical continuation documents remain unchanged until Product settles.

## Verified Main
`9e31b6e4db22ca5d9a34231eb4205f01027d0655`

Main already includes verified Bismillah, validated Backup, Export, Delete/Undo, Search/Type/Date, occurredAt and crash-recoverable JSON persistence.

## Active Product — PR #73 / Issue #70
Title: `feat(restore): validate and restore Timeline snapshots safely`
Branch: `feature/timeline-restore-import`
Current exact head: `fa8cfb2841eb761a062c8b9bbdd9dfee2bd0e600`
Status: Draft until final exact-head CI + Android proof.

Implemented:
- strict UTF-8 / JSON / schema validation before any primary replacement
- reject malformed, blank, unsupported-schema and duplicate-ID backups before write
- reuse production JSON parser and existing `_writeAll` staged `.tmp` / `.bak` rollback path
- no Domain `TimelineRepository` contract change
- no second parser / serializer / storage
- File Picker only at platform/composition edge
- `file_picker 8.3.7` exact pin
- Persian confirmation and result-specific feedback
- successful Restore reuses `TimelineHome._reload()` and preserves active Search/Type/Date state
- Bismillah, Backup and Export actions preserved

Tests:
- valid real-file restore
- malformed / unsupported / duplicate / blank / invalid UTF-8 rejection with primary unchanged
- confirmation cancellation
- successful reload while active search remains applied
- unsupported-version Persian feedback

Dependency resolution:
- pre-lock head `f04419ee...`: CI `33044782989` success, Analyze clean, 93 tests passed
- Flutter 3.35 resolved `file_picker 8.3.7` and `flutter_plugin_android_lifecycle 2.0.34`
- final lockfile committed on `fa8cfb284...`

Final exact-head gates on `fa8cfb284...`:
- YadNegar CI `33045126480`: success
- YadNegar Android Build `33045126515`: active at last refresh

Pre-lock Green is not valid merge evidence for the final head.

## Merge Contract
`exact current head + exact-head CI Green + exact-head Android Green + live mergeability + expected_head_sha + post-main proof`

## Documentation Plan
After PR #73 merges and post-main proof is Green:
1. structurally sync this docs branch onto resulting main
2. update the three canonical documents with final Restore evidence
3. remove this temporary active-state file or mark it superseded
4. ensure docs-only diff
5. exact-head Fast CI + expected-head merge
6. post-main Fast CI

## Automation
Issue #19 remains open until Platform-level required status enforcement is genuinely writable and verified.
