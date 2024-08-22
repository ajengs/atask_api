require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  describe "callbacks" do
    it "generates a token before creation" do
      auth_token = FactoryBot.create(:auth_token)
      expect(auth_token.token).to be_present
    end

    it "generates a hashed token" do
      auth_token = FactoryBot.create(:auth_token)
      expect(auth_token.token).to match(/^[a-f0-9]{40}$/)
    end

    it "sets an expiration date" do
      auth_token = FactoryBot.create(:auth_token)
      expect(auth_token.expires_at).to be_present
    end
  end
end
