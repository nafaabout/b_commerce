module BCommerce
  BOOLEAN = [true, false, 1, 0]

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

      class << self
        def attribute(attr, options = {})
          if options[:type]
            type = options[:type].to_s.downcase
            send(:"define_#{type}_attribute", attr, options)
          elsif(options[:values])
            define_enum_attribute(attr, options)
          end
        end

        private

        def define_enum_attribute(attr, options)
          define_method("valid_#{attr}?") do
            options[:values].include?(attributes[attr].to_s)
          end
        end

        def define_string_attribute(attr, options)
          define_method("valid_#{attr}?") do
            if(options[:length])
              options[:length].include?(attributes[attr].to_s.length)
            else
              attributes[attr].is_a?(String)
            end
          end
        end

      end


    end
  end
end
