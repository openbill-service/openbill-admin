# Design: Issue #111 — Stabilization & Critical Fixes

**Date:** 2026-03-06
**Issue:** [#111](https://github.com/openbill-service/openbill-admin/issues/111)
**Scope:** P0 (critical fixes) + P1 (webhook removal) + P5 (smoke tests & docs)

## Context

OpenBill Admin (Rails 8, PostgreSQL, Propshaft/importmap) has several broken endpoints
and dead code from incomplete Sequel-to-ActiveRecord migration. This design covers
stabilization before larger changes (Tailwind in #104, CI in #115).

**Out of scope:** RBAC (cancelled), frontend (#104), CI/CD (#115), openbill-core (#113 done).

## P0: Critical Fixes

### 1. Remove `pending_webhooks` (dead code)

**Problem:** `TransactionsController#pending_webhooks` raises `'todo'`.
`OpenbillTransaction.with_pending_webhooks` raises `'implement'` with commented Sequel code.

**Action:** Delete completely — action, route, scope, view, link.

**Files:**
- `app/controllers/transactions_controller.rb` — remove action and private method
- `app/models/openbill_transaction.rb` — remove `with_pending_webhooks` scope
- `config/routes.rb` — remove `pending_webhooks` route
- `app/views/transactions/index.slim` — remove link
- `app/views/transactions/pending_webhooks.slim` — delete

### 2. Fix `AccountReportsController#account`

**Problem:** `OpenbillAccount params[:account_id]` — Sequel-style call, invalid in AR.

**Action:** Replace with `OpenbillAccount.find(params[:account_id])`.

**File:** `app/controllers/account_reports_controller.rb:50`

### 3. Fix `PoliciesController#create`

**Problem:** Uses undefined variable `policy_form` instead of `policy`.

**Action:** Replace `policy_form` with correct variable in two places.

**File:** `app/controllers/policies_controller.rb:23,28`

### 4. Remove InvoicesController & related code

**Problem:** Controller requires `InvoiceForm` which doesn't exist. Entire invoices
resource is broken.

**Action:** Delete controller, views, routes, nav link, smoke test reference.
Keep `OpenbillInvoice` model (DB table exists, managed by openbill-core).

**Files:**
- `app/controllers/invoices_controller.rb` — delete
- `app/views/invoices/` — delete directory (7 files)
- `config/routes.rb` — remove `resources :invoices`
- `app/views/layouts/_topmenu.slim` — remove nav link
- `spec/requests/smoke_spec.rb` — remove routing test

## P1: Remove Webhook UI Code

**Problem:** Webhook UI code depends on Sequel/Philtre (`WebhooksQuery`), `webhook_presents?`
helper always returns `false`. The feature is non-functional.

**Action:** Remove all webhook UI. Delete `OpenbillWebhookLog` model (admin app doesn't use it).

**Files removed:**
- `app/controllers/logs_controller.rb` — webhook logs index page
- `app/views/logs/` — views directory
- `app/views/accounts/webhook_logs.slim` — account webhook logs view
- `app/views/accounts/_webhooks_table.slim` — partial
- `app/queries/webhooks_query.rb` — Sequel-based query
- `app/queries/webhooks_filter.rb` — filter
- `app/models/openbill_webhook_log.rb` — model

**Files modified:**
- `app/controllers/accounts_controller.rb` — remove `webhook_logs` action + private methods
- `app/controllers/transactions_controller.rb` — remove `notify` action
- `app/models/openbill_transaction.rb` — remove webhook associations, `notify!`, `NOTIFIED_MESSAGE`
- `app/helpers/application_helper.rb` — remove `webhook_presents?`
- `app/helpers/buttons_helper.rb` — remove `notify_button`
- `app/views/transactions/index.slim` — remove "Webhook state" column
- `app/views/transactions/show.slim` — remove notify button
- `app/views/accounts/_header.slim` — remove commented webhook_logs link
- `config/routes.rb` — remove `get :webhook_logs`, `post :notify`, `resources :logs`
- `app/integrations/openbill_core/contract.rb` — remove webhook_logs entry
- `docs/openbill-core-integration.md` — remove webhook references

## P5: Smoke Tests & Documentation

### Smoke Tests

Single `spec/requests/smoke_spec.rb` with request specs for every remaining GET endpoint.

| Controller | Endpoints tested |
|-|-|
| WelcomeController | `GET /` (redirect) |
| AccountsController | `GET /accounts`, `GET /accounts/:id`, `GET /accounts/:id/months` |
| TransactionsController | `GET /transactions` |
| CategoriesController | `GET /categories` |
| PoliciesController | `GET /policies` |

Plus routing spec verifying all core routes.

**Approach:**
- Single spec file `spec/requests/smoke_spec.rb`
- `let!` with direct `create!` for test data (no FactoryBot)
- Transactional fixtures for cleanup (no manual `delete_all`)
- Assertion: `expect(response).to have_http_status(:ok)`
- Runs via existing `make test` in CI

**Known untested (out of scope):**
- `AccountTransactionsController` — uses Sequel/Philtre (separate migration task)
- `AccountReportsController` — requires account with transactions for meaningful test

### Documentation

- Update README: remove references to deleted features (invoices, pending_webhooks)
- Update `docs/openbill-core-integration.md`: remove webhook references

## Implementation Order

1. P0 fixes (removes + fixes) — 4 commits
2. P1 webhook removal — 2 commits
3. P5 smoke tests — 1 commit
4. Documentation updates — 1 commit
5. All in single branch `fix/issue-111-stabilization`, one PR
