class RemoveCompanyDetailsFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :company_name, :string
    remove_column :users, :tax_id, :string
    remove_column :users, :country_code, :string
    remove_column :users, :home_currency, :string
  end
end
