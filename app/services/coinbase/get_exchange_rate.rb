# frozen_string_literal: true

module Coinbase
  class GetExchangeRate < ApplicationService
    attr_accessor :from_coin, :to_coin, :rate

    require 'net/http'

    def initialize(params = {})
      @from_coin = params[:from_coin]
      @to_coin = params[:to_coin]
    end

    def call
      response = process_request

      parsed_response(response)
      if response.code == '200'
        success_response(@parsed_response['rate'])
      else
        error_response(@parsed_response['error'])
      end
    rescue StandardError => e
      error_response(e.message)
    end

    private

    def request_url
      @request_url ||= URI("https://rest.coinapi.io/v1/exchangerate/#{@from_coin}/#{@to_coin}")
    end

    def process_request
      http = Net::HTTP.new(request_url.host, request_url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(request_url)
      request['X-CoinAPI-Key'] = Rails.application.credentials.config[:coinbase][:api_key_free]
      http.request(request)
    end

    def parsed_response(response)
      return '' if response.blank?

      @parsed_response ||= JSON.parse(response.body)
    end
  end
end
