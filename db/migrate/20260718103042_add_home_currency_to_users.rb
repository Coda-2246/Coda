class AddHomeCurrencyToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :home_currency, :string
  end
end
