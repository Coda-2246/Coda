# Coda

**[coda.cx](https://www.coda.cx)**

Coda is a finance tracker built for cross-border freelancers — musicians, consultants,
and touring professionals who earn and spend across multiple countries and currencies.
It replaces the spreadsheet with a single ledger that keeps gigs, income, expenses, and
receipts in one place, converted back to one home currency for a clear picture of what
was actually earned.

## Features

- **Gigs** — log clients, venues, and dates as the anchor for every income and expense
  entry tied to them.
- **Multi-currency tracking** — record amounts in their original currency; Coda converts
  everything to your home currency using historical exchange rates.
- **Receipt extraction** — upload a receipt or invoice and an LLM-backed extractor reads
  the amount, currency, category, and date for you to review and confirm.
- **Dashboard** — income, expenses, and net profit by country and by year.
- **AI tax coach** — a floating chat, available on every page, that delivers real-time
  insights on your taxes, gig profitability, and expenses using your actual data.
- **Company profile** — sets your default currency and country, used throughout the app.

Built with Rails 8, PostgreSQL, Hotwire (Turbo/Stimulus), and Bootstrap 5 — server-rendered,
no SPA framework.

## Running locally

**Prerequisites:** Ruby 3.3.5, PostgreSQL.

1. Clone the repo and install dependencies:
   ```bash
   git clone <repo-url>
   cd Coda
   bundle install
   ```

2. Add an Anthropic API key (powers the receipt extractor and AI tax coach) to a
   `.env` file in the project root:
   ```bash
   echo "ANTHROPIC_API_KEY=sk-ant-..." > .env
   ```

3. Set up the database and seed demo data (one demo user, gigs, entries, exchange rates):
   ```bash
   bin/rails db:prepare
   bin/rails db:seed
   ```

4. Start the server:
   ```bash
   bin/dev
   ```

   Or run `bin/setup` to do steps 1, 3, and 4 in one go (it also clears old logs/tmp files;
   pass `--skip-server` to set up without starting it).

The app runs at `http://localhost:3000`. Log in with the seeded demo account
(`demo@coda.app` / `password`), or sign up for a new one.
