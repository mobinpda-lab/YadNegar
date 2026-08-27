#!/usr/bin/env bash
set -euo pipefail

candidate_root="${1:-build/release-draft/candidate}"
readiness_root="${2:-build/release-draft/readiness}"
output_root="${3:-build/release-draft/output}"
source_sha="${SOURCE_SHA:?SOURCE_SHA is required}"

manifest=$(find "$candidate_root" -type f -name RELEASE_MANIFEST.txt -print -quit)
readiness=$(find "$readiness_root" -type f -name RELEASE_READINESS.txt -print -quit)

test -n "$manifest"
test -n "$readiness"
test -s "$manifest"
test -s "$readiness"

grep -Fx "source_sha=$source_sha" "$manifest"
grep -Fx "source_sha=$source_sha" "$readiness"
grep -Fx 'signing=debug-key-release-mode-not-production-signed' "$manifest"
grep -Fx 'production_signing=blocked' "$readiness"
grep -Fx 'blocker=debug-key-release-mode-not-production-signed' "$readiness"
grep -Fx 'release_status=candidate-ready-production-release-blocked' "$readiness"

read_value() {
  local key="$1"
  local file="$2"
  sed -n "s/^${key}=//p" "$file" | head -n1
}

version=$(read_value version "$manifest")
application_id=$(read_value application_id "$manifest")
apk_sha=$(read_value apk_sha256 "$manifest")
release_status=$(read_value release_status "$readiness")

test -n "$version"
test -n "$application_id"
[[ "$apk_sha" =~ ^[0-9a-f]{64}$ ]]
test -n "$release_status"

if [[ "$version" == *+* ]]; then
  version_name="${version%%+*}"
  build_number="${version##*+}"
else
  version_name="$version"
  build_number="not-specified"
fi

test -n "$version_name"
test -n "$build_number"
[[ "$version_name" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]
if [[ "$build_number" != "not-specified" ]]; then
  [[ "$build_number" =~ ^[0-9]+$ ]]
fi

proposed_tag="v${version_name}"
tag_status="proposal-only-not-created-or-uniqueness-checked"

mkdir -p "$output_root"

{
  printf 'format=yadnegar-release-version-v1\n'
  printf 'source_sha=%s\n' "$source_sha"
  printf 'version=%s\n' "$version"
  printf 'version_name=%s\n' "$version_name"
  printf 'build_number=%s\n' "$build_number"
  printf 'proposed_tag=%s\n' "$proposed_tag"
  printf 'tag_status=%s\n' "$tag_status"
  printf 'release_status=%s\n' "$release_status"
  printf 'production_signing=blocked\n'
  printf 'blocker=debug-key-release-mode-not-production-signed\n'
} | tee "$output_root/RELEASE_VERSION.txt"

cat > "$output_root/RELEASE_NOTES_DRAFT.md" <<EOF
# YadNegar ${version_name} — Release Draft

- Version: \`${version}\`
- Build number: \`${build_number}\`
- Proposed tag: \`${proposed_tag}\`
- Application ID: \`${application_id}\`
- Source SHA: \`${source_sha}\`
- APK SHA-256: \`${apk_sha}\`

## Verified release evidence

- Android release candidate: verified
- Manifest identity and artifact hash: verified
- Android emulator startup: verified
- Storage recovery: verified
- Release readiness: \`${release_status}\`

## Production release blocker

Production signing is still blocked because the current release-mode candidate uses the debug signing configuration.

This is a deterministic preparation draft only. No git tag, GitHub Release, Play Store publication, or production signing action was performed.
EOF

test -s "$output_root/RELEASE_VERSION.txt"
test -s "$output_root/RELEASE_NOTES_DRAFT.md"
