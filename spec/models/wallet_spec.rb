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

  describe "calculated_balance" do
    let(:account) { FactoryBot.create(:user) }
    let(:wallet) { account.wallet }

    before do
      login_user
      FactoryBot.create(:transaction,
        destination_wallet: wallet,
        source_wallet: nil,
        amount: 100,
        user: @current_user)
      FactoryBot.create(:transaction,
        transaction_type: 'debit',
        source_wallet: wallet,
        destination_wallet: nil,
        amount: 50,
        user: @current_user)
    end


    it "returns the sum of incoming transactions minus the sum of outgoing transactions" do
      expect(wallet.calculated_balance).to eq(50)
    end

    it 'returns zero for a wallet with no transactions' do
      wallet.outgoing_transactions.destroy_all
      wallet.incoming_transactions.destroy_all
      expect(wallet.calculated_balance).to eq(0)
    end

    it 'checks if balance matches transactions' do
      expect(wallet.balance_matches_transactions).to be_truthy
    end

    it 'checks if balance does not matches transactions' do
      wallet.update(balance: 100)
      wallet.reload
      expect(wallet.balance_matches_transactions).to be_falsy
    end

    it 'checks if balance discrepancy is correct' do
      wallet.update(balance: 100)
      wallet.reload
      expect(wallet.balance_discrepancy).to eq(50)
    end
  end
end
