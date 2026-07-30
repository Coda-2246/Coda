class TaxAdviserConversation < ApplicationRecord
  belongs_to :user

  has_many :tax_adviser_messages,
           dependent: :destroy

  validates :title, presence: true
end
