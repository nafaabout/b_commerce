# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'api.bigcommerce.com'

    STORE_PATH = { v2: '/stores/%{store_hash}/v2',
                   v3: '/stores/%{store_hash}/v3' }.freeze

    HEADERS = { 'accept' => 'application/json',
                'content-type' => 'application/json' }.freeze

    attr_reader :store_hash, :client_id, :auth_token


    def initialize(store_hash:, client_id:, auth_token:)
      @store_hash = store_hash
      @auth_token = auth_token
      @client_id  = client_id
    end

    def base_url
      @base_url ||= "https://#{API_HOST}"
    end

    def store_path
      @store_path ||= "#{STORE_PATH[self.class::API_VERSION]}" % { store_hash: store_hash }
    end

  end
end
