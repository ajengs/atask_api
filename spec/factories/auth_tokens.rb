FactoryBot.define do
  factory :auth_token do
    user { association :user }
  end
end
