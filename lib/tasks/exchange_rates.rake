namespace :exchange_rates do
  desc "Load exchange rates from exchange_rates.json into the database"
  task load: :environment do
    ExchangeRateLoader.new.call
    puts "Exchange rates loaded for #{Date.current}."
  end
end
