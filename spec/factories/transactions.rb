FactoryBot.define do
  factory :transaction do
    user { association :user, email: "admin@example.com" }
    amount { "9.99" }
    transaction_type { "credit" }
    destination_wallet { association :wallet,
      account: create(:user, email: 'destination@example.com') }
    description { "Transaction description" }
  end
end
