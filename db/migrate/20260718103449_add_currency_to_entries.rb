class AddCurrencyToEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :entries, :currency, :string
  end
end
