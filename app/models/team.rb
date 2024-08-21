class Team < ApplicationRecord
  validates :name, presence: true
  has_one :wallet, as: :account
end
