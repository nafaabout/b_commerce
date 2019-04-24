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
            options[:values].include?(attributes[attr])
          end
        end

        def define_array_attribute(attr, options)
          if !options[:values_type].is_a?(Class) && !options.key?(:validate_with)
            raise ArgumentError.new('For type Array, :values_type or :validate_with arguments should be passed.')
          end

          if options[:values_type]
            define_method("valid_#{attr}?") do
              return false unless attributes[attr].is_a?(Array)
              type_method = options[:values_type].to_s
              attributes[attr].all? do |v|
                send(type_method, v)
                true
              rescue StandardError
                false
              end
            end
          elsif options.key?(:validate_with)
            define_method(:"valid_#{attr}?") do
              send(options[:validate_with])
            end
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

        def define_datetime_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attributes[attr].is_a?(DateTime) || valid_datetime?(attributes[attr])
          end
        end

        def valid_datetime?(value)
          DateTime.strptime(value)
          true
        rescue
          false
        end

        def define_float_attribute(attr, options)
          define_method("valid_#{attr}?") do
            value = attributes[attr]
            return false unless value.is_a?(String) || value.is_a?(Numeric)
            valid = valid_float?(value)
            if valid && options[:range]
              valid = options[:range].include?(value.to_f)
            end
            valid
          end
        end

        def define_integer_attribute(attr, options)
          define_method("valid_#{attr}?") do
            value = attributes[attr]
            return false unless value.is_a?(String) || value.is_a?(Numeric)
            valid = valid_integer?(value)
            if valid && options[:range]
              valid = options[:range].include? value.to_i
            end
            valid
          end
        end

      end

      private

      def valid_float?(value)
        Float(value)
        true
      rescue
        false
      end

      def valid_integer?(value)
        Integer(value).to_s == value.to_s
      rescue
        false
      end

    end
  end
end
