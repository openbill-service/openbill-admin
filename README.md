# OpenBill Admin

OpenBill Admin is a Ruby on Rails application that provides an administrative interface for the OpenBill billing system. It allows you to manage accounts, transactions, categories, policies, and invoices.

## Why OpenBill

- **🦸 Proven in Production**: Battle-tested in production for 10+ years, with tens of billions of dollars processed through this accounting core.
- **💰 Financial Architecture**: Categories model a chart of accounts (including hierarchical taxonomy at domain level), and policies enforce strict transfer routes between categories and accounts.

## For Developers

- Developer notes and architecture decisions: [DEVELOPERS.md](DEVELOPERS.md)

## Build, CI, and GHCR

Standard local commands:

```bash
make setup
make lint
make test
make build
make image IMAGE_TAG=local
```

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

## Docker Development (Dip)

`openbill-admin` supports local Docker development via [`bibendi/dip`](https://github.com/bibendi/dip).

### Quick start

```bash
bundle install
./bin/dip provision
./bin/dip server
```

App will be available at `http://localhost:3000` (or `http://localhost:${PORT}` when `PORT` is set).

### Common commands

```bash
./bin/dip shell
./bin/dip rails db:migrate
./bin/dip rake openbill_core:verify_contract
./bin/dip rspec
./bin/dip down
```

### Troubleshooting

```bash
# validate compose syntax
docker compose -f docker-compose.dev.yml config -q

# rebuild app image from scratch
docker compose -f docker-compose.dev.yml build --no-cache app

# reset local postgres volume
docker compose -f docker-compose.dev.yml down -v
```

## Как деплоить

Для деплоя используется `kamal`:

```sh
./bin/kamal deploy
```

Деплоить изменения (инкремент версии + деплой):

```sh
./release
```

## Requirements

- Ruby 3.x
- PostgreSQL 9.6+
- Node.js and Yarn (for asset compilation)

## How to Install

### Install Dependencies

Install the required Ruby gems:

```bash
bundle install
```

Install JavaScript dependencies:

```bash
yarn install
```

### Configure Database Connection

OpenBill Admin uses PostgreSQL. You need to configure your database connection in the `.env` file. Create a copy of the `.env.example` file (if it exists) or create a new `.env` file:

```bash
cp .env.example .env
```

Edit the `.env` file to set the following environment variables:

```
DATABASE_HOST=localhost
DATABASE_NAME=openbill_production
DATABASE_USER=your_database_user
DATABASE_PASS=your_database_password
RACK_PASSWORD=your_admin_password
SECRET_KEY_BASE=your_secret_key_base
```

Generate a secret key base if you don't have one:

```bash
bundle exec rails secret
```

### Set Up the Database

Create and migrate the database:

```bash
bundle exec rails db:create db:migrate
```

## How to Run

### Development Mode

To run the application in development mode:

```bash
bundle exec rails server
```

This will start the application on http://localhost:3000 by default.

### Production Mode

For production environments, we recommend using Puma as the application server.

1. Precompile assets:

```bash
bundle exec rails assets:precompile
```

2. Start the server:

```bash
RAILS_ENV=production bundle exec puma -C config/puma.rb
```

Alternatively, you can use the provided Foreman configuration:

```bash
bundle exec foreman start
```

### Using Docker (Optional)

The project includes configuration for deployment with Kamal, which uses Docker:

1. Build the Docker image:

```bash
bin/kamal setup
```

2. Deploy the application:

```bash
bin/kamal deploy
```

### Authentication

By default, the application is protected with Rack::Password middleware in production. Use the password you set in the `RACK_PASSWORD` environment variable to access the application.

## Database Structure

OpenBill Admin works with the following main entities:

- **Accounts**: Financial accounts that track balances
- **Categories**: For organizing accounts
- **Transactions**: Money movement between accounts
- **Policies**: Rules defining permitted transactions between accounts/categories
- **Invoices**: For billing and payment tracking

## Openbill-core Integration Contract

Openbill Admin is integrated with `openbill-core` through PostgreSQL (no API/client layer).

- Integration contract and compatibility rules: [`docs/openbill-core-integration.md`](docs/openbill-core-integration.md)
- Contract check command:

```bash
bundle exec rake openbill_core:verify_contract
```

## License

This project is licensed under the MIT License.
