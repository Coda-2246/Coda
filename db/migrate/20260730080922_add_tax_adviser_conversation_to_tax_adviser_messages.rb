class AddTaxAdviserConversationToTaxAdviserMessages < ActiveRecord::Migration[8.1]
  def change
    add_reference :tax_adviser_messages,
                  :tax_adviser_conversation,
                  foreign_key: true,
                  null: true
  end
end
