# YadNegar — Live AI Handoff

## Source of Truth
GitHub Reality مقدم است. قبل از هر Write/Merge وضعیت زنده را Audit کن.
Canonical operating package: `docs/YADNEGAR_PROJECT_OPERATING_PACKAGE.md`.

## Repository
`mobinpda-lab/YadNegar`  
Default branch: `main`  
Current verified main: `1b31899d69d3f1fa98520dcc82a9251a7026cc09`

## Current Product State
Vertical Slice اصلی کامل و روی main یکپارچه است:
`Quick Capture → Persist → Timeline → View/Edit`

روی main اکنون وجود دارد:
- Flutter/Dart + Persian RTL foundation
- unified Fast CI
- Timeline Domain / Repository / real JSON persistence
- QuickCapture / LoadTimeline / EditTimelineItem
- real Quick Capture persist/reload/render
- production-safe app-support persistence
- real item View/Edit
- canonical project docs
- Fast CI coverage for `platform/**`
- real committed Android project foundation
- permanent real APK Build Gate

## Android Build — Integrated
PR #31 final head: `e53572b0a4a24d810de22120de88069ba6ee49c9`.

Before merge:
- `YadNegar CI` Run `33000840296`: success
- `YadNegar Android Build` Run `33000840285`: success

Real artifact from permanent gate:
- `yadnegar-debug-apk`
- id `9618635116`
- 66,096,363 bytes
- digest `sha256:3c48a6dac7b24dfe89a8d3aabeedd7e06cd3227d55ba08abbc54e149458a0728`

PR #31 merged as:
`1b31899d69d3f1fa98520dcc82a9251a7026cc09`.
Issue #28 completed.

Permanent Android Build now has read-only permissions and no self-generation/self-commit behavior.

Post-merge main launched both Fast CI and Android Build for exact main SHA. Check live completion before closing Issue #6.

## Fast CI
PR #30 final head `366e1c9be2461e0aa3a7bfbc9be4931a0e1846f3`; Run `32998392710` success; merged `006e6aae...`.
`platform/**` is now covered by the existing Fast Gate; no duplicate Fast workflow.

Fast Gate:
`flutter pub get → flutter analyze → flutter test`.

Android Gate:
`flutter pub get → flutter build apk --debug → verify → upload artifact`.

## Current Product Lane — PR #34
Issue #33 starts Wave 4 Feature Expansion.

PR #34: `feat(timeline): choose type during Quick Capture`
Head: `3e2713225a068b62b7c66fbe6cc3c1cb6290fdf3`.

Implemented:
- type selection in Quick Capture
- Note/Event/Call/Idea/Activity reuse existing `TimelineItemType`
- Note remains default
- selected type persists through existing QuickCapture contract
- edit dialog uses actual type label
- widget tests for Idea capture and Note default

This lane must be revalidated against Android-enabled main before merge so the new permanent APK Build Gate also covers the product change.

## Docs Lane — PR #32
Current State and Handoff are synchronized in parallel.
After final post-merge main Build evidence, update once more, validate exact head, then merge.

## CI / Ruleset
Issue #6 now represents final promotion/confirmation of proven Android Full Build Gate.

Ruleset `main-protection` id `20952887` still lacks required `YadNegar CI / quality` at platform level.
Issue #19 remains open because current connector has no Ruleset write action.

## Continue
1. Check post-merge main Fast CI + Android Build for SHA `1b31899d...`.
2. Close Issue #6 only if both main paths are actually Green.
3. Revalidate PR #34 against current main and Android Build Gate; fix only real failures.
4. Merge PR #34 only exact-head Green + safe mergeability.
5. Final-sync/validate/merge docs PR #32.
6. Continue Wave 4 independent feature lanes after typed capture.
7. Keep Issue #19 open until real Ruleset write capability exists.

## Automation Reality
Separate hourly YadNegar continuation automation exists but is currently disabled. GitHub CI automation is active.

## Trigger
`ادامه یادنگار`

## Owner report
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
