puts "Clearing existing demo data..."

Entry.destroy_all
Gig.destroy_all
ExchangeRate.destroy_all
Company.destroy_all
User.destroy_all

puts "Creating demo user..."

user = User.create!(
  email: "demo@coda.app",
  password: "password"
)

user.create_company!(
  company_name: "Coda Touring Ltd",
  tax_id: "GB123456789",
  country_code: "GB",
  default_currency: "GBP"
)

puts "Creating exchange rates..."

[
  # 2024
  ["GBP", "USD", 1.2658, Date.new(2024, 1, 1)],
  ["GBP", "EUR", 1.1628, Date.new(2024, 1, 1)],
  ["GBP", "CHF", 1.1364, Date.new(2024, 1, 1)],

  # 2025
  ["GBP", "USD", 1.2821, Date.new(2025, 1, 1)],
  ["GBP", "EUR", 1.1905, Date.new(2025, 1, 1)],
  ["GBP", "CHF", 1.1494, Date.new(2025, 1, 1)],

  # 2026
  ["GBP", "USD", 1.2658, Date.new(2026, 1, 1)],
  ["GBP", "EUR", 1.1628, Date.new(2026, 1, 1)],
  ["GBP", "CHF", 1.1236, Date.new(2026, 1, 1)]
].each do |base, target, rate, date|
  ExchangeRate.create!(
    base_currency: base,
    target_currency: target,
    rate: rate,
    rate_date: date
  )
end

puts "Loading current exchange rates from exchange_rates.json..."

ExchangeRateLoader.new.call

puts "Creating gigs..."

# 2024

paris_2024 = user.gigs.create!(
  name: "Paris Opera · Spring Programme",
  venue: "Palais Garnier",
  city: "Paris",
  country_code: "FR",
  start_date: Date.new(2024, 3, 12),
  end_date: Date.new(2024, 3, 24),
  fee_amount: 16_000,
  fee_currency: "EUR",
  status: :completed
)

new_york_2024 = user.gigs.create!(
  name: "New York Arts Festival",
  venue: "Lincoln Center",
  city: "New York",
  country_code: "US",
  start_date: Date.new(2024, 9, 5),
  end_date: Date.new(2024, 9, 15),
  fee_amount: 20_000,
  fee_currency: "USD",
  status: :completed
)

# 2025

berlin_2025 = user.gigs.create!(
  name: "Berlin Philharmonic · Summer Gala",
  venue: "Berliner Philharmonie",
  city: "Berlin",
  country_code: "DE",
  start_date: Date.new(2025, 5, 10),
  end_date: Date.new(2025, 5, 18),
  fee_amount: 20_000,
  fee_currency: "EUR",
  status: :completed
)

zurich_2025 = user.gigs.create!(
  name: "Zurich Opera · Autumn Concert",
  venue: "Opernhaus Zürich",
  city: "Zurich",
  country_code: "CH",
  start_date: Date.new(2025, 9, 2),
  end_date: Date.new(2025, 9, 10),
  fee_amount: 18_000,
  fee_currency: "CHF",
  status: :completed
)

london_2025 = user.gigs.create!(
  name: "Royal Festival Hall · Winter Programme",
  venue: "Royal Festival Hall",
  city: "London",
  country_code: "GB",
  start_date: Date.new(2025, 12, 4),
  end_date: Date.new(2025, 12, 8),
  fee_amount: 8_000,
  fee_currency: "GBP",
  status: :completed
)

# 2026

new_york_2026 = user.gigs.create!(
  name: "Met Opera · Rigoletto",
  venue: "Metropolitan Opera",
  city: "New York",
  country_code: "US",
  start_date: Date.new(2026, 5, 8),
  end_date: Date.new(2026, 5, 28),
  fee_amount: 42_000,
  fee_currency: "USD",
  status: :completed
)

berlin_2026 = user.gigs.create!(
  name: "Berlin Philharmonic · Summer Gala",
  venue: "Berliner Philharmonie",
  city: "Berlin",
  country_code: "DE",
  start_date: Date.new(2026, 7, 14),
  end_date: Date.new(2026, 7, 20),
  fee_amount: 18_000,
  fee_currency: "EUR",
  status: :confirmed
)

london_2026 = user.gigs.create!(
  name: "Royal Albert Hall · Winter Gala",
  venue: "Royal Albert Hall",
  city: "London",
  country_code: "GB",
  start_date: Date.new(2026, 12, 5),
  end_date: Date.new(2026, 12, 7),
  fee_amount: 9_500,
  fee_currency: "GBP",
  status: :upcoming
)

puts "Creating entries..."

entries = [
  # 2024 — Paris
  {
    gig: paris_2024,
    kind: :income,
    description: "Spring programme performance fee",
    amount: 16_000,
    currency: "EUR",
    entry_date: Date.new(2024, 3, 12),
    category: :fees,
    status: :confirmed
  },
  {
    gig: paris_2024,
    kind: :expense,
    description: "Paris accommodation",
    amount: 1_800,
    currency: "EUR",
    entry_date: Date.new(2024, 3, 12),
    category: :accommodation,
    status: :confirmed
  },
  {
    gig: paris_2024,
    kind: :expense,
    description: "Eurostar and local transport",
    amount: 420,
    currency: "EUR",
    entry_date: Date.new(2024, 3, 11),
    category: :travel,
    status: :confirmed
  },
  {
    gig: paris_2024,
    kind: :expense,
    description: "Meals during rehearsals",
    amount: 310,
    currency: "EUR",
    entry_date: Date.new(2024, 3, 18),
    category: :meals,
    status: :confirmed
  },

  # 2024 — New York
  {
    gig: new_york_2024,
    kind: :income,
    description: "Festival performance fee",
    amount: 20_000,
    currency: "USD",
    entry_date: Date.new(2024, 9, 5),
    category: :fees,
    status: :confirmed
  },
  {
    gig: new_york_2024,
    kind: :expense,
    description: "Flights to New York",
    amount: 780,
    currency: "USD",
    entry_date: Date.new(2024, 9, 4),
    category: :travel,
    status: :confirmed
  },
  {
    gig: new_york_2024,
    kind: :expense,
    description: "New York apartment",
    amount: 2_600,
    currency: "USD",
    entry_date: Date.new(2024, 9, 5),
    category: :accommodation,
    status: :confirmed
  },

  # 2025 — Berlin
  {
    gig: berlin_2025,
    kind: :income,
    description: "Summer gala performance fee",
    amount: 20_000,
    currency: "EUR",
    entry_date: Date.new(2025, 5, 10),
    category: :fees,
    status: :confirmed
  },
  {
    gig: berlin_2025,
    kind: :expense,
    description: "Berlin hotel",
    amount: 1_350,
    currency: "EUR",
    entry_date: Date.new(2025, 5, 10),
    category: :accommodation,
    status: :confirmed
  },
  {
    gig: berlin_2025,
    kind: :expense,
    description: "Flights and airport transfer",
    amount: 470,
    currency: "EUR",
    entry_date: Date.new(2025, 5, 9),
    category: :travel,
    status: :confirmed
  },

  # 2025 — Zurich
  {
    gig: zurich_2025,
    kind: :income,
    description: "Autumn concert fee",
    amount: 18_000,
    currency: "CHF",
    entry_date: Date.new(2025, 9, 2),
    category: :fees,
    status: :confirmed
  },
  {
    gig: zurich_2025,
    kind: :expense,
    description: "Zurich accommodation",
    amount: 1_900,
    currency: "CHF",
    entry_date: Date.new(2025, 9, 2),
    category: :accommodation,
    status: :confirmed
  },
  {
    gig: zurich_2025,
    kind: :expense,
    description: "Local rail pass",
    amount: 240,
    currency: "CHF",
    entry_date: Date.new(2025, 9, 3),
    category: :travel,
    status: :confirmed
  },

  # 2025 — London
  {
    gig: london_2025,
    kind: :income,
    description: "Winter programme fee",
    amount: 8_000,
    currency: "GBP",
    entry_date: Date.new(2025, 12, 4),
    category: :fees,
    status: :confirmed
  },
  {
    gig: london_2025,
    kind: :expense,
    description: "Instrument maintenance",
    amount: 620,
    currency: "GBP",
    entry_date: Date.new(2025, 11, 28),
    category: :equipment,
    status: :confirmed
  },

  # 2025 — independent business expense
  {
    gig: berlin_2025,
    kind: :expense,
    description: "Annual accounting software",
    amount: 240,
    currency: "GBP",
    entry_date: Date.new(2025, 1, 15),
    country_code: "GB",
    category: :fees,
    status: :confirmed
  },

  # 2026 — New York
  {
    gig: new_york_2026,
    kind: :income,
    description: "Rigoletto performance fee",
    amount: 42_000,
    currency: "USD",
    entry_date: Date.new(2026, 5, 8),
    category: :fees,
    status: :confirmed
  },
  {
    gig: new_york_2026,
    kind: :expense,
    description: "Flights · LHR to JFK",
    amount: 850,
    currency: "USD",
    entry_date: Date.new(2026, 5, 7),
    category: :travel,
    status: :confirmed
  },
  {
    gig: new_york_2026,
    kind: :expense,
    description: "Apartment · Upper West Side",
    amount: 3_800,
    currency: "USD",
    entry_date: Date.new(2026, 5, 8),
    category: :accommodation,
    status: :confirmed
  },
  {
    gig: new_york_2026,
    kind: :expense,
    description: "Meals and local transport",
    amount: 950,
    currency: "USD",
    entry_date: Date.new(2026, 5, 15),
    category: :meals,
    status: :confirmed
  },

  # 2026 — Berlin
  {
    gig: berlin_2026,
    kind: :income,
    description: "Summer gala performance fee",
    amount: 18_000,
    currency: "EUR",
    entry_date: Date.new(2026, 7, 14),
    category: :fees,
    status: :confirmed
  },
  {
    gig: berlin_2026,
    kind: :expense,
    description: "Berlin hotel",
    amount: 1_250,
    currency: "EUR",
    entry_date: Date.new(2026, 7, 14),
    category: :accommodation,
    status: :confirmed
  },
  {
    gig: berlin_2026,
    kind: :expense,
    description: "Train and airport transfers",
    amount: 320,
    currency: "EUR",
    entry_date: Date.new(2026, 7, 13),
    category: :travel,
    status: :confirmed
  },

  # 2026 — independent business expense
  {
    gig: london_2025,
    kind: :expense,
    description: "Portable recording equipment",
    amount: 780,
    currency: "GBP",
    entry_date: Date.new(2026, 2, 18),
    country_code: "GB",
    category: :equipment,
    status: :confirmed
  }

  # No income entry for the upcoming London gig yet.
]

entries.each do |attributes|
  user.entries.create!(attributes)
end

puts "Seeds complete."
puts "Login: demo@coda.app"
puts "Password: password"
