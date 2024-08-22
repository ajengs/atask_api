class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :destination_wallet, class_name: "Wallet", optional: true

  validates :transaction_type, presence: true
  validates :transaction_type,
    inclusion: { in: %w[credit debit transfer],
      message: "%{value} is not a valid transaction type" }
  validates :amount, numericality: { greater_than: 0, message: "must be positive" }
  validate :validate_wallet_requirements
  validate :validate_sufficient_balance

  after_create :update_wallet_balances

  private

  def validate_wallet_requirements
    case transaction_type
    when "credit"
      errors.add(:destination_wallet,
        "must be present for credit transactions") if destination_wallet.nil?
    when "debit"
      errors.add(:source_wallet, "must be present for debit transactions") if source_wallet.nil?
    when "transfer"
      errors.add(:source_wallet, "must be present for transfer transactions") if source_wallet.nil?
      errors.add(:destination_wallet,
        "must be present for transfer transactions") if destination_wallet.nil?
    end
  end

  def validate_sufficient_balance
    case transaction_type
    when "debit", "transfer"
      if source_wallet && amount > source_wallet.balance
        errors.add(:amount, "exceeds available balance in the source wallet")
      end
    end
  end

  def update_wallet_balances
    ActiveRecord::Base.transaction do
      case transaction_type
      when "credit"
        destination_wallet.increment!(:balance, amount)
      when "debit"
        source_wallet.decrement!(:balance, amount)
      when "transfer"
        source_wallet.decrement!(:balance, amount)
        destination_wallet.increment!(:balance, amount)
      end
    end
  end
end
