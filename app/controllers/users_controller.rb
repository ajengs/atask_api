class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update ]

  # GET /users
  def index
    @users = User.all

    render json: user_json(@users)
  end

  # GET /users/1
  def show
    render json: user_json(@user)
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: user_json(@user), status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: user_json(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def user_json(user)
      user.as_json(include: :wallet, except: :password_digest)
    end
end
