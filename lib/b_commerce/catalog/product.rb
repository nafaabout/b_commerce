module BCommerce
  module Catalog
    class Product < Resource
      PATH = '/catalog/products'

      attribute :id, type: Integer, readonly: true
      attribute :name, type: String, length: 1..255, required: true
      attribute :type, values: ["physical", "digital"], required: true
      attribute :sku, type: String,  length: 0..255
      attribute :description, type: String
      attribute :weight, type: Float, range: (0..), required: true
      attribute :width, type: Float, range: (0..)
      attribute :depth, type: Float, range: (0..)
      attribute :height, type: Float, range: (0..)
      attribute :price, type: Float, range: (0..), required: true
      attribute :cost_price, type: Float, range: (0..)
      attribute :retail_price, type: Float, range: (0..)
      attribute :sale_price, type: Float, range: (0..)
      attribute :tax_class_id, type: Integer, range: (0..)
      attribute :product_tax_code, type: String, length: 0..255
      attribute :categories, type: Array, values_type: Integer, required: true
      attribute :brand_id, type: Integer, range: (0..)
      attribute :inventory_level, type: Integer, range: (0..)
      attribute :inventory_warning_level, type: Integer, range: (0..)
      attribute :inventory_tracking, values: ["none", "product", "variant"]
      attribute :fixed_cost_shipping_price, type: Float, range: (0..)
      attribute :is_free_shipping, values: BOOLEAN
      attribute :is_visible, values: BOOLEAN
      attribute :is_featured, values: BOOLEAN
      attribute :related_products, type: Array, values_type: Integer
      attribute :warranty, type: String, length: 0..65535
      attribute :bin_picking_number, type: String, length: 0..255
      attribute :layout_file, type: String, length: 0..500
      attribute :upc, type: String, length: 0..500
      attribute :search_keywords, type: String, length: 0..65535
      attribute :availability, values: ["available", "disabled", "preorder"]
      attribute :availability_description, type: String, length: 0..255
      attribute :gift_wrapping_options_type, values: ["any", "none", "list"]
      attribute :gift_wrapping_options_list, type: Array, values_type: Integer
      attribute :sort_order, type: Integer, range: -2147483648..2147483647
      attribute :condition, values: ["New", "Used", "Refurbished"]
      attribute :is_condition_shown, values: BOOLEAN
      attribute :order_quantity_minimum, type: Integer, range: (0..)
      attribute :order_quantity_maximum, type: Integer, range: (0..)
      attribute :page_title, type: String, length: (0..255)
      attribute :meta_keywords, type: Array, values_type: String
      attribute :meta_description, type: String, length: 0..65535
      attribute :view_count, type: Integer, range: (0..)
      attribute :preorder_release_date, type: DateTime
      attribute :preorder_message, type: String, length: 0..255
      attribute :is_preorder_only, values: BOOLEAN
      attribute :is_price_hidden, values: BOOLEAN
      attribute :price_hidden_label, type: String, length: 0..200
      attribute :custom_url, type: Object, validate_with: :validate_custom_url
      attribute :open_graph_type, values: ["product", "album", "book", "drink", "food", "game", "movie", "song", "tv_show"]
      attribute :open_graph_title, type: String
      attribute :open_graph_description, type: String
      attribute :open_graph_use_meta_description, values: BOOLEAN
      attribute :open_graph_use_product_name, values: BOOLEAN
      attribute :open_graph_use_image, values: BOOLEAN
      attribute :gtin, type: String
      attribute :mpn, type: String
      attribute :calculated_price, type: Float, readonly: true
      attribute :reviews_rating_sum, type: Integer
      attribute :reviews_count, type: Integer
      attribute :total_sold, type: Integer
      attribute :custom_fields, type: Array, validate_with: :validate_custom_fields
      attribute :bulk_pricing_rules, type: Array, validate_with: :validate_bulk_pricing_rules
      attribute :date_created, type: DateTime, readonly: true
      attribute :date_modified, type: DateTime, readonly: true
      attribute :images, type: Array, validate_with: :validate_image
      attribute :videos, type: Array, validate_with: :validate_video
      attribute :variants, type: Array, validate_with: :validate_variant
      attribute :base_variant_id, type: Integer, readonly: true


      def initialize(attributes = {})
        super(attributes)
      end

      private

      def validate_custom_url
        # TODO: implement this
        true
      end

      def validate_custom_fields
        # TODO: implement this
        true
      end

      def validate_bulk_pricing_rules
        # TODO: implement this
        true
      end

      def validate_image
        # TODO: implement this
        true
      end

      def validate_video
        # TODO: implement this
        true
      end

      def validate_variant
        # TODO: implement this
        true
      end
    end
  end
end
