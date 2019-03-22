# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'api.bigcommerce.com'

    BASE_PATH = { v2: '/stores/%{store_hash}/v2',
                  v3: '/stores/%{store_hash}/v3' }.freeze

    HEADERS = { 'Accept' => 'application/json',
                'Content-Type' => 'application/json' }.freeze

    attr_reader :store_hash, :auth_token


    def initialize(store_hash:, auth_token:)
      @store_hash = store_hash
      @auth_token = auth_token
    end

    def store_url
      @store_url ||= "https://#{API_HOST}#{BASE_PATH[self.class::API_VERSION]}" % { store_hash: store_hash }
    end

  end
end
