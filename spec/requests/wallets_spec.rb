require 'rails_helper'

RSpec.describe "/wallets", type: :request do
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      FactoryBot.create(:user)
      get wallets_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      account = FactoryBot.create(:user)
      get wallet_url(account.wallet), as: :json
      expect(response).to be_successful
    end

    it "renders a JSON response with wallet details" do
      account = FactoryBot.create(:user)
      get wallet_url(account.wallet), as: :json

      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response['id']).to be_present
    end
  end

  describe "GET /calculated_balance" do
    let(:user) { FactoryBot.create(:user) }
    let(:wallet) { user.wallet }

    before do
      FactoryBot.create(:transaction, destination_wallet: wallet, source_wallet: nil, amount: 100)
      FactoryBot.create(:transaction,
        transaction_type: 'debit',
        source_wallet: wallet,
        destination_wallet: nil,
        amount: 50)
    end

    it "renders a successful response" do
      get calculated_balance_wallet_url(wallet), as: :json
      expect(response).to be_successful
    end

    it "returns correct calculated balance information" do
      get calculated_balance_wallet_url(wallet), as: :json

      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response['balance']).to eq(wallet.balance.to_s)
      expect(json_response['calculated_balance']).to eq("50.0")
      expect(json_response['balance_matches_transactions']).to eq(true)
      expect(json_response['balance_discrepancy']).to eq("0.0")
    end

    it 'returns correct calculated balance information when balance does not match transactions' do
      wallet.update(balance: 70)
      get calculated_balance_wallet_url(wallet), as: :json

      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))
      json_response = JSON.parse(response.body)
      expect(json_response['balance']).to eq(wallet.balance.to_s)
      expect(json_response['calculated_balance']).to eq("50.0")
      expect(json_response['balance_matches_transactions']).to eq(false)
      expect(json_response['balance_discrepancy']).to eq("20.0")
    end
  end
end
