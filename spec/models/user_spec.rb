require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without an email" do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it "is not valid with a duplicate email" do
      FactoryBot.create(:user, name: "John Doe", email: "john@example.com")
      user = FactoryBot.build(:user, email: "john@example.com")
      expect(user).to_not be_valid
    end
  end

  describe "methods" do
    it "returns the user name" do
      user = FactoryBot.create(:user)
      expect(user.name).to eq("John Doe")
    end

    it "returns the user email" do
      user = FactoryBot.create(:user)
      expect(user.email).to eq("john@example.com")
    end
  end

  describe "after_create" do
    it "creates a default wallet with zero balance" do
      user = FactoryBot.create(:user)
      expect(user.wallet).to be_present
      expect(user.wallet.balance).to eq(0)
      expect(user.wallet.account_type).to eq("User")
      expect(user.wallet.account_id).to eq(user.id)
    end
  end
end
