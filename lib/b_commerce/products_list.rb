# frozen_string_literal: true
module BCommerce

  class ProductsList < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    ARRAY_FILTERS  = [:in, :not_in]
    NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
    STRING_FILTERS = [:like] + ARRAY_FILTERS

    QUERY_PARAMS = {
      id:                 Integer,
      name:               String,
      sku:                String,
      upc:                String,
      price:              Float,
      weight:             Float,
      condition:          ["new", "used", "refurbished"],
      brand_id:           Integer,
      date_modified:      String,
      date_last_imported: String,
      is_visible:         [true, false, 1, 0],
      is_featured:        Integer,
      is_free_shipping:   Integer,
      inventory_level:    Integer,
      inventory_low:      Integer,
      out_of_stock:       Integer,
      total_sold:         Integer,
      type:               ["physical", "digital"],
      categories:         Integer,
      keyword:            String,
      keyword_context:    ["shopper", "merchant"],
      status:             Integer,
      include:            ["variants", "images", "custom_fields", "bulk_pricing_rules", "primary_image", "modifiers", "options"],
      include_fields:     String,
      exclude_fields:     String,
      availability:       ["available", "disabled", "preorder"],
      price_list_id:      Integer,
      page:               Integer,
      limit:              Integer,
      direction:          ["asc", "desc"],
      sort:               ["id", "name", "sku", "price", "date_modified", "date_last_imported", "inventory_level", "is_visible", "total_sold"]
    }

    QUERY_PARAMS.each do |param, type_or_values|
      if type_or_values.is_a?(Array)
        valid_values = type_or_values
        define_method param do |filters = {}|
          if valid_values.include?(filters)
            query[param] = filters
          elsif filters.is_a?(Hash)
            check_filters_validity(param, filters: filters)
            filters.each do |f, v|
              unless valid_value_for?(param, value: v)
                raise InvalidValue.new(v, valid_values: valid_values)
              end
              query["#{param}:#{f}"] = v
            end
          else
            raise InvalidValue.new(filters, valid_values: valid_values)
          end

          self
        end

      else
        type = type_or_values
        define_method param do |filters = {}|
          type_check_method = type.to_s.downcase + '?'
          if filters.is_a?(Hash)
            filters.each do |f, v|
              if !v.public_send(type_check_method)
                raise InvalidValue.new(v, valid_types: type)
              end
              query["#{param}:#{f}"] = send(type.to_s, v)
            end
          elsif filters.public_send(type_check_method)
            query[param] = send(type.to_s, filters)
          else
            raise InvalidValue.new(filters, valid_types: type)
          end

          self
        end

      end
    end

    def check_filters_validity(param, filters:)
      type = QUERY_PARAMS[param]
      invalid_f = invalid_filters(param, filters.keys)
      if !invalid_f.empty?
      raise InvalidFilters.new(invalid_f, attr: :type,
                               valid_filters: valid_filters_for(type))
      end
      true
    end

    def invalid_filters(type, filters)
      filters - valid_filters_for(type)
    end

    def valid_filters_for(type)
      if [Integer, Numeric].include?(type)
        NUMBER_FILTERS
      elsif type == String
        STRING_FILTERS
      elsif type.is_a?(Array)
        ARRAY_FILTERS
      else
        []
      end
    end

    def valid_value_for?(param, value:)
      type_or_values = QUERY_PARAMS[param]
      if type_or_values.is_a?(Array)
        type_or_values.include?(value)
      else
        value.is_a?(type_or_values)
      end
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
