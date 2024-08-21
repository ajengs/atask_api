require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe "validations" do
    it "is valid with a valid account" do
      account = FactoryBot.create(:user)
      wallet = FactoryBot.build(:wallet, account: account)
      expect(wallet).to be_valid
    end

    it "is not valid without an account" do
      wallet = FactoryBot.build(:wallet, account: nil)
      expect(wallet).to_not be_valid
    end

    it "is not valid without a balance" do
      wallet = FactoryBot.build(:wallet, balance: nil)
      expect(wallet).to_not be_valid
    end
  end

  # describe "callbacks" do
  #   it "creates a wallet when an account is created" do
  #     account = FactoryBot.create(:user)
  #     expect(account.wallet).to be_present
  #   end
  # end

  describe "methods" do
    it "returns the account type" do
      account = FactoryBot.create(:user)
      wallet = FactoryBot.create(:wallet, account: account)
      expect(wallet.account_type).to eq(wallet.account.class.name)
    end

    it "returns the account id" do
      account = FactoryBot.create(:user)
      wallet = FactoryBot.create(:wallet, account: account)
      expect(wallet.account_id).to eq(wallet.account.id)
    end
  end
end
