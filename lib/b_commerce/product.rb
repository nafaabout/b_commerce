module BCommerce
  class Product < Base
    PATH = '/catalog/products'
    API_VERSION = :v3


    def url
      @url ||= store_url + PATH
    end

    def headers
      @headers ||= HEADERS.merge('X-Auth-Token' => auth_token)
    end
  end
end
