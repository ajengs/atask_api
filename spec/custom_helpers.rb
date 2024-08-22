module CustomHelpers
  def login_user
    user = FactoryBot.create(:user, email: "admin@example.com")
    auth_token = FactoryBot.create(:auth_token, user: user)
    @valid_headers = { 'Authorization' => "Bearer #{auth_token.token}" }
  end
end
