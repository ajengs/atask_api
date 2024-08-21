class Team < ApplicationRecord
  validates :name, presence: true
  has_one :wallet, as: :account

  after_create :create_default_wallet

  private

  def create_default_wallet
    create_wallet(balance: 0)
  end
end
