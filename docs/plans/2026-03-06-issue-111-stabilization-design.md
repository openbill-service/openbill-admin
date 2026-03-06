# Design: Issue #111 — Stabilization & Critical Fixes

**Date:** 2026-03-06
**Issue:** [#111](https://github.com/openbill-service/openbill-admin/issues/111)
**Scope:** P0 (critical fixes) + P5 (smoke tests & docs)

## Context

OpenBill Admin (Rails 8, PostgreSQL, Propshaft/importmap) has several broken endpoints
and dead code from incomplete Sequel-to-ActiveRecord migration. This design covers
stabilization before larger changes (Tailwind in #104, CI in #115).

**Out of scope:** RBAC (cancelled), frontend (#104), CI/CD (#115), openbill-core (#113 done).

## P0: Critical Fixes

### 1. Remove `pending_webhooks` (dead code)

**Problem:** `TransactionsController#pending_webhooks` raises `'todo'`.
`OpenbillTransaction.with_pending_webhooks` raises `'implement'` with commented Sequel code.

**Action:** Delete completely — action, route, scope, commented code.

**Files:**
- `app/controllers/transactions_controller.rb` — remove `pending_webhooks_transactions` action
- `app/models/openbill_transaction.rb` — remove `with_pending_webhooks` scope
- `config/routes.rb` — remove `pending_webhooks` route

### 2. Fix `AccountReportsController#account`

**Problem:** `OpenbillAccount params[:account_id]` — invalid syntax (not a method call).

**Action:** Replace with `OpenbillAccount.find(params[:account_id])`.

**File:** `app/controllers/account_reports_controller.rb:50`

### 3. Fix `PoliciesController#create`

**Problem:** Uses undefined variable `policy_form` instead of `policy`.

**Action:** Replace `policy_form` with correct variable.

**File:** `app/controllers/policies_controller.rb:23`

### 4. Remove InvoicesController & related code

**Problem:** Controller requires `InvoiceForm` which doesn't exist. Entire invoices
resource is broken.

**Action:** Delete controller, views, routes, and any references.

**Files:**
- `app/controllers/invoices_controller.rb` — delete
- `app/views/invoices/` — delete directory
- `config/routes.rb` — remove invoices resource

## P5: Smoke Tests & Documentation

### Smoke Tests

Request specs for every remaining controller. Each spec verifies GET endpoints return 200.

| Controller | Endpoints |
|-|-|
| DashboardController | `GET /` |
| AccountsController | `GET /accounts`, `GET /accounts/:id` |
| TransactionsController | `GET /transactions`, `GET /transactions/:id` |
| ServicesController | `GET /services`, `GET /services/:id` |
| PoliciesController | `GET /policies`, `GET /policies/:id` |
| AccountReportsController | `GET /account_reports` |
| WebhooksController | `GET /webhooks` |
| CategoriesController | `GET /categories` |

**Approach:**
- One spec file per controller in `spec/requests/`
- FactoryBot factories for test data
- Assertion: `expect(response).to have_http_status(:ok)`
- Runs via existing `make test` in CI

### Documentation

- Update README: remove references to deleted features (invoices, pending_webhooks)
- Verify setup/run/test commands are accurate

## Implementation Order

1. P0 fixes (removes + fixes) — single branch, one PR
2. P5 smoke tests — can be same or separate PR
3. README updates — included with tests PR
