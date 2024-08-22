class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    token = request.headers["Authorization"]&.split(" ")&.last
    @auth_token = AuthToken.find_by(token: token)

    if @auth_token&.expires_at&.future?
      @current_user = @auth_token.user
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
