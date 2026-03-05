# OpenBill Admin: Autonomous Upgrade Runbook (Rails + Ruby + Clean Importmap)

Статус: executable plan (agent-first, no HITL)
Дата: 2026-03-05

## 1. Target State

- Rails: `8.1.2`
- Ruby:
  - primary: `4.0.1`
  - fallback: `3.4.latest` (если есть несовместимые гем-блокеры в окне релиза)
- JS runtime: только `importmap` + `app/javascript/*`
- Legacy stack must be removed:
  - `app/javascripts/*`
  - `turbolinks:*` events
  - runtime CDN `<script>` in head/layout
  - `rails-assets.*` gems

## 2. Operating Mode (No Human-In-The-Loop)

Агенты выполняют все фазы автономно.

- Никаких ручных approval/checkpoint.
- Никакого rollback на старый runtime: выкладка greenfield, далее hotfix-only.
- Если этап не проходит, агент сам фиксит и повторяет.
- Лимит попыток на один шаг: 3.
- После 3 неуспешных попыток: агент создает `output/UPGRADE_BLOCKERS.md`, продолжает следующими шагами, где возможно.

## 3. Repository Facts Used By Plan

- Rails уже на `8.0.2`.
- Ruby version drift:
  - `.ruby-version = 3.4.2`
  - `Dockerfile ARG RUBY_VERSION=3.4.1`
  - `mise.toml ruby = 3.4.8`
- Mixed JS stack:
  - importmap есть, но `app/javascript/*` отсутствует
  - legacy JS в `app/javascripts/*.coffee|js`
  - legacy `turbolinks:load` handlers
- Critical legacy deps:
  - `rails-assets.*`
  - `virtus`

## 4. Global Agent Rules

Перед каждой фазой:

```bash
set -euo pipefail
export DISABLE_SPRING=1
export BUNDLE_JOBS=4
export BUNDLE_RETRY=3
```

Обязательные артефакты после каждой фазы:

- `output/phase-N-report.md` с:
  - что изменено
  - какие команды запускались
  - что прошло/что не прошло
  - список оставшихся рисков

## 5. Phase Map

- Phase 0: preflight + baseline stabilization
- Phase 1: CI + test runtime normalization
- Phase 2: clean importmap migration
- Phase 3: Rails `8.0.2 -> 8.1.2`
- Phase 4: Ruby path (`virtus` removal + Ruby bump)
- Phase 5: greenfield release cutover (no rollback)

---

## 6. Detailed Execution Plan

## Phase 0 — Preflight And Baseline

### Objective
Сделать окружение и baseline повторяемыми.

### Actions

1. Синхронизировать рабочую Ruby baseline на `3.4.8` до Rails upgrade:
- `.ruby-version -> 3.4.8`
- `Dockerfile ARG RUBY_VERSION -> 3.4.8`
- `mise.toml ruby -> 3.4.8` (уже так, проверить)

2. Привести bundler к lockfile версии:

```bash
gem install bundler -v 2.6.2
bundle _2.6.2_ install
```

3. Зафиксировать baseline-диагностику:

```bash
bundle _2.6.2_ exec rails about
bundle _2.6.2_ exec rails zeitwerk:check
bundle _2.6.2_ exec rspec || true
bundle _2.6.2_ exec brakeman --no-pager || true
bin/importmap audit || true
```

4. Сохранить результаты в `output/phase-0-report.md`.

### Exit Criteria

- `bundle install` проходит.
- `rails about` и `zeitwerk:check` проходят.
- baseline проблемы зафиксированы в отчете.

---

## Phase 1 — CI And Test Runtime Normalization

### Objective
Сделать CI валидным для реального test stack (RSpec), без ручных действий.

### Actions

1. Обновить CI workflow:
- Заменить `bin/rails db:test:prepare test test:system` на:
  - `bundle exec rails db:prepare`
  - `bundle exec rspec`
- Добавить отдельный шаг `bundle exec rails zeitwerk:check` в test job.

2. Починить явно битые legacy-спеки:
- Если тест ссылается на отсутствующий класс/контроллер:
  - либо переписать на существующий endpoint,
  - либо удалить тест, если фича удалена из production-кода.
- Не оставлять «молчаливо выключенные» тесты.

3. Добавить минимум smoke request/system coverage для критичных маршрутов:
- `/`
- `/accounts`
- `/transactions`
- `/categories`
- `/policies`
- `/invoices`
- `/logs`

4. Прогон:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
bundle exec brakeman --no-pager
bin/importmap audit
```

### Exit Criteria

- CI green на ветке фазы.
- `rspec` green локально и в CI.
- Критичные маршруты покрыты smoke test’ами.

---

## Phase 2 — Migration To Clean Importmap

### Objective
Полностью уйти от смешанного JS-стека.

### Step 2.1 — Create Real Importmap Runtime Structure

1. Создать фактическую структуру:

```bash
mkdir -p app/javascript/{controllers,channels,elements,helpers,legacy}
```

2. Создать `app/javascript/application.js` как единый runtime entrypoint.
3. Либо создать нужные каталоги под `pin_all_from`, либо удалить неиспользуемые `pin_all_from` в `config/importmap.rb`.

### Step 2.2 — Migrate Legacy JS Code

1. Перенести код из:
- `app/javascripts/application.js.coffee`
- `app/javascripts/pickers.js`

в ES modules под `app/javascript/legacy/*`.

2. Заменить события:
- `turbolinks:load -> turbo:load`

3. Перенести init логики:
- nprogress
- select2 setup
- date/datetime picker hooks

### Step 2.3 — Replace rails-assets Packages

Сначала составить карту соответствий в `output/phase-2-asset-map.md`:

- `rails-assets-tether` -> remove (для Bootstrap 5 не нужен)
- `rails-assets-select2` -> pin/import npm package via importmap + CSS import
- `rails-assets-better-dom` + `better-*` -> удалить, заменить на минимальный native JS validation/UX слой

После карты заменить зависимости:

1. Удалить `rails-assets.*` из Gemfile.
2. Выполнить `bundle update`.
3. Пиновать JS-пакеты importmap:

```bash
bin/importmap pin jquery --download
bin/importmap pin nprogress --download
bin/importmap pin select2 --download
bin/importmap pin @ungap/custom-elements --download
```

4. Удалить runtime CDN scripts из `app/views/application/_head.slim`.

### Step 2.4 — Remove Legacy Runtime Sources

1. Удалить `app/javascripts/*`.
2. Убрать legacy JS references из `config/initializers/assets.rb`, если они остались.
3. Убедиться, что JS грузится только через `javascript_importmap_tags`.

### Validation Commands

```bash
bundle exec rails db:prepare
bin/importmap json
bin/importmap audit
bundle exec rails zeitwerk:check
bundle exec rspec
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

### Exit Criteria

- Нет runtime файлов в `app/javascripts/*`.
- Нет `turbolinks:load` в кодовой базе.
- Нет `rails-assets*` в `Gemfile.lock`.
- Нет runtime JS CDN tags в `head/layout`.
- importmap runtime работает в dev/production.

---

## Phase 3 — Rails 8.1.2 Upgrade

### Objective
Перейти на Rails 8.1.2 с рабочим runtime.

### Actions

1. В `Gemfile` зафиксировать:

```ruby
gem "rails", "~> 8.1.2"
```

2. Обновить:

```bash
bundle update rails
```

3. Обновить application/env configs вручную (без интерактивного HITL):
- добавить `config.load_defaults 8.1` в `config/application.rb`
- заменить устаревшие env keys:
  - `cache_classes` -> `enable_reloading`
  - `serve_static_files` -> `public_file_server.enabled`
- синхронизировать production/test конфиги с Rails 8.1 поведением.

4. Добавить timezone deprecation fix:
- `config.active_support.to_time_preserves_timezone = :zone`

5. Проверить инициализаторы на совместимость.

### Validation Commands

```bash
bundle exec rails about
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
bundle exec brakeman --no-pager
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

### Exit Criteria

- Rails 8.1.2 в lockfile.
- Все валидации green.
- Нет критичных deprecation ошибок в CI.

---

## Phase 4 — Ruby Upgrade Path (Primary/Fallback)

### Objective
Дойти до Ruby `4.0.1` либо корректно завершить на fallback `3.4.latest`.

### Step 4.1 — Remove `virtus` Before Ruby 4

1. Мигрировать классы с `include Virtus.model` на:
- `ActiveModel::Model`
- `ActiveModel::Attributes`

2. Заменить типы:
- `String` -> `:string`
- `Integer` -> `:integer`
- `Date` -> `:date`
- `Array[String]` -> custom type/parser через ActiveModel type
- `VirtusHstore` -> собственный `ActiveModel::Type` для JSON/hash input

3. Удалить `virtus` gem и связанные util-файлы.
4. Прогнать все проверки.

### Step 4.2 — Ruby 4.0.1 Primary Attempt

1. Обновить версии:
- `.ruby-version`
- `Gemfile` (`ruby "4.0.1"`)
- `Dockerfile`
- `Dockerfile.multistage` (если используется в релизе)
- `mise.toml`
- CI ruby version

2. Выполнить:

```bash
bundle update
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
bundle exec brakeman --no-pager
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

### Step 4.3 — Fallback Rule (Automatic, No HITL)

Если после 3 циклов auto-fix остаются блокеры Ruby 4:

- зафиксировать fallback на Ruby `3.4.latest`
- оставить Rails 8.1.2
- сохранить список блокеров и причины в `output/UPGRADE_BLOCKERS.md`
- завершить фазу как successful fallback

### Exit Criteria

- Primary success: Ruby 4.0.1 green everywhere.
- Fallback success: Ruby 3.4.latest + Rails 8.1.2 green everywhere + blockers документированы.

---

## Phase 5 — Greenfield Release Cutover (No Rollback)

### Objective
Выкатка с нуля в новый runtime контур.

### Actions

1. Построить чистый образ и новый runtime environment.
2. Перед cutover выполнить:

```bash
bundle exec rails db:prepare
bundle exec rails zeitwerk:check
bundle exec rspec
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

3. Прогнать smoke по маршрутам:
- `/`
- `/accounts`
- `/transactions`
- `/categories`
- `/policies`
- `/invoices`
- `/logs`

4. Выполнить cutover.
5. 24 часа усиленного мониторинга:
- errors (Bugsnag)
- 5xx
- response time

6. Если критичный дефект:
- не rollback
- hotfix в текущем контуре
- redeploy

### Exit Criteria

- cutover completed
- smoke green post-cutover
- критичных production-инцидентов нет

---

## 7. Final Done Criteria

Инициатива завершена, когда:

- Rails `8.1.2`
- Ruby:
  - primary: `4.0.1`
  - или fallback: `3.4.latest` (с документированными блокерами)
- только clean importmap runtime
- `rails-assets.*` удалены
- CI полностью green
- greenfield deploy выполнен

