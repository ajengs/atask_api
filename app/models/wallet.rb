class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true

  has_many :outgoing_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :incoming_transactions, class_name: 'Transaction', foreign_key: 'destination_wallet_id'
end
