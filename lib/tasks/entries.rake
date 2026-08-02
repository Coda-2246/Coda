namespace :entries do
  desc "Recompute amount_home/fx_rate for all entries using the exchange_rates table"
  task backfill_home_currency: :environment do
    updated = 0
    skipped = 0

    Entry.find_each do |entry|
      entry.send(:convert_to_home_currency)

      if entry.amount_home.nil?
        skipped += 1
        next
      end

      entry.save!(validate: false)
      updated += 1
    end

    puts "Updated #{updated} entries, #{skipped} still pending (no rate available for that date)."
  end
end
