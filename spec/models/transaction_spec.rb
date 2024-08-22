require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    context 'base validations' do
      it 'is valid with valid attributes' do
        transaction = FactoryBot.create(:transaction)
        expect(transaction).to be_valid
      end

      it 'is not valid without a transaction_type' do
        transaction = FactoryBot.build(:transaction, transaction_type: nil)
        expect(transaction).to_not be_valid
      end

      it 'is not valid with an invalid transaction_type' do
        transaction = FactoryBot.build(:transaction, transaction_type: 'invalid')
        expect(transaction).to_not be_valid
      end

      it 'is not valid without an amount' do
        transaction = FactoryBot.build(:transaction, amount: nil)
        expect(transaction).to_not be_valid
      end

      it 'is not valid with a non-positive amount' do
        transaction = FactoryBot.build(:transaction, amount: -1)
        expect(transaction).to_not be_valid
      end
    end

    context 'validate transaction type required fields' do
      it 'is not valid credit without a destination_wallet' do
        transaction = FactoryBot.build(:transaction, destination_wallet: nil)
        expect(transaction).to_not be_valid
      end

      it 'is not valid debit without a source_wallet' do
        transaction = FactoryBot.build(:transaction, transaction_type: 'debit', source_wallet: nil)
        expect(transaction).to_not be_valid
      end

      it 'is not valid transfer without a source_wallet' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'transfer',
          source_wallet: nil)
        expect(transaction).to_not be_valid
      end

      it 'is not valid transfer without a destination_wallet' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'transfer',
          destination_wallet: nil)
        expect(transaction).to_not be_valid
      end
    end

    context 'validate balance is enough' do
      let(:source_wallet) {
        user = FactoryBot.create(:user)
        user.wallet.update(balance: 100)
        user.wallet.reload
      }
      let(:destination_wallet) {
        user = FactoryBot.create(:user, email: 'destination@example.com')
        user.wallet
      }

      it 'is valid debit when amount is less than or equal to source wallet balance' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'debit',
          source_wallet: source_wallet,
          amount: 100)
        expect(transaction).to be_valid
      end

      it 'is invalid debit when amount exceeds source wallet balance' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'debit',
          source_wallet: source_wallet,
          amount: 101)
        expect(transaction).to be_invalid
        expect(transaction.errors[:amount]).to include(
          'exceeds available balance in the source wallet')
      end

      it 'is valid transfer when amount is less than or equal to source wallet balance' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'transfer',
          source_wallet: source_wallet,
          destination_wallet: destination_wallet,
          amount: 100)
        expect(transaction).to be_valid
      end

      it 'is invalid transfer when amount exceeds source wallet balance' do
        transaction = FactoryBot.build(:transaction,
          transaction_type: 'transfer',
          source_wallet: source_wallet,
          destination_wallet: destination_wallet,
          amount: 101)
        expect(transaction).to be_invalid
        expect(transaction.errors[:amount]).to include(
          'exceeds available balance in the source wallet')
      end
    end
  end

  context 'callbacks' do
    before do
      login_user
    end

    it 'updates the wallet balances for credit transactions' do
      transaction = FactoryBot.create(:transaction,
        transaction_type: 'credit',
        amount: 100,
        user: @current_user)
      expect(transaction.destination_wallet.balance).to eq(transaction.amount)
    end

    it 'updates the wallet balances for debit transactions' do
      credited = FactoryBot.create(:transaction,
        transaction_type: 'credit',
        amount: 100,
        user: @current_user)
      transaction = FactoryBot.create(:transaction,
        transaction_type: 'debit',
        source_wallet: credited.destination_wallet,
        destination_wallet: nil,
        amount: 10,
        user: @current_user)
      expect(transaction.source_wallet.balance).to eq(90.0)
    end

    it 'updates the wallet balances for transfer transactions' do
      credited = FactoryBot.create(:transaction,
        transaction_type: 'credit',
        source_wallet: nil,
        amount: 100,
        user: @current_user)
      destination = FactoryBot.create(:user)
      transaction = FactoryBot.create(:transaction,
        transaction_type: 'transfer',
        source_wallet: credited.destination_wallet,
        destination_wallet: destination.wallet,
        amount: 10,
        user: @current_user)
      expect(transaction.source_wallet.balance).to eq(90.0)
      expect(transaction.destination_wallet.balance).to eq(10.0)
    end

    it 'does not create a transaction if wallet update fails' do
      source_account = FactoryBot.create(:user)
      destination_account = FactoryBot.create(:user, email: 'destination@example.com')

      allow_any_instance_of(Wallet).to receive(:increment!).and_raise(ActiveRecord::RecordInvalid)

      expect {
        FactoryBot.create(:transaction,
          transaction_type: 'transfer',
          source_wallet: source_account.wallet,
          destination_wallet: destination_account.wallet,
          amount: 50,
          user: @current_user)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(Transaction.count).to eq(0)

      expect(source_account.wallet.reload.balance).to eq(0)
      expect(destination_account.wallet.reload.balance).to eq(0)
    end
  end
end
