require 'rails_helper'

RSpec.describe "/stocks", type: :request do
  let(:valid_attributes) {
    FactoryBot.attributes_for(:stock)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:stock, symbol: nil)
  }
  
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Stock.create! valid_attributes
      get stocks_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      stock = Stock.create! valid_attributes
      get stock_url(stock), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Stock" do
        expect {
          post stocks_url,
               params: { stock: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Stock, :count).by(1)
      end

      it "renders a JSON response with the new stock" do
        post stocks_url,
             params: { stock: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to be_present
        expect(json_response['symbol']).to eq(valid_attributes[:symbol])
        expect(json_response['company_name']).to eq(valid_attributes[:company_name])
        expect(json_response['wallet']).to be_present
        expect(json_response['wallet']['balance']).to eq("0.0")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Stock" do
        expect {
          post stocks_url,
               params: { stock: invalid_attributes }, as: :json
        }.to change(Stock, :count).by(0)
      end

      it "renders a JSON response with errors for the new stock" do
        post stocks_url,
             params: { stock: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(422)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        FactoryBot.attributes_for(:stock, company_name: "New Company Name")
      }

      it "updates the requested stock" do
        stock = Stock.create! valid_attributes
        patch stock_url(stock),
              params: { stock: new_attributes }, headers: valid_headers, as: :json
        stock.reload
        expect(stock.company_name).to eq("New Company Name")
      end

      it "renders a JSON response with the stock" do
        stock = Stock.create! valid_attributes
        patch stock_url(stock),
              params: { stock: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the stock" do
        stock = Stock.create! valid_attributes
        patch stock_url(stock),
              params: { stock: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(422)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested stock" do
      stock = Stock.create! valid_attributes
      expect {
        delete stock_url(stock), headers: valid_headers, as: :json
      }.to change(Stock, :count).by(-1)
    end
  end
end
