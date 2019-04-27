# frozen_string_literal: true
module BCommerce
  module ServerToServer
    class Cart < Resource
      PATH = '/carts'
      API_VERSION = 'v3'

      attribute :customer_id, type: Integer
      attribute :line_items, type: Array, validate_with: :validate_line_items
      attribute :gift_certificates, type: Array, validate_with: :validate_gift_certificates

      extend QueryMethods

      QUERY_PARAMS = {
        include: ['redirect_urls',
                  'line_items.physical_items.options',
                  'line_items.digital_items.options']
      }

      generate_include_param_query_method(param: 'include', valid_values: QUERY_PARAMS[:include])
    end
  end
end
