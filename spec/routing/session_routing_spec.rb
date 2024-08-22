require "rails_helper"

RSpec.describe SessionController, type: :routing do
  describe "routing" do
    it "routes to #sign_in" do
      expect(post: "/sign_in").to route_to("session#sign_in")
    end

    it "routes to #sign_out" do
      expect(delete: "/sign_out").to route_to("session#sign_out")
    end
  end
end
