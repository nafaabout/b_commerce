# frozen_string_literal: true
module BCommerce
  module Catalog

    class ProductsList < ResourceList
      PATH = '/catalog/products'
      API_VERSION = :v3

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
          price_list_id:      Integer,
          page:               Integer,
          limit:              Integer,
        }
      }

      generate_enum_params_query_methods(params: QUERY_PARAMS[:enum])
      generate_non_enum_params_query_methods(params: QUERY_PARAMS[:non_enum])

      valid_include_fields = %w(variants images custom_fields bulk_pricing_rules primary_image modifiers options)
      product_fields = Product.attributes.keys - [:id]

      generate_include_param_query_method(param: 'include', valid_values: valid_include_fields)
      generate_include_param_query_method(param: 'exclude_fields', valid_values: product_fields)
      generate_include_param_query_method(param: 'include_fields', valid_values: product_fields)

    end
  end
end
