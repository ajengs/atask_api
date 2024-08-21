require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      stock = FactoryBot.build(:stock)
      expect(stock).to be_valid
    end

    it "is not valid without a symbol" do
      stock = FactoryBot.build(:stock, symbol: nil)
      expect(stock).to_not be_valid
    end 

    it "is not valid without a company name" do
      stock = FactoryBot.build(:stock, company_name: nil)
      expect(stock).to_not be_valid
    end 

    it "is not valid with a duplicate symbol" do
      FactoryBot.create(:stock, symbol: "AAPL", company_name: "Apple Inc.")
      stock = FactoryBot.build(:stock, symbol: "AAPL")
      expect(stock).to_not be_valid
    end
  end

  describe "methods" do
    it "returns the stock symbol" do
      stock = FactoryBot.create(:stock)
      expect(stock.symbol).to eq("AAPL")
    end

    it "returns the company name" do
      stock = FactoryBot.create(:stock)
      expect(stock.company_name).to eq("Apple Inc.")
    end
  end

  describe "after_create callback" do
    it "creates a default wallet with zero balance" do
      stock = FactoryBot.create(:stock)
      expect(stock.wallet).to be_present
      expect(stock.wallet.balance).to eq(0)
      expect(stock.wallet.account_type).to eq("Stock")
      expect(stock.wallet.account_id).to eq(stock.id)
    end
  end
end
