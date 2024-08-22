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
end
