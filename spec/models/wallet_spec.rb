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

    it 'increments the lock version on update' do
      account = FactoryBot.create(:user)
      wallet = account.wallet
      expect {
        wallet.update(balance: 100)
      }.to change { wallet.reload.lock_version }.by(1)
    end

    it 'fails to update when there is a concurrent modification' do
      account = FactoryBot.create(:user)
      wallet = account.wallet
      original_balance = wallet.balance

      # Simulate a concurrent update
      wallet_copy = Wallet.find(wallet.id)
      wallet_copy.update(balance: 200)

      # Attempt to update the original wallet
      expect {
        wallet.update(balance: 300)
      }.to raise_error(ActiveRecord::StaleObjectError)

      # Verify the balance wasn't changed
      expect(wallet.reload.balance).to eq(200)
    end
  end
end
