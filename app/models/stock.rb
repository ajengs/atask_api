class Stock < ApplicationRecord
    validates :symbol, presence: true, uniqueness: true
    validates :company_name, presence: true
    has_one :wallet, as: :account
end
