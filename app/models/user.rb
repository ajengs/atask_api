require "digest"

class User < ApplicationRecord
  has_one :wallet, as: :account
  has_many :auth_tokens
  has_many :transactions

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?

  after_create :create_default_wallet

  private

  def create_default_wallet
    create_wallet(balance: 0)
  end
end
