class TaxAdviserMessage < ApplicationRecord
  belongs_to :user
  belongs_to :tax_adviser_conversation, optional: true
end
