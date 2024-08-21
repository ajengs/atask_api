require 'rails_helper'

RSpec.describe Stock, type: :model do
  it "is valid with valid attributes" do
    stock = Stock.new(symbol: "AAPL", company_name: "Apple Inc.")
    expect(stock).to be_valid
  end

  it "is not valid without a symbol" do
    stock = Stock.new(symbol: nil, company_name: "Apple Inc.")
    expect(stock).to_not be_valid
  end 

  it "is not valid without a company name" do
    stock = Stock.new(symbol: "AAPL", company_name: nil)
    expect(stock).to_not be_valid
  end 

  it "is not valid with a duplicate symbol" do
    Stock.create(symbol: "AAPL", company_name: "Apple Inc.")
    stock = Stock.new(symbol: "AAPL", company_name: "Apple Inc.")
    expect(stock).to_not be_valid
  end
end
