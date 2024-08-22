class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[ show ]

  # GET /wallets
  def index
    @wallets = Wallet.all

    render json: @wallets
  end

  # GET /wallets/1
  def show
    render json: @wallet
  end

  private
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end
end
