class Gig < ApplicationRecord
  belongs_to :user
  has_many :entries, dependent: :nullify

  CURRENCIES = Entry::CURRENCIES

  enum :status, { upcoming: 0, confirmed: 1, completed: 2, cancelled: 3 }

  validates :name, :start_date, presence: true
  validate :end_date_after_start_date

  scope :chronological, -> { order(start_date: :desc) }

  def date_range
    return start_date.to_s if end_date.blank? || end_date == start_date

    "#{start_date} – #{end_date}"
  end

  def total_income
    entries.income.sum(:amount_home)
  end

  def total_expenses
    entries.expense.sum(:amount_home)
  end

  def net
    total_income - total_expenses
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    return if end_date >= start_date

    errors.add(:end_date, "can't be before the start date")
  end
end
