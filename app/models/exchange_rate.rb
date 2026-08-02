class ExchangeRate < ApplicationRecord
  validates :base_currency, :target_currency, :rate, :rate_date, presence: true

  def self.rate_for(base:, target:, on:)
    return 1.0 if base == target

    find_rate(base_currency: base, target_currency: target, on: on) ||
      find_rate(base_currency: target, target_currency: base, on: on)&.then { |rate| 1.0 / rate }
  end

  def self.find_rate(base_currency:, target_currency:, on:)
    scope = where(base_currency: base_currency, target_currency: target_currency)

    scope.where(rate_date: ..on).order(rate_date: :desc).first&.rate ||
      scope.order(rate_date: :desc).first&.rate
  end
  private_class_method :find_rate
end
