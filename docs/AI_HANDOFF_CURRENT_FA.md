# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `e2564db524bfcec17770adc28704c1925efcefc8`  
Commit: `platform: bootstrap durable Timeline persistence`

## Integrated Real Software
- Foundation / Persian RTL / Fast CI.
- Timeline Domain + repository contract + real JSON persistence.
- Timeline UI + Quick Capture + LoadTimeline + EditTimelineItem.
- PR #23 merged `329ad83...`: Quick Capture UI → real persist → reload → render. Issue #22 completed.
- PR #26 merged/current main `e2564db...`: production-safe application-support persistence bootstrap. Issue #24 completed.

## Exact Evidence
PR #23 final head `a4bc2ffe...`; run `32996798616`; Resolve dependencies, Analyze, Test: success.
PR #26 final head `84b4a93b...`; run `32997146108`; Resolve dependencies, Analyze, Test: success.

## Active Product Work — PR #27
Issue #25 → PR #27 `feat(timeline): add real View/Edit flow`.
Branch: `feature/timeline-view-edit`.
Current head at this handoff update: `8a6656e30a95e8b63889f103f0bf545a4b5caf48`.
Base: `e2564db...`.

Implemented:
- Timeline item tap contract.
- Persian edit dialog.
- edit through existing `EditTimelineItem` only.
- reload through existing `LoadTimeline`.
- empty-edit feedback.
- production composition injects EditTimelineItem on the same shared repository.
- widget tests cover edit/save/reload/render and empty edit.

Do not merge until exact-current-head CI is completed Green and mergeability is safe.

## Production Persistence
`main()` now uses `getApplicationSupportDirectory()` via compatible `path_provider ^2.1.5`, constructs one `JsonFileTimelineRepository`, and reuses it for application use cases.
No temp/current-directory fake durability. Plugin remains in composition root.

## Docs — PR #3
Canonical documentation branch is being synchronized in parallel. After PR #27 outcome, update current main/CI state again, then exact-head validate and merge #3 if safe.

## Ruleset — Issue #19
`main-protection` id `20952887` is active but still lacks required `YadNegar CI / quality` status enforcement.
Connector supports Ruleset reads only; no fake mutation.
Operational rule: exact-head Green before every merge.

## Vertical Slice
`Quick Capture → Persist → Timeline → View/Edit`

- Capture/Persist/Load/Render: integrated.
- production persistence bootstrap: integrated.
- View/Edit: PR #27 under validation.

## Platform Build
No committed Android/iOS/Desktop platform foundation yet.
No APK/build success may be claimed.
Next after View/Edit/docs integration: real Android platform foundation, then actual `flutter build apk`, then Full Build Gate.

## Automation
GitHub CI automation is active. Ruleset required-status hardening remains blocked by missing write capability.
Separate hourly YadNegar continuation automation exists but is currently disabled.

## Continue
1. Check exact-head Actions for PR #27.
2. Fix same branch if real failure; otherwise merge with expected-head lock.
3. Validate main + Issue #25 closure.
4. Sync and exact-head validate/merge PR #3.
5. Start real Android platform foundation from fresh main.
6. Run real APK build before creating a Full Build Gate.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
