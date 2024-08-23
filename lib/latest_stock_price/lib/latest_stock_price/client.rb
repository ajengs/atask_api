# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

require "dotenv"
Dotenv.load if defined?(Dotenv)

module LatestStockPrice
  class Client
    BASE_URL = ENV["LATEST_STOCK_PRICE_HOST"]  || "https://latest-stock-price.p.rapidapi.com/any"
    API_KEY = ENV["LATEST_STOCK_PRICE_API_KEY"]

    def price(symbol)
      request("?Identifier=#{symbol}")
    end

    def prices(symbols)
      request("?Identifier=#{symbols}")
    end

    def price_all
      request("")
    end

    private

    def request(path)
      uri = URI.parse("#{BASE_URL}#{path}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request["X-RapidAPI-Key"] = API_KEY
      request["X-RapidAPI-Host"] = "latest-stock-price.p.rapidapi.com"

      response = http.request(request)
      parsed_response = JSON.parse(response.body)

      parsed_response.map do |item|
        item.transform_keys do |key|
          key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
        end
      end

      # JSON.parse(response.body)
    end
  end
end
