# OpenBill Core Integration Contract

This admin app integrates with `openbill-core` directly via PostgreSQL. API/client-based integration is intentionally out of scope.

## Scope

- Integration type: direct DB access
- Access mode: ActiveRecord models prefixed with `openbill_`
- Isolation rule: controller actions should not contain raw policy/account-matching SQL

## Integration Points

Current integration points are concentrated in:

- Models:
  - `OpenbillAccount`
  - `OpenbillCategory`
  - `OpenbillTransaction`
  - `OpenbillPolicy`
- Adapter layer:
  - `OpenbillCore::AccountsRepository`
  - `OpenbillCore::OppositeAccountsByPolicy`
  - `OpenbillCore::Contract`

## Required DB Contract

The admin app requires these tables and minimum columns:

- `openbill_accounts`: `id`, `category_id`, `key`, `amount_cents`, `amount_currency`, `created_at`
- `openbill_categories`: `id`, `name`
- `openbill_transactions`: `id`, `from_account_id`, `to_account_id`, `amount_cents`, `amount_currency`, `key`, `details`, `created_at`
- `openbill_policies`: `id`, `name`, `from_category_id`, `to_category_id`, `from_account_id`, `to_account_id`

Validation command:

```bash
bundle exec rake openbill_core:verify_contract
```

## Compatibility Requirements

- Keep table names in `openbill_*` namespace.
- Keep UUID identities and FK links used by the app (`*_id` columns above).
- Any rename/drop of required columns must be coordinated with admin changes in the same release window.
- Policy matching logic for opposite accounts must stay in adapter/repository layer, not in controllers.

## Operational Notes

- CI runs `openbill_core:verify_contract` before tests.
- If contract check fails, treat it as integration breakage between `openbill-core` and admin.
