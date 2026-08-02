class ExchangeRateLoader
  DEFAULT_FILE = Rails.root.join("exchange_rates.json")

  def initialize(file_path = DEFAULT_FILE)
    @file_path = file_path
  end

  def call
    data = JSON.parse(File.read(file_path))
    base_currency = data["base_code"]
    rate_date = Date.current

    data["conversion_rates"].each do |target_currency, rate|
      ExchangeRate.find_or_initialize_by(
        base_currency: base_currency,
        target_currency: target_currency,
        rate_date: rate_date
      ).update!(rate: rate)
    end
  end

  private

  attr_reader :file_path
end
