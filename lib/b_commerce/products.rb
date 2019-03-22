# frozen_string_literal: true
module BCommerce
  class Products < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    attr_reader :id

    def initialize(store_hash:, auth_token:, id: nil)
      super(store_hash: store_hash, auth_token: auth_token)
      @id = id.to_s
    end

    def url
      @url ||= store_url + path
    end

    def headers
      @headers ||= HEADERS.merge('x-auth-token' => auth_token)
    end

    def path
      @path ||= if(id.empty?)
                  PATH
                else
                  PATH + "/#{id}"
                end
    end
  end
end
