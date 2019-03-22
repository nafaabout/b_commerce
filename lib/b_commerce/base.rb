# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'api.bigcommerce.com'

    BASE_PATH = { v2: 'https://api.bigcommerce.com/stores/%{store_hash}/v2',
                  v3: 'https://api.bigcommerce.com/stores/%{store_hash}/v3' }

    HEADERS = { 'Accept' => 'application/json',
                'Content-Type' => 'application/json' }

    attr_reader :store_hash, :auth_token


    def initialize(store_hash:, auth_token:)
      @store_hash = store_hash
      @auth_token = auth_token
    end

  end
end
