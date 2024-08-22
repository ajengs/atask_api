require "rails_helper"

RSpec.describe WalletsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/wallets").to route_to("wallets#index")
    end

    it "routes to #show" do
      expect(get: "/wallets/1").to route_to("wallets#show", id: "1")
    end

    it "routes to #calculated_balance" do
      expect(get: "/wallets/1/calculated_balance").to route_to("wallets#calculated_balance",
        id: "1")
    end
  end
end
