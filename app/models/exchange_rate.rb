class ExchangeRate < ApplicationRecord
  validates :base_currency, :target_currency, :rate, :rate_date, presence: true

  def self.rate_for(base:, target:, on:)
    return 1.0 if base == target

    where(base_currency: base, target_currency: target)
      .where(rate_date: ..on)
      .order(rate_date: :desc)
      .first&.rate
  end
end
