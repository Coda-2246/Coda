class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gig, null: true, foreign_key: true
      t.integer :kind
      t.string :description
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :amount_home, precision: 12, scale: 2
      t.decimal :fx_rate, precision: 18, scale: 8
      t.date :entry_date
      t.string :country_code
      t.integer :category
      t.integer :status
      t.jsonb :parsed_data

      t.timestamps
    end
  end
end
