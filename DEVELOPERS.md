# Developer Notes

## Documentation Ownership

- `README.md`: onboarding, run/test/build commands, CI/GHCR overview.
- `DEVELOPERS.md`: engineering rationale and team conventions only.
- `docs/openbill-core-integration.md`: DB integration contract with `openbill-core`.

When workflow, CI, or setup commands change, update `README.md` in the same PR.

## Why not the money type?

We intentionally store money as `amount_cents` + `amount_currency` instead of database `money` type.

Reasons:

- predictable arithmetic and no floating-point surprises;
- portability across environments and adapters;
- explicit control over formatting and currency behavior in application code;
- safe integrations with external APIs that exchange integer minor units.

At the domain layer we still use the `Money` gem (`money-rails`) for calculations and presentation.

## Local Workflow Policy

Primary local development workflow is `dip` (Docker-based). Native workflow is fallback-only.

Canonical command references are documented in [`README.md`](README.md).

Avoid mixing direct `docker compose` calls into daily flow except troubleshooting.
