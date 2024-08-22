FactoryBot.define do
  factory :transaction do
    amount { "9.99" }
    transaction_type { "credit" }
    source_wallet { association :wallet, account: create(:user, email: 'source@example.com') }
    destination_wallet { association :wallet,
      account: create(:user, email: 'destination@example.com') }
    description { "Transaction description" }
  end
end
