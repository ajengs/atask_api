class Stock < ApplicationRecord
  validates :symbol, presence: true, uniqueness: true
  validates :company_name, presence: true
  has_one :wallet, as: :account

  after_create :create_default_wallet

  private

  def create_default_wallet
    create_wallet(balance: 0)
  end
end
