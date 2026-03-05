# OpenBill Admin

Administrative interface for the OpenBill billing system. Manage accounts, transactions, categories, policies, and invoices.

## Why OpenBill

- **Proven in Production**: Battle-tested for 10+ years, with tens of billions of dollars processed through this accounting core.
- **Financial Architecture**: Categories model a chart of accounts (including hierarchical taxonomy at domain level), and policies enforce strict transfer routes between categories and accounts.

## Requirements

- Ruby 3.4+
- PostgreSQL 14+
- Node.js and Yarn (for CSS compilation only)

## Quick Start (Docker, recommended)

The project supports local Docker development via [`bibendi/dip`](https://github.com/bibendi/dip).

```bash
bundle install
./bin/dip provision
./bin/dip server
```

App will be available at `http://localhost:3000` (or `http://localhost:${PORT}` when `PORT` is set).

### Common dip commands

```bash
./bin/dip shell                              # open shell in container
./bin/dip rails db:migrate                   # run migrations
./bin/dip rake openbill_core:verify_contract # check integration contract
./bin/dip rspec                              # run tests
./bin/dip down                               # stop containers
```

## Native Setup (alternative)

### Install dependencies

```bash
bundle install
yarn install
```

### Configure environment

Create a `.env` file with the following variables:

```
DATABASE_HOST=localhost
DATABASE_NAME=openbill_development
DATABASE_USER=your_database_user
DATABASE_PASS=your_database_password
RACK_PASSWORD=your_admin_password
SECRET_KEY_BASE=your_secret_key_base
```

Generate a secret key base:

```bash
bundle exec rails secret
```

### Set up the database

```bash
bundle exec rails db:create db:migrate
```

### Run the server

```bash
bundle exec rails server
```

The app will be available at http://localhost:3000.

## Database Structure

OpenBill Admin works with the following main entities:

- **Accounts** — financial accounts that track balances
- **Categories** — chart of accounts for organizing accounts
- **Transactions** — money movement between accounts
- **Policies** — rules defining permitted transactions between accounts/categories
- **Invoices** — billing and payment tracking

## Openbill-core Integration

OpenBill Admin integrates with [`openbill-core`](https://github.com/openbill-service/openbill-core) directly through PostgreSQL (no API/client layer).

- Integration contract and compatibility rules: [`docs/openbill-core-integration.md`](docs/openbill-core-integration.md)
- Verify the contract:

```bash
bundle exec rake openbill_core:verify_contract
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
