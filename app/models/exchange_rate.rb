class ExchangeRate < ApplicationRecord
  validates :base_currency, :target_currency, :rate, :rate_date, presence: true
end
