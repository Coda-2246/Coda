class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :gig, optional: true

  attribute :status, :integer, default: 0

  enum :kind,     { income: 0, expense: 1 }
  enum :status,   { draft: 0, confirmed: 1 }
  enum :category, { travel: 0, accommodation: 1, equipment: 2, fees: 3, meals: 4, other: 5 }

  validates :amount, :currency, :entry_date, :kind, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
