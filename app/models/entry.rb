class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :gig, optional: true

  has_one_attached :receipt

  CURRENCIES = %w[EUR GBP USD CHF SEK NOK DKK PLN CZK AUD CAD JPY].freeze
  COUNTRIES = %w[GB DE FR AT US ES IT NL].freeze

  attribute :status, :integer, default: 0

  enum :kind,     { income: 0, expense: 1 }
  enum :status,   { draft: 0, confirmed: 1 }
  enum :category, { travel: 0, accommodation: 1, equipment: 2, fees: 3, meals: 4, other: 5 }

  validates :amount, :currency, :entry_date, :kind, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: CURRENCIES }
  validates :gig, presence: true

  scope :for_year, ->(year) { where(entry_date: Date.new(year).all_year) }

  before_validation :inherit_gig_country, on: :create
  before_save :convert_to_home_currency, if: :fx_inputs_changed?

  private

  def inherit_gig_country
    self.country_code ||= gig&.country_code
  end

  def fx_inputs_changed?
    will_save_change_to_amount? ||
      will_save_change_to_currency? ||
      will_save_change_to_entry_date?
  end

  def convert_to_home_currency
    home = user&.home_currency
    return if home.blank?

    if currency == home
      self.fx_rate = 1.0
      self.amount_home = amount
      return
    end

    rate = ExchangeRate.rate_for(base: home, target: currency, on: entry_date)
    return if rate.nil? # leave amount_home nil; view shows "pending"

    self.fx_rate = rate
    self.amount_home = (amount / rate).round(2)
  end
end
