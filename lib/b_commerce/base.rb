# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'api.bigcommerce.com'

    STORE_PATH = { v2: '/stores/%{store_hash}/v2',
                   v3: '/stores/%{store_hash}/v3' }.freeze

    HEADERS = { 'accept' => 'application/json',
                'content-type' => 'application/json' }.freeze

    def base_url
      @base_url ||= "https://#{API_HOST}"
    end

    def store_path
      @store_path ||= "#{STORE_PATH[self.class::API_VERSION]}" % { store_hash: store_hash }
    end

		def store_hash
			self.class.store_hash
		end

    def auth_token
      self.class.auth_token
    end

    def client_id
      self.class.client_id
    end

    class << self

      def setup(client_id:, store_hash:, auth_token:)
        Thread.current[:client_id]  = client_id
				Thread.current[:store_hash] = store_hash
        Thread.current[:auth_token] = auth_token
      end

      def client_id
        Thread.current[:client_id]
      end

			def store_hash
				Thread.current[:store_hash]
			end

			def auth_token
				Thread.current[:auth_token]
			end
    end

  end
end
