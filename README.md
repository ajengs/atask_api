# ATask API

ATask API is a Ruby on Rails application that manages transactions, wallets, stocks, teams, and users.

## Prerequisites

- Ruby (version specified in `.ruby-version` file)
- Rails
- PostgreSQL

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```
   bundle install
   ```
3. Set up the database:
   ```
   rails db:create db:migrate
   ```
4. Run the test suite:
   ```
   rspec
   ```
5. Start the server:
   ```
   rails server
   ```
6. Access the API at:
   ```
   http://localhost:3000
   ```
7. Seed sample admin user:
   ```
   rails db:seed
   ```

## Latest Stock Price Library
To use the latest stock price library, you need to set the following environment variables:
   ```
   LATEST_STOCK_PRICE_API_KEY
   LATEST_STOCK_PRICE_HOST
   ```
Example usage:
   ```
   client = LatestStockPrice::Client.new()
   price = client.price('NIFTY 50')
   prices = client.prices(['NIFTY 50', 'BAJFINANCEEQN'])
   price_all = client.price_all
   ```

## Assumptions

- All transactions are done in USD
- User, Team, Stock creations should create a wallet with 0 balance by default
- Wallet updates should be done via transactions
- Transaction creation should have a reference to the wallet
- Credit transactions should have destination_wallet_id
- Debit transactions should have source_wallet_id
- Transfer transactions should have source_wallet_id and destination_wallet_id
- Transaction amount should be positive
- Transaction amount should be less than or equal to the wallet balance
- Transaction will update the wallet balance
- Transaction should have a reference to the user who created the transaction

## Resources

- [API Documentation](https://documenter.getpostman.com/view/34866725/2sAXjDeafm)
