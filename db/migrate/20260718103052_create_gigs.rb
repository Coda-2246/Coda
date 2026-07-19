class CreateGigs < ActiveRecord::Migration[8.1]
  def change
    create_table :gigs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :venue
      t.string :city
      t.string :country_code
      t.date :start_date
      t.date :end_date
      t.decimal :fee_amount, precision: 12, scale: 2
      t.string :fee_currency
      t.integer :status

      t.timestamps
    end
  end
end
