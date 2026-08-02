# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Coda is a Rails 8 app (generated from lewagon/rails-templates) for cross-border freelancers to track gigs,
income, and expenses across countries and currencies, with an LLM-backed receipt extractor and tax adviser
chat. Database is PostgreSQL. Frontend is server-rendered ERB + Bootstrap 5 + Hotwire (Turbo/Stimulus) +
simple_form — no SPA framework, no JSON API.

## Commands

```bash
bin/setup              # bundle install, db:prepare, clear logs/tmp; then starts the server
bin/setup --skip-server # same, without starting the server
bin/dev                 # start the Rails server (bin/rails server)

bin/rails db:migrate
bin/rails db:seed       # replants demo data — see db/seeds.rb (one demo user, gigs, entries, FX rates)

bin/rails test                              # full test suite
bin/rails test test/models/entry_test.rb    # single file
bin/rails test test/models/entry_test.rb:12 # single test at line 12

bin/rubocop              # style (rubocop-rails-omakase, see .rubocop.yml for overrides)
bin/brakeman              # static security analysis
bin/bundler-audit         # gem vulnerability audit
bin/importmap audit       # JS dependency audit

bin/ci                    # runs the full CI sequence locally (config/ci.rb): setup, rubocop, audits,
                           # brakeman, test suite, then `db:seed:replant` against RAILS_ENV=test
```

Note: `test/fixtures/*.yml` is empty and most test files are still stubs (`# test "the truth" do`).
There's no fixture data to rely on — build records directly in tests (or via `bin/rails runner` for
one-off verification), the way `db/seeds.rb` does.

Two custom rake tasks (`lib/tasks/*.rake`):
```bash
bin/rails exchange_rates:load             # loads exchange_rates.json into the exchange_rates table
bin/rails entries:backfill_home_currency  # recomputes amount_home/fx_rate for all entries
```

## Error handling

Never surface a raw exception message to the user (flash, redirect, rendered page) — it can leak internal
details (library internals, API error text, model names). Log the real exception server-side
(`Rails.logger.error`) and raise/display a generic, user-safe message instead. This is established in
`EntryExtractor#call` and `TaxAdviser#call`, both of which rescue `RubyLLM::Error` and friends, log the
original error, and raise their own domain exception (`ExtractionFailed`, `AdviserFailed`) with a fixed
generic message — controllers then render that generic message as-is, never `e.message` from the underlying
library error.

## Architecture

### Company is the source of truth for currency/locale, not User

`User` (Devise: database_authenticatable, registerable, recoverable, rememberable, validatable — no
confirmable/lockable) holds only auth fields. A `Company` (`has_one`/`belongs_to`, one per user, enforced by
a unique index on `companies.user_id`) holds `company_name`, `tax_id`, `country_code`, and
`default_currency`. `User#home_currency` is a delegate method (`company&.default_currency`) kept around
because many call sites (`Entry#convert_to_home_currency`, dashboard/gigs/entries views, `TaxAdviser`) still
read `current_user.home_currency` — treat that method as the one true accessor rather than reaching into
`current_user.company` directly in new code, for consistency.

New users are redirected to `edit_company_path` after sign-up (`ApplicationController#after_sign_up_path_for`)
since a user is not useful until a company profile exists. `CompaniesController` builds an in-memory
`Company` on `edit`/`update` if the user doesn't have one yet (`current_user.company || current_user.build_company`).

### Currency conversion pipeline

- `exchange_rates.json` is a single-day snapshot (`base_code` + `conversion_rates` hash) in the shape returned
  by exchangerate-api.com-style APIs — one base currency, many targets.
- `ExchangeRateLoader` (`app/services/exchange_rate_loader.rb`) loads that file into the `exchange_rates`
  table (`base_currency`, `target_currency`, `rate`, `rate_date`), one row per target currency, always with
  `base_currency` = whatever `base_code` was in the JSON.
- `ExchangeRate.rate_for(base:, target:, on:)` looks up a rate for a given date, preferring the latest rate
  dated on/before `on`, then falling back to the closest rate available at all (so entries dated before any
  loaded rate still convert, using the nearest data available rather than staying "pending" — this is a
  deliberate accuracy/completeness tradeoff, not a bug). It also tries the inverse pairing and reciprocates
  the rate if no direct row exists, since only one base currency's rates are ever loaded at a time.
- `Entry#convert_to_home_currency` (a `before_save` callback, gated on amount/currency/entry_date having
  changed) queries `rate_for(base: user's default currency, target: entry.currency, ...)` and divides:
  `amount_home = amount / rate`. If no rate can be resolved at all, `amount_home` stays `nil` and views
  render it as "pending" — check `entries/show.html.erb` and `dashboard/show.html.erb` for that convention.
- When adding new exchange-rate-consuming code, remember rates are directional and the loader only ever
  populates one base currency — don't assume a row exists for every (base, target) pair.

### Entries always belong to a gig

`Entry` has `validates :gig, presence: true` — there's no concept of a gig-less entry at the model layer,
even though the UI/seed data conversationally frame some entries as "independent business expenses." If you
need to seed or create an entry with no natural gig, attach it to the temporally closest existing gig rather
than passing `gig: nil` (see `db/seeds.rb` for the established pattern) or you'll hit `RecordInvalid`.

`Entry::CURRENCIES` and `Entry::COUNTRIES` are the canonical currency/country allow-lists used across the
app (`Company`, `Gig`, entry/gig forms, `EntryExtractionSchema`) — extend these rather than inlining new
lists elsewhere.

### New-entry flow: manual vs. document upload

`entries/_new_entry_modal` is a shared partial rendered on several pages (entries index, dashboard, gig show,
home) offering two paths from one Bootstrap modal: "Enter manually" links to `new_entry_path`, or upload a
receipt/invoice via `extract_entries_path` (`EntriesController#extract`). The partial takes an optional
`gig_id` local so it can be pre-scoped to a gig on the gig show page (passed through to both the manual link
and as a hidden field on the upload form) — pass `gig_id` when rendering it from a gig-scoped page.

`EntriesController#extract` runs the uploaded file through `EntryExtractor`, which sends it to Claude via
`RubyLLM` constrained to `EntryExtractionSchema` (a `RubyLLM::Schema`), attaches the original file as the
entry's `receipt` (Active Storage), and redirects to `edit_entry_path` for the user to review/confirm before
it's saved as `confirmed`. Anywhere a "new entry" button/link exists, it should trigger this modal rather
than linking straight to `new_entry_path`, so users always see the upload option.

### Tax adviser

`TaxAdviserConversation` has many `TaxAdviserMessage`s (question/answer pairs). `TaxAdviserController#create`
reuses an existing untitled/empty conversation if one exists rather than always creating a new one, and
titles a conversation from its first question. `TaxAdviser` (service) builds one prompt per question
containing the user's entire gigs/entries data (converted amounts, not raw) and free-text home currency —
there's no RAG/chunking, the whole ledger goes in the prompt every time.

### Dashboard

`DashboardController#show` scopes by year (`Entry.for_year`) using `EXTRACT(YEAR FROM entry_date)` for the
year picker, and reports `@totals_by_country` grouped by `(country_code, kind)`. All money figures displayed
anywhere in the app are `amount_home` (or derived from it, e.g. `Gig#net`), never the raw multi-currency
`amount` — the `money(amount, currency)` helper (`ApplicationHelper`) just formats, it doesn't convert.
