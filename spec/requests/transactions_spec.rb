require 'rails_helper'

RSpec.describe "/transactions", type: :request do
  let(:valid_attributes) {
    account = FactoryBot.create(:user)
    FactoryBot.attributes_for(:transaction, destination_wallet_id: account.wallet.id)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:transaction, transaction_type: nil)
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Transaction.create! valid_attributes
      get transactions_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      transaction = Transaction.create! valid_attributes
      get transaction_url(transaction), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Transaction" do
        expect {
          post transactions_url,
            params: { transaction: valid_attributes },
            headers: valid_headers,
            as: :json
        }.to change(Transaction, :count).by(1)
      end

      it "renders a JSON response with the new transaction" do
        post transactions_url,
          params: { transaction: valid_attributes },
          headers: valid_headers,
          as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Transaction" do
        expect {
          post transactions_url,
            params: { transaction: invalid_attributes },
            as: :json
        }.to change(Transaction, :count).by(0)
      end

      it "renders a JSON response with errors for the new transaction" do
        post transactions_url,
          params: { transaction: invalid_attributes },
          headers: valid_headers,
          as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { amount: 100 }
      }

      it "updates the requested transaction" do
        transaction = Transaction.create! valid_attributes
        patch transaction_url(transaction),
          params: { transaction: new_attributes },
          headers: valid_headers,
          as: :json
        transaction.reload
        expect(transaction.amount).to eq(100)
      end

      it "renders a JSON response with the transaction" do
        transaction = Transaction.create! valid_attributes
        patch transaction_url(transaction),
          params: { transaction: new_attributes },
          headers: valid_headers,
          as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the transaction" do
        transaction = Transaction.create! valid_attributes
        patch transaction_url(transaction),
          params: { transaction: { transaction_type: 'invalid' } },
          headers: valid_headers,
          as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end
end
