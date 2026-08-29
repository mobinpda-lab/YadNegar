# YadNegar Production Orchestrator

Issue: #169

## Purpose
`YadNegar Production Orchestrator` is the repository-native controller that advances eligible pull requests without bypassing YadNegar's existing quality gates.

## Cadence
- scheduled every 8 minutes with `*/8 * * * *`
- runs immediately after completion of `YadNegar CI`, `YadNegar UI Evidence`, or `YadNegar Android Build`
- can be started manually with `workflow_dispatch`

GitHub scheduled workflows are best-effort, so the 8-minute cron is the requested cadence rather than a real-time guarantee. Gate-completion triggers reduce waiting when Actions finishes between scheduled cycles.

## Safety contract
The orchestrator:
- manages only same-repository PRs targeting `main`
- never force-pushes and never writes product source code
- never bypasses branch protection or repository rulesets
- skips PRs labelled `orchestrator:hold`, `orchestrator:manual`, or `do-not-merge`
- requires the PR base SHA to equal current `main`
- requires `behind=0`
- evaluates workflow runs for the exact PR head SHA
- marks a Draft PR Ready only after exact-head `YadNegar CI` succeeds on current main
- merges at most one PR per run
- uses squash merge with the exact head SHA passed to GitHub's merge endpoint
- re-reads PR head, main SHA, mergeability and behind status immediately before merge
- fails closed if anything changes during evaluation

## Required gates
- docs-only: `YadNegar CI`
- product/code: `YadNegar CI` + complete `YadNegar Android Build`
- UI-affecting: `YadNegar CI` + `YadNegar UI Evidence` + complete `YadNegar Android Build`

`YadNegar Android Build` is considered complete only when the existing workflow itself concludes success, which means its debug APK, release candidate, emulator smoke/storage recovery, release readiness, release draft, and release approval/rollback chain has completed successfully.

## What it deliberately does not do
- create or modify production signing keys or secrets
- publish a Play Store build
- create a real release tag or GitHub Release
- merge two PRs in parallel
- auto-rebase or force-sync a behind branch
- retry failing product tests by mutating code

## Operational labels
- `orchestrator:hold`: temporarily freeze automatic advancement
- `orchestrator:manual`: require manual governance/merge
- `do-not-merge`: existing generic hard stop, if present

The orchestrator creates its two own governance labels if they do not exist.

## Post-main proof
After an orchestrated merge, the repository's existing push-triggered CI and Android workflows provide post-main proof on the new main SHA. The orchestrator does not claim a production release or store publication.
