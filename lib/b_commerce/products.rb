# frozen_string_literal: true
module BCommerce
  class Products < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    attr_reader :id

    def initialize(id: nil)
      @id = id.to_s
    end

    def headers
      @headers ||= HEADERS.merge('x-auth-client' => client_id, 'x-auth-token' => auth_token)
    end

    def path
      @path ||= "#{store_path}#{resource_path}"
    end

    def resource_path
      if(id.empty?)
        PATH
      else
        "#{PATH}/#{id}"
      end
    end

    def all
      resp = connection.get(path: path)
      resources = JSON(resp.body, symbolize_names: true)
      resources[:data] if resources
    end

    def connection
      @connection ||= Excon.new(base_url, headers: headers, mock: ENV['TEST_ENV'] == 'true')
    end
  end
end
