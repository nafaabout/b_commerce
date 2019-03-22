module BCommerce
  class Product < Base
    PATH = '/catalog/products'
    API_VERSION = :v3


    def url
      url ||= store_url + PATH
    end
  end
end
