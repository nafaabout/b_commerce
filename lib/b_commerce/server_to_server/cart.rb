module BCommerce
  module ServerToServer
    class Cart < Resource

      attribute :customer_id, type: Integer
      attribute :line_items, type: Array, validate_with: :validate_line_items
      attribute :gift_certificates, type: Array, validate_with: :validate_gift_certificates
    end
  end
end
