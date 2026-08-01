class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :gigs, dependent: :destroy
  has_many :entries, dependent: :destroy

  has_many :tax_adviser_conversations, dependent: :destroy
  has_many :tax_adviser_messages, dependent: :destroy
end
