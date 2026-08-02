class Company < ApplicationRecord
  belongs_to :user

  COUNTRIES = Entry::COUNTRIES
  CURRENCIES = Entry::CURRENCIES

  validates :company_name, :tax_id, :country_code, :default_currency, presence: true
  validates :country_code, inclusion: { in: COUNTRIES }, allow_blank: true
  validates :default_currency, inclusion: { in: CURRENCIES }, allow_blank: true
end
