# frozen_string_literal: true
module BCommerce
  class Base
    API_HOST = 'https://api.bigcommerce.com'

    HEADERS = { 'accept' => 'application/json',
                'content-type' => 'application/json' }.freeze

    def base_url
      self.class.base_url
    end

    def store_path
      @store_path ||= "/stores/#{store_hash}/#{api_version}"
    end

    def api_version
      self.class::API_VERSION
    end

    def client_id
      self.class.client_id
    end

		def store_hash
			self.class.store_hash
		end

    def auth_token
      self.class.auth_token
    end

    def headers
      self.class.headers
    end

    def connection
      self.class.connection
    end

    class << self

      def base_url
        API_HOST
      end

      def setup(client_id:, store_hash:, auth_token:)
        Thread.current[:client_id]  = client_id
        Thread.current[:store_hash] = store_hash
        Thread.current[:auth_token] = auth_token
        Thread.current[:headers] = nil
        Thread.current[:connection] = nil
      end

      def client_id
        client_id = Thread.current[:client_id]
        if !client_id
          raise MissingCredentials.new('client_id')
        end
        client_id
      end

      def store_hash
        hash = Thread.current[:store_hash]
        if !hash
          raise MissingCredentials.new('store_hash')
        end
        hash
      end

      def auth_token
        token = Thread.current[:auth_token]
        if !token
          raise MissingCredentials.new('auth_token')
        end
        token
      end

      def headers
        Thread.current[:headers] ||= HEADERS.merge('x-auth-client' => client_id, 'x-auth-token' => auth_token)
      end

      def connection
        Thread.current[:connection] ||= Excon.new(base_url, headers: headers, mock: ENV['TEST_ENV'] == 'true')
      end
    end
  end
end
