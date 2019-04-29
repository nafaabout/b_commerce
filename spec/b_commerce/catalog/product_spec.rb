module BCommerce
  module Catalog
    RSpec.describe Product do
      let(:attributes) {
        {
          id: { type: Integer, readonly: true },
          name: { type: String, length: 1..255, required: true },
          type: { values: ["physical", "digital"], required: true },
          sku: { type: String, length: 0..255 },
          description: { type: String },
          weight: { type: Float, range: 0.., required: true },
          width: { type: Float, range: 0.. },
          depth: { type: Float, range: 0.. },
          height: { type: Float, range: 0.. },
          price: { type: Float, range: 0.., required: true },
          cost_price: { type: Float, range: 0.. },
          retail_price: { type: Float, range: 0.. },
          sale_price: { type: Float, range: 0.. },
          tax_class_id: { type: Integer, range: 0.. },
          product_tax_code: { type: String, length: 0..255 },
          categories: { type: Array, values_type: Integer, required: true },
          brand_id: { type: Integer, range: 0.. },
          inventory_level: { type: Integer, range: 0.. },
          inventory_warning_level: { type: Integer, range: 0.. },
          inventory_tracking: { values: ["none", "product", "variant"] },
          fixed_cost_shipping_price: { type: Float, range: 0.. },
          is_free_shipping: { values: [true, false, 1, 0] },
          is_visible: { values: [true, false, 1, 0] },
          is_featured: { values: [true, false, 1, 0] },
          related_products: { type: Array, values_type: Integer },
          warranty: { type: String, length: 0..65535 },
          bin_picking_number: { type: String, length: 0..255 },
          layout_file: { type: String, length: 0..500 },
          upc: { type: String, length: 0..500 },
          search_keywords: { type: String, length: 0..65535 },
          availability: { values: ["available", "disabled", "preorder"] },
          availability_description: { type: String, length: 0..255 },
          gift_wrapping_options_type: { values: ["any", "none", "list"] },
          gift_wrapping_options_list: { type: Array, values_type: Integer },
          sort_order: { type: Integer, range: -2147483648..2147483647 },
          condition: { values: ["New", "Used", "Refurbished"] },
          is_condition_shown: { values: [true, false, 1, 0] },
          order_quantity_minimum: { type: Integer, range: 0.. },
          order_quantity_maximum: { type: Integer, range: 0.. },
          page_title: { type: String, length: 0..255 },
          meta_keywords: { type: Array, values_type: String },
          meta_description: { type: String, length: 0..65535 },
          view_count: { type: Integer, range: 0.. },
          preorder_release_date: { type: DateTime },
          preorder_message: { type: String, length: 0..255 },
          is_preorder_only: { values: [true, false, 1, 0] },
          is_price_hidden: { values: [true, false, 1, 0] },
          price_hidden_label: { type: String, length: 0..200 },
          custom_url: { type: Object, validate_with: :validate_custom_url },
          open_graph_type: { values: ["product", "album", "book", "drink", "food", "game", "movie", "song", "tv_show"] },
          open_graph_title: { type: String },
          open_graph_description: { type: String },
          open_graph_use_meta_description: { values: [true, false, 1, 0] },
          open_graph_use_product_name: { values: [true, false, 1, 0] },
          open_graph_use_image: { values: [true, false, 1, 0] },
          gtin: { type: String },
          mpn: { type: String },
          calculated_price: { type: Float, readonly: true },
          reviews_rating_sum: { type: Integer },
          reviews_count: { type: Integer },
          total_sold: { type: Integer },
          custom_fields: { type: Array, validate_with: :validate_custom_fields },
          bulk_pricing_rules: { type: Array, validate_with: :validate_bulk_pricing_rules },
          date_created: { type: DateTime, readonly: true },
          date_modified: { type: DateTime, readonly: true },
          images: { type: Array, validate_with: :validate_image },
          videos: { type: Array, validate_with: :validate_video },
          variants: { type: Array, validate_with: :validate_variant },
          base_variant_id: { type: Integer, readonly: true }
        }
      }
      it 'has validation methods for all product attributes' do
        attributes.each do |attr, options|
          expect(Product.attributes[attr]).to eq(options), "expected #{options.inspect} for #{attr.inspect}, got #{Product.attributes[attr]}"
        end
      end
    end
  end
end
