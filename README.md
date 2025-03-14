# OpenBill Admin

OpenBill Admin is a Ruby on Rails application that provides an administrative interface for the OpenBill billing system. It allows you to manage accounts, transactions, categories, policies, and invoices.

## Requirements

- Ruby 3.x
- PostgreSQL 9.6+
- Node.js and Yarn (for asset compilation)

## How to Install

### Clone the Repository

```bash
git clone https://github.com/openbill-service/openbill-admin.git
cd openbill-admin
```

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

## License

This project is licensed under the MIT License.
