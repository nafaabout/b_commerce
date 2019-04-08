# frozen_string_literal: true
module BCommerce

  class ProductsList < Base
    PATH = '/catalog/products'
    API_VERSION = :v3

    ARRAY_FILTERS  = [:in, :not_in]
    NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
    STRING_FILTERS = [:like] + ARRAY_FILTERS


    QUERY_PARAMS = {
      enum: {
        direction:          ["asc", "desc"],
        type:               ["physical", "digital"],
        keyword_context:    ["shopper", "merchant"],
        is_visible:         [true, false, 1, 0],
        condition:          ["new", "used", "refurbished"],
        availability:       ["available", "disabled", "preorder"],
        include:            ["variants", "images", "custom_fields", "bulk_pricing_rules", "primary_image", "modifiers", "options"],
        sort:               ["id", "name", "sku", "price", "date_modified", "date_last_imported", "inventory_level", "is_visible", "total_sold"]
      },

      non_enum: {
        id:                 Integer,
        name:               String,
        sku:                String,
        upc:                String,
        price:              Float,
        weight:             Float,
        brand_id:           Integer,
        date_modified:      String,
        date_last_imported: String,
        is_featured:        Integer,
        is_free_shipping:   Integer,
        inventory_level:    Integer,
        inventory_low:      Integer,
        out_of_stock:       Integer,
        total_sold:         Integer,
        categories:         Integer,
        keyword:            String,
        status:             Integer,
        include_fields:     String,
        exclude_fields:     String,
        price_list_id:      Integer,
        page:               Integer,
        limit:              Integer,
      }
    }

    extend QueryMethods

    generate_enum_params_query_methods(params: QUERY_PARAMS[:enum])
    generate_non_enum_params_query_methods(params: QUERY_PARAMS[:non_enum])

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
