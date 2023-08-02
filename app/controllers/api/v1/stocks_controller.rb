class Api::V1::StocksController < Api::V1::ApplicationController
  def price
    @stock = StockPrice::Stock.price(params[:symbol])
    render json: { data: @stock, status: 'success' }
  end

  def prices
    @stock = StockPrice::Stock.prices(params[:symbols].split(','))
    render json: { data: @stock, status: 'success' }
  end

  def price_all
    @stock = StockPrice::Stock.price_all
    render json: { data: @stock, status: 'success' }
  end
end
