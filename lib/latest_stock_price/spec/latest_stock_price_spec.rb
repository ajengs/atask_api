# spec/my_lib_spec.rb
require "spec_helper"
require "latest_stock_price"
require "dotenv"
Dotenv.load if defined?(Dotenv)


RSpec.describe LatestStockPrice do
  let(:response_body) { '[{"symbol": "AAPL", "lastPrice": 150.00}]' }
  let(:client) { LatestStockPrice::Client.new }

  before do
    stub_request(:get,
      "https://latest-stock-price.p.rapidapi.com/any?Identifier=AAPL")
      .to_return(status: 200,
        body: response_body,
        headers: { "Content-Type" => "application/json" })
  end

  it "has a version number" do
    expect(LatestStockPrice::VERSION).not_to be nil
  end

  it "get stock price" do
    response = client.price("AAPL")
    expect(response).not_to be nil
    expect(response.length).to eq(1)
    expect(response[0]["symbol"]).to eq("AAPL")
    expect(response[0]["last_price"]).to eq(150.00)
  end
end
