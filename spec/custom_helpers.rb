module CustomHelpers
  def login_user
    auth_token = FactoryBot.create(:auth_token, user: current_user)
    @valid_headers = { 'Authorization' => "Bearer #{auth_token.token}" }
  end

  def current_user
    @current_user ||= FactoryBot.create(:user, email: "admin@example.com")
  end
end
