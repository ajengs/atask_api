require 'rails_helper'

RSpec.describe "Session", type: :request do
  describe "POST /sign_in" do
    let(:user) { FactoryBot.create(:user, password: 'password123') }

    it "returns a token when credentials are valid" do
      post '/sign_in', params: { email: user.email, password: 'password123' }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('token', 'expires_at')
    end

    it "returns an error when credentials are invalid" do
      post '/sign_in', params: { email: user.email, password: 'wrong_password' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /sign_out" do
    let(:user) { FactoryBot.create(:user) }
    let(:auth_token) { FactoryBot.create(:auth_token, user: user) }

    it "invalidates the token" do
      delete '/sign_out', headers: { 'Authorization' => "Bearer #{auth_token.token}" }
      expect(response).to have_http_status(:no_content)
      expect(AuthToken.find_by(id: auth_token.id)).to be_nil
    end

    it "returns an error when the token is invalid" do
      delete '/sign_out', headers: { 'Authorization' => "Bearer invalid_token" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
