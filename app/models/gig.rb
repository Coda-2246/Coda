class Gig < ApplicationRecord
  belongs_to :user
  has_many :entries, dependent: :nullify

  enum :status, { planned: 0, confirmed: 1, completed: 2, cancelled: 3 }

  validates :name, :country_code, :start_date, presence: true
end
