# OpenBill Admin Upgrade: Multi-Agent Orchestration (No HITL)

Дата: 2026-03-05
Основа: `UPGRADE_PLAN_RAILS_RUBY_IMPORTMAP.md`

## 1) Model

Execution mode:

- Autonomous multi-agent execution.
- No human checkpoints.
- No rollback to legacy runtime.
- Hotfix-only after cutover.

Agents:

- `O` (Orchestrator): dependency owner + integration + final gates.
- `A` (CI/Test): CI normalization, RSpec stabilization, smoke tests.
- `B` (Frontend): clean importmap migration of runtime JS.
- `C` (Domain Refactor): `virtus` removal and model/form compatibility refactor.
- `D` (Release): greenfield cutover and post-cutover monitoring.

## 2) Ownership Boundaries

Single-owner files (to avoid merge conflicts):

- Agent `O` only:
  - `Gemfile`
  - `Gemfile.lock`
  - `.ruby-version`
  - `Dockerfile`
  - `Dockerfile.multistage`
  - `mise.toml`

- Agent `A` only:
  - `.github/workflows/*`
  - `spec/**/*` (except files explicitly owned by `C`)

- Agent `B` only:
  - `app/javascript/**/*`
  - `app/javascripts/**/*` (migration/removal)
  - `config/importmap.rb`
  - `app/views/application/_head.slim`
  - `config/initializers/assets.rb` (JS runtime references only)

- Agent `C` only:
  - `app/forms/**/*`
  - `app/queries/**/*`
  - `app/utils/virtus_hstore.rb` and replacement types
  - `spec/**/*` covering refactored form/query behavior

- Agent `D` only:
  - deployment/cutover scripts/docs
  - `output/*release*`, `output/*cutover*`

Cross-file exception rule:

- Если агенту нужно изменить чужой owned-файл, он пишет patch-request в `output/patch_requests/<agent>.md`.
- Изменение делает `O`.

## 3) Branching Strategy

- Base integration branch: `upgrade/autonomous-rails-ruby-importmap`
- Agent branches:
  - `upgrade/agent-a-ci-tests`
  - `upgrade/agent-b-importmap-runtime`
  - `upgrade/agent-c-virtus-removal`
  - `upgrade/agent-d-cutover`

Merge policy:

- Agents rebase onto integration branch before merge.
- Orchestrator merges only when phase gates pass.

## 4) Wave Plan (Parallel Execution)

## Wave 0 (Serial, Owner: O)

Goal:

- Initialize integration branch and baseline reports.

Actions:

1. Create integration branch.
2. Ensure `output/` structure exists:
   - `output/reports`
   - `output/patch_requests`
   - `output/metrics`
3. Run baseline diagnostics and save `output/reports/phase-0-report.md`.

Gate to Wave 1:

- `bundle install` passes.
- `rails about` and `zeitwerk:check` pass.

## Wave 1 (Parallel: A + B + C)

## A1 (Agent A): CI/Test normalization

Deliverables:

- CI uses RSpec path (`rails db:prepare` + `rspec`).
- `zeitwerk:check` present in CI.
- failing legacy specs repaired or replaced.
- smoke coverage for critical routes added.
- report: `output/reports/agent-a-wave1.md`.

Validation:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
```

## B1 (Agent B): importmap runtime migration (code only)

Deliverables:

- `app/javascript/application.js` created as runtime entry.
- legacy JS moved from `app/javascripts` to `app/javascript/legacy/*`.
- `turbolinks:load` replaced with `turbo:load`.
- runtime CDN scripts removed from head (keep importmap tags).
- `app/javascripts/*` removed.
- report: `output/reports/agent-b-wave1.md`.

Important:

- B does not edit `Gemfile`/`Gemfile.lock`.

Validation:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

## C1 (Agent C): remove `virtus` from app code (code only)

Deliverables:

- `Virtus.model` usages replaced by ActiveModel stack.
- equivalent typing/coercion implemented with ActiveModel types/custom types.
- `VirtusHstore` replacement implemented.
- behavior specs added/updated.
- report: `output/reports/agent-c-wave1.md`.

Important:

- C does not edit `Gemfile`/`Gemfile.lock` in Wave 1.

Validation:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
```

Gate to Wave 2:

- A1, B1, C1 reports exist.
- each branch passes its local validation commands.

## Wave 2 (Serial, Owner: O): Dependency Integration

Goal:

- Consolidate dependency changes after code migrations.

Actions:

1. Merge A1 + B1 + C1 into integration branch.
2. Update dependency set:
   - remove `rails-assets.*`
   - remove `virtus`
3. Install/importmap pin dependencies needed by migrated JS.
4. Regenerate `Gemfile.lock`.
5. Write `output/reports/wave-2-dependencies.md`.

Validation:

```bash
bundle install
bin/importmap json
bin/importmap audit
bundle exec rails zeitwerk:check
bundle exec rspec
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Gate to Wave 3:

- No `rails-assets*` and no `virtus` in lockfile.
- all validation commands green.

## Wave 3 (Serial, Owner: O): Rails Upgrade

Goal:

- `Rails 8.0.2 -> 8.1.2`.

Actions:

1. Pin rails `~> 8.1.2`.
2. `bundle update rails`.
3. Apply config updates:
   - `config.load_defaults 8.1`
   - env key modernizations
   - timezone deprecation fix
4. Save `output/reports/wave-3-rails.md`.

Validation:

```bash
bundle exec rails about
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
bundle exec brakeman --no-pager
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Gate to Wave 4:

- Rails 8.1.2 active and validations green.

## Wave 4 (Serial, Owner: O): Ruby Path (Primary/Fallback)

Goal:

- primary Ruby `4.0.1`, fallback `3.4.latest`.

Actions:

1. Primary attempt:
   - update Ruby versions in all owner files
   - `bundle update`
   - full validation
2. If failed after 3 auto-fix loops:
   - set fallback `3.4.latest`
   - re-run full validation
   - save blockers in `output/UPGRADE_BLOCKERS.md`
3. Save `output/reports/wave-4-ruby.md`.

Validation:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
bundle exec brakeman --no-pager
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Gate to Wave 5:

- primary success on 4.0.1, or fallback success on 3.4.latest.

## Wave 5 (Owner: D + O): Greenfield Cutover

Goal:

- Deploy new runtime without rollback path.

Actions:

1. `D` prepares cutover run docs/scripts and monitoring checklist.
2. `O` executes final pre-cutover validation.
3. `D` executes greenfield cutover.
4. 24h monitoring and hotfix-only response.
5. Save:
   - `output/reports/wave-5-cutover.md`
   - `output/reports/post-cutover-24h.md`

Mandatory smoke after cutover:

- `/`
- `/accounts`
- `/transactions`
- `/categories`
- `/policies`
- `/invoices`
- `/logs`

## 5) Standard Command Pack For Every Agent

```bash
set -euo pipefail
export DISABLE_SPRING=1
bundle install
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
```

If frontend/runtime changed:

```bash
bin/importmap audit
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

## 6) Conflict Resolution Protocol (Autonomous)

1. Agent detects conflict.
2. Agent writes `output/patch_requests/<agent>.md` with:
   - target file
   - minimal diff intent
   - reason
3. Orchestrator applies equivalent change in integration branch.
4. Agent rebases and continues.

## 7) Final Success Criteria

- Rails `8.1.2`.
- Ruby `4.0.1` (or fallback `3.4.latest` with blocker file).
- clean importmap runtime only.
- no `rails-assets.*` and no `virtus`.
- CI green.
- greenfield cutover complete.
