class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true
  self.locking_column = :lock_version

  has_many :outgoing_transactions, class_name: "Transaction", foreign_key: "source_wallet_id"
  has_many :incoming_transactions, class_name: "Transaction", foreign_key: "destination_wallet_id"

  def calculated_balance
    incoming_sum = incoming_transactions.sum(:amount)
    outgoing_sum = outgoing_transactions.sum(:amount)
    incoming_sum - outgoing_sum
  end

  def balance_matches_transactions
    balance == calculated_balance
  end

  def balance_discrepancy
    balance - calculated_balance
  end
end
