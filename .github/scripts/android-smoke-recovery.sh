#!/usr/bin/env bash
set -euo pipefail

package="com.mobinpda.lab.yadnegar"
activity=".MainActivity"
evidence="build/android-smoke-evidence"
mkdir -p "$evidence"

capture_evidence() {
  set +e
  adb logcat -d > "$evidence/logcat.txt" 2>&1
  adb logcat -d -b crash > "$evidence/crash-buffer.txt" 2>&1
  adb shell dumpsys activity activities > "$evidence/activities.txt" 2>&1
  adb shell "run-as $package cat files/timeline.json" > "$evidence/recovered-timeline.json" 2>&1
  adb exec-out screencap -p > "$evidence/screenshot.png" 2>/dev/null
}
trap capture_evidence EXIT

adb install -r build/smoke-apk/app-debug.apk
adb shell "run-as $package sh -c 'mkdir -p files'"

seed='{"schemaVersion":2,"items":[{"id":"ci-smoke-1","type":"note","text":"ci-smoke-recovery","createdAt":"2026-08-27T00:00:00.000Z","occurredAt":null,"reminderAt":null}]}'
printf '%s\n' "$seed" | adb shell "run-as $package sh -c 'cat > files/timeline.json'"
adb shell "run-as $package sh -c 'test -s files/timeline.json'"

adb logcat -c
adb shell am force-stop "$package"
adb shell am start -W -n "$package/$activity" | tee "$evidence/first-launch.txt"
sleep 5
adb shell pidof "$package" | tee "$evidence/first-pid.txt"
adb shell dumpsys activity activities | grep -F "$package" > "$evidence/first-activity.txt"
adb shell "run-as $package cat files/timeline.json" | grep -F 'ci-smoke-recovery' > "$evidence/first-storage-marker.txt"

adb shell am force-stop "$package"
adb shell "run-as $package sh -c 'rm -f files/timeline.json.bak files/timeline.json.tmp && mv files/timeline.json files/timeline.json.bak'"
if adb shell "run-as $package sh -c 'test -e files/timeline.json'"; then
  echo "Primary storage unexpectedly remained before recovery." >&2
  exit 1
fi
adb shell "run-as $package sh -c 'test -s files/timeline.json.bak'"

adb shell am start -W -n "$package/$activity" | tee "$evidence/recovery-launch.txt"
sleep 5
adb shell pidof "$package" | tee "$evidence/recovery-pid.txt"
adb shell dumpsys activity activities | grep -F "$package" > "$evidence/recovery-activity.txt"
adb shell "run-as $package sh -c 'test -s files/timeline.json'"
adb shell "run-as $package cat files/timeline.json" | grep -F 'ci-smoke-recovery' > "$evidence/recovered-storage-marker.txt"

if adb shell "run-as $package sh -c 'test -e files/timeline.json.bak'"; then
  echo "Backup staging file was not cleaned after recovery." >&2
  exit 1
fi
if adb shell "run-as $package sh -c 'test -e files/timeline.json.tmp'"; then
  echo "Temporary staging file was not cleaned after recovery." >&2
  exit 1
fi

adb logcat -d -b crash > "$evidence/crash-buffer-final.txt" 2>&1 || true
if grep -Fq "$package" "$evidence/crash-buffer-final.txt"; then
  echo "Crash buffer contains a crash for YadNegar." >&2
  cat "$evidence/crash-buffer-final.txt" >&2
  exit 1
fi

printf 'startup=passed\nrecovery=passed\nstorage_marker=preserved\nstaging_cleanup=passed\n' | tee "$evidence/RESULT.txt"
