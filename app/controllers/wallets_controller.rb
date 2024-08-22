class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[ show calculated_balance ]

  # GET /wallets
  def index
    @wallets = Wallet.all

    render json: @wallets
  end

  # GET /wallets/1
  def show
    render json: @wallet
  end

  def calculated_balance
    render json: { 
      balance: @wallet.balance,
      calculated_balance: @wallet.calculated_balance,
      balance_matches_transactions: @wallet.balance_matches_transactions,
      balance_discrepancy: @wallet.balance_discrepancy
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end
end
