require 'net/http'
require 'uri'
require_relative 'http_client'

module StockPrice
  API_HOST = ENV.fetch('STOCK_API_HOST') { 'localhost' }
  API_KEY = ENV.fetch('STOCK_API_KEY') { 'api_key' }
  INDICES = ['NIFTY 50', 'NIFTY NEXT 50', 'NIFTY BANK', 'NIFTY 100', 'NIFTY 500'].freeze
  HTTP_CLIENT = HttpClient.new(API_HOST, { 'X-RapidAPI-Key' => API_KEY })

  class Stock
    attr_reader :symbol, :open, :day_high, :day_low, :last_price

    def initialize(data)
      @symbol = data['symbol']
      @open = data['open']
      @day_high = data['dayHigh']
      @day_low = data['dayLow']
      @last_price = data['lastPrice']
    end

    def self.price(symbol)
      validate_symbol(symbol)
      response = request('/price', { 'Indices' => symbol })
      response.map { |data| Stock.new(data) }
    end

    def self.prices(symbols)
      symbols.each { |symbol| validate_symbol(symbol) }
      response = request('/price', { 'Indices' => symbols.join(',') })
      response.map { |data| Stock.new(data) }
    end

    def self.price_all
      response = request('/any')
      response.map { |data| Stock.new(data) }
    end

    def self.validate_symbol(symbol)
      raise ArgumentError, "Invalid symbol: #{symbol}" unless INDICES.include?(symbol)
    end

    def self.request(api_path, params = {})
      HTTP_CLIENT.get(api_path, params)
    end
  end
end
