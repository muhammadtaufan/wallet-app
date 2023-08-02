require 'net/http'
require 'uri'

module StockPrice
  API_HOST = ENV.fetch('STOCK_API_HOST') { 'localhost' }
  API_KEY = ENV.fetch('STOCK_API_KEY') { 'api_key' }
  INDICES = ['NIFTY 50', 'NIFTY NEXT 50', 'NIFTY BANK', 'NIFTY 100', 'NIFTY 500'].freeze

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
      api_path = "/price?Indices=#{symbol}"
      response = request(api_path)
      response.map { |data| Stock.new(data) }
    end

    def self.prices(symbols)
      symbols.each { |symbol| validate_symbol(symbol) }
      api_path = "/price?Indices=#{symbols.join(',')}"
      response = request(api_path)
      response.map { |data| Stock.new(data) }
    end

    def self.price_all
      api_path = '/any'
      response = request(api_path)
      response.map { |data| Stock.new(data) }
    end

    def self.validate_symbol(symbol)
      raise ArgumentError, "Invalid symbol: #{symbol}" unless INDICES.include?(symbol)
    end

    def self.request(api_path)
      uri = URI.parse("#{API_HOST}#{api_path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri, { 'X-RapidAPI-Key' => API_KEY })
      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end
