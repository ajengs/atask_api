require "rails_helper"

RSpec.describe StocksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/stocks").to route_to("stocks#index")
    end

    it "routes to #show" do
      expect(get: "/stocks/1").to route_to("stocks#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/stocks").to route_to("stocks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/stocks/1").to route_to("stocks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/stocks/1").to route_to("stocks#update", id: "1")
    end
  end
end
