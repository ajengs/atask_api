class SessionController < ApplicationController
  skip_before_action :authenticate_user, only: [ :sign_in ]

  def sign_in
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      auth_token = user.auth_tokens.create
      render json: { token: auth_token.token, expires_at: auth_token.expires_at }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def sign_out
    token = request.headers["Authorization"]&.split(" ")&.last
    current_user.auth_tokens.where(token: token).destroy_all
    head :no_content
  end
end
