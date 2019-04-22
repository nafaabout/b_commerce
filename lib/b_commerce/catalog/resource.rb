module BCommerce
  module Catalog
    class Resource < Base
      attr_reader :attributes

      def initialize(attrs = {})
        if self.class == Resource
          raise 'BCommerce::Catalog::Resouce cannot be instantiated directly'
        end
        @attributes = attrs
      end

      def save

      end
    end
  end
end
