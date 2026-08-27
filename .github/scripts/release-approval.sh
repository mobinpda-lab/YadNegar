#!/usr/bin/env bash
set -euo pipefail

version_root="${1:-build/release-approval/version}"
readiness_root="${2:-build/release-approval/readiness}"
output_root="${3:-build/release-approval/output}"
source_sha="${SOURCE_SHA:?SOURCE_SHA is required}"

version_file=$(find "$version_root" -type f -name RELEASE_VERSION.txt -print -quit)
readiness_file=$(find "$readiness_root" -type f -name RELEASE_READINESS.txt -print -quit)

test -n "$version_file"
test -n "$readiness_file"
test -s "$version_file"
test -s "$readiness_file"

grep -Fx "source_sha=$source_sha" "$version_file"
grep -Fx "source_sha=$source_sha" "$readiness_file"
grep -Fx 'production_signing=blocked' "$version_file"
grep -Fx 'production_signing=blocked' "$readiness_file"
grep -Fx 'blocker=debug-key-release-mode-not-production-signed' "$version_file"
grep -Fx 'blocker=debug-key-release-mode-not-production-signed' "$readiness_file"
grep -Fx 'release_status=candidate-ready-production-release-blocked' "$readiness_file"
grep -Fx 'tag_status=proposal-only-not-created-or-uniqueness-checked' "$version_file"

read_value() {
  local key="$1"
  local file="$2"
  sed -n "s/^${key}=//p" "$file" | head -n1
}

version=$(read_value version "$version_file")
version_name=$(read_value version_name "$version_file")
build_number=$(read_value build_number "$version_file")
proposed_tag=$(read_value proposed_tag "$version_file")
release_status=$(read_value release_status "$readiness_file")

test -n "$version"
test -n "$version_name"
test -n "$build_number"
test -n "$proposed_tag"
test -n "$release_status"
[[ "$proposed_tag" == "v${version_name}" ]]
[[ "$proposed_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]

set +e
git ls-remote --exit-code --tags origin "refs/tags/${proposed_tag}" >/dev/null 2>&1
tag_lookup_status=$?
set -e

case "$tag_lookup_status" in
  0)
    echo "Proposed tag already exists: ${proposed_tag}" >&2
    exit 1
    ;;
  2)
    tag_availability="available"
    ;;
  *)
    echo "Unable to verify remote tag availability for ${proposed_tag}." >&2
    exit "$tag_lookup_status"
    ;;
esac

approval_state="blocked-production-signing"
rollback_state="pre-release-no-mutation"

mkdir -p "$output_root"

{
  printf 'format=yadnegar-release-approval-v1\n'
  printf 'source_sha=%s\n' "$source_sha"
  printf 'version=%s\n' "$version"
  printf 'version_name=%s\n' "$version_name"
  printf 'build_number=%s\n' "$build_number"
  printf 'proposed_tag=%s\n' "$proposed_tag"
  printf 'tag_availability=%s\n' "$tag_availability"
  printf 'release_status=%s\n' "$release_status"
  printf 'production_signing=blocked\n'
  printf 'blocker=debug-key-release-mode-not-production-signed\n'
  printf 'approval_state=%s\n' "$approval_state"
  printf 'rollback_state=%s\n' "$rollback_state"
  printf 'mutation_performed=none\n'
} | tee "$output_root/RELEASE_APPROVAL.txt"

cat > "$output_root/ROLLBACK_PLAN.md" <<EOF
# YadNegar ${version_name} — Rollback / Approval Plan

## Exact release proposal

- Version: \`${version}\`
- Build number: \`${build_number}\`
- Proposed tag: \`${proposed_tag}\`
- Source SHA: \`${source_sha}\`
- Tag availability: \`${tag_availability}\`

## Current approval state

Production release approval is **blocked** because the release-mode candidate is still signed with the debug signing configuration.

No tag, GitHub Release, store publication, signing mutation, or repository ref mutation was performed by this gate.

## Current rollback posture

Because this pipeline performs no release mutation, the current safe rollback is to stop before publication and preserve the exact-run Candidate, Manifest, Smoke/Recovery, Readiness, Version and Release Notes evidence.

Before any future real publication is approved, the release process must record a verified previous production release/tag/artifact reference as the rollback target. Until that reference exists, no claim of executable production rollback readiness is allowed.
EOF

test -s "$output_root/RELEASE_APPROVAL.txt"
test -s "$output_root/ROLLBACK_PLAN.md"
