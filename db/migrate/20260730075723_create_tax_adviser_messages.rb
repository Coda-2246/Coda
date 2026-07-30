class CreateTaxAdviserMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :tax_adviser_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
