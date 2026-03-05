# Developer Notes

## Why not the money type?

We intentionally store money as `amount_cents` + `amount_currency` instead of database `money` type.

Reasons:

- predictable arithmetic and no floating-point surprises;
- portability across environments and adapters;
- explicit control over formatting and currency behavior in application code;
- safe integrations with external APIs that exchange integer minor units.

At the domain layer we still use the `Money` gem (`money-rails`) for calculations and presentation.

## Local Docker workflow

For containerized development use `dip` commands from this repository:

- `./bin/dip provision`
- `./bin/dip server`
- `./bin/dip rspec`

Avoid mixing direct `docker compose` calls into daily flow except troubleshooting.
