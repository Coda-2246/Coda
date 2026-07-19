class CreateExchangeRates < ActiveRecord::Migration[8.1]
  def change
    create_table :exchange_rates do |t|
      t.string :base_currency
      t.string :target_currency
      t.decimal :rate, precision: 18, scale: 8
      t.date :rate_date

      t.timestamps

    end

    add_index :exchange_rates, [:base_currency, :target_currency, :rate_date], unique: true
  end
end
