# frozen_string_literal: true
module BCommerce
  class InvalidValue < StandardError
    def initialize(value, valid_types:)
      super("Invalid value #{value.inspect}, expected value of type #{valid_types.inspect}.")
    end
  end

  class ProductsList < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    def id(filters = {})
      if filters.is_a?(Hash)
        filters.each do |f, v|
          raise InvalidValue.new(v, valid_types: Integer) unless v.integer?
          query["id:#{f}"] = Integer(v)
        end
      elsif filters.integer?
        query[:id] = Integer(filters)
      else
        raise InvalidValue.new(filters, valid_types: Integer)
      end

      self
    end

    def path
      @path ||= "#{store_path}#{PATH}"
    end

    def query
      @query ||= {}
    end

    def all
      resp = connection.get(path: path, query: query)
      resources = JSON(resp.body, symbolize_names: true)
      resources[:data] if resources
    end
  end
end
