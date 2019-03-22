# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'api.bigcommerce.com'
    BASE_PATH = { v2: 'https://api.bigcommerce.com/stores/%{store_hash}/v2',
                  v3: 'https://api.bigcommerce.com/stores/%{store_hash}/v3' }
  end
end
