# Simple Wallet Transactional API

This project is a Wallet Transactional API built with Ruby on Rails and PostgreSQL. It provides a generic wallet solution for money movement between different entities such as User, Stock, Team, etc. Each entity has its own defined "wallet" to which we can transfer money or withdraw.

## Features

- Wallet transactions between entities (User, Stock, Team, etc.)
- Database transactions to comply with ACID standards
- Simple Sign In
- LatestStockPrice library for fetching stock prices

## API Endpoints

- `POST /api/v1/sign_in` - Sign in
- `DELETE /api/v1/sign_out` - Sign out
- `POST /api/v1/transactions/:wallet_id/transfer` - Transfer money from one wallet to another
- `POST /api/v1/transactions/:wallet_id/withdraw` - Simple Withdraw money from a wallet
- `POST /api/v1/transactions/:wallet_id/topup` - Top up a wallet
- `GET /api/v1/stocks/price` - Get the price of a specific stock
- `GET /api/v1/stocks/prices` - Get the prices of multiple stocks
- `GET /api/v1/stocks/price_all` - Get the prices of all stocks

## Setup

### Prerequisites

- Ruby 3.0.0
- Rails 7.0.0
- PostgreSQL

### Installation

1. Clone the repository `git clone https://github.com/muhammadtaufan/wallet-app.git`
2. Run `bundle install` to install dependencies
3. Copy the `.env.sample` file to a new file named `.env` and fill in the necessary environment variables
4. Run `source .env` to load the environment variables
5. Run `rails db:create db:migrate db:seed` to setup the database
6. Run `rails server` to start the server

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
