# OpenBill Admin

Administrative interface for the OpenBill billing system. Manage accounts, transactions, categories, and policies.

## Why OpenBill

- **Proven in Production**: Battle-tested for 10+ years, with tens of billions of dollars processed through this accounting core.
- **Financial Architecture**: Categories model a chart of accounts (including hierarchical taxonomy at domain level), and policies enforce strict transfer routes between categories and accounts.

## Requirements

### Recommended workflow (Docker + dip)

- Docker + Docker Compose
- Ruby 3.4+ with Bundler (to run `./bin/dip` wrapper)

### Native fallback workflow

- Ruby 3.4+
- PostgreSQL 14+
- Node.js 20+ (CI uses npm; local workflow uses yarn)

## Quick Start (Docker, recommended)

The project supports local Docker development via [`bibendi/dip`](https://github.com/bibendi/dip).

```bash
bundle install
./bin/dip provision
./bin/dip server
```

App is available at `http://localhost:3000` (or `http://localhost:${PORT}` when `PORT` is set).

### Common dip commands

```bash
./bin/dip shell                              # shell in app container
./bin/dip rails db:migrate                   # run migrations
./bin/dip rake openbill_core:verify_contract # verify integration contract
./bin/dip test                               # full CI-like test flow in container
./bin/dip down                               # stop containers
```

## Command Reference (make vs dip)

Use `dip` for day-to-day local development. Use `make` for CI parity and image workflows.

| Goal | Command |
|---|---|
| Install native dependencies | `make setup` |
| Run static/runtime checks | `make lint` |
| Run full CI-like test flow | `make test` |
| Build production assets | `make build` |
| Build Docker image locally | `make image IMAGE_TAG=local` |
| Provision Docker dev env | `./bin/dip provision` |
| Start app in Docker | `./bin/dip server` |
| Run full CI-like test flow in Docker | `./bin/dip test` |
| Run RSpec only in Docker | `./bin/dip rspec` |
| Verify Openbill-Core DB contract in Docker | `./bin/dip rake openbill_core:verify_contract` |

## CI and GHCR

CI runs on every PR and on pushes to `master`/`main`:

- `make lint`
- `make test`
- `make image` (build-only check, without push)

Docker image publication to GHCR is handled by `.github/workflows/release.yml` and runs only for git tags matching `v*`.
Published image tags are predictable and include:

- `vX.Y.Z`
- `vX.Y`
- `vX`
- `latest` (updated only on release tags)

## Native Setup (fallback)

### Install dependencies

```bash
bundle install
yarn install --frozen-lockfile || yarn install
```

### Configure environment

Create a `.env` file with the following variables:

```
DATABASE_HOST=localhost
DATABASE_NAME=openbill_development
DATABASE_NAME_TEST=openbill_test
DATABASE_USER=postgres
DATABASE_PASS=postgres
DATABASE_POOL=5
SECRET_KEY_BASE=your_secret_key_base
```

Generate a secret key base:

```bash
bundle exec rails secret
```

`RACK_PASSWORD` is required in production only.

### Set up databases

```bash
bundle exec rails db:create db:migrate
bundle exec rails db:create RAILS_ENV=test
bundle exec rails db:migrate RAILS_ENV=test
```

### Run the server

```bash
bundle exec rails server
```

App is available at `http://localhost:3000`.

## Database Structure

OpenBill Admin works with the following main entities:

- **Accounts** — financial accounts that track balances
- **Categories** — chart of accounts for organizing accounts
- **Transactions** — money movement between accounts
- **Policies** — rules defining permitted transactions between accounts/categories

## Openbill-core Integration

OpenBill Admin integrates with [`openbill-core`](https://github.com/openbill-service/openbill-core) directly through PostgreSQL (no API/client layer).

- Integration contract and compatibility rules: [`docs/openbill-core-integration.md`](docs/openbill-core-integration.md)
- Verify the contract (native):

```bash
bundle exec rake openbill_core:verify_contract
```

- Verify the contract (Docker):

```bash
./bin/dip rake openbill_core:verify_contract
```

## Authentication

The application is protected with `rack_password` middleware in production. Use the password from the `RACK_PASSWORD` environment variable to access the app.

## Deploy

Deployment uses [Kamal](https://kamal-deploy.org/):

```bash
bin/kamal deploy
```

## For Developers

Architecture decisions and developer notes: [DEVELOPERS.md](DEVELOPERS.md)

## License

This project is licensed under the MIT License.
