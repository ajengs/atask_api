require "rails_helper"

RSpec.describe AuthenticationController, type: :routing do
  describe "routing" do
    it "routes to #sign_in" do
      expect(post: "/sign_in").to route_to("authentication#sign_in")
    end

    it "routes to #sign_out" do
      expect(delete: "/sign_out").to route_to("authentication#sign_out")
    end
  end
end
