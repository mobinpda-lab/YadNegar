# ASF Control Plane Foundation

Machine-readable contract for queue, lease, worker identity, lifecycle state and evidence. GitHub Actions remains the execution fabric; factory state is separated from individual workflow implementations.

Workers must be issue-scoped, lease-protected and idempotent. Self-fix is bounded to three attempts. Production Orchestrator owns merge. L10 is not claimed without E2E evidence.
