class AddCompanyDetailsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :company_name, :string
    add_column :users, :tax_id, :string
    add_column :users, :country_code, :string
  end
end
