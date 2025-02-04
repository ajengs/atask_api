class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show update ]

  # GET /stocks
  def index
    @stocks = Stock.all

    render json: @stocks.as_json(include: :wallet)
  end

  # GET /stocks/1
  def show
    render json: @stock.as_json(include: :wallet)
  end

  # POST /stocks
  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      render json: @stock.as_json(include: :wallet), status: :created, location: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stocks/1
  def update
    if @stock.update(stock_params)
      render json: @stock.as_json(include: :wallet)
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:symbol, :company_name)
    end
end
