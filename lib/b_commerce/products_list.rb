# frozen_string_literal: true
module BCommerce
  class ProductsList < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    attr_reader :id

    def initialize(id: nil)
      @id = id.to_s
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
  end
end
