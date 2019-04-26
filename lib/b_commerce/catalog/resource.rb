module BCommerce
  BOOLEAN = [true, false, 1, 0]
  VALID_DATE_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

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

      def valid?
        self.class.attributes.each do |attr|
          return false if !send(:"valid_#{attr}?")
        end
        true
      end

      def errors
        @errors ||= {}
      end

      class << self
        def attributes
          @attributes ||= []
        end

        def attribute(attr, options = {})
          if options[:type]
            type = options[:type].to_s.downcase
            send(:"define_#{type}_attribute", attr, options)
          elsif(options[:values])
            define_enum_attribute(attr, options)
          end
          self.attributes.push(attr.to_sym)
        end

        private

        def define_enum_attribute(attr, options)
          define_method("valid_#{attr}?") do
            valid_values = options[:values]
            if(!valid_values.include?(attributes[attr]))
              errors[attr.to_sym] = "invalid value #{attributes[attr].inspect} for attribute :type, valid values are #{valid_values.inspect}"
            end
            !errors.key?(attr)
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
            attr = attr.to_sym
            length_range = options[:length]
            attr_value = attributes[attr]

            valid = attr_value.is_a?(String)
            if valid && length_range
              valid = length_range.include?(attr_value.to_s.length)
            end

            if valid
              errors.delete(attr)
            else
              errors[attr] = "#{attr.inspect} should be a" +
                " string of length between #{length_range.min.inspect} and #{length_range.max.inspect}"
            end

            !errors.key?(attr)
          end
        end

        def define_datetime_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attr = attr.to_sym
            value = attributes[attr]

            if value.is_a?(DateTime)
              errors.delete(attr)
            elsif value.is_a?(String) && valid_datetime?(attributes[attr])
              errors.delete(attr)
            else
              errors[attr] = "#{value.inspect} is not valid Date for #{attr.inspect}, " +
                "valid value should be a DateTime instance or a string of the format " +
                "#{VALID_DATE_FORMAT.inspect} like #{DateTime.now.to_s.inspect}"
            end

            !errors.key?(attr)
          end
        end

        def define_float_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attr = attr.to_sym
            value = attributes[attr]
            return false unless value.is_a?(String) || value.is_a?(Numeric)

            range = options[:range]
            errors.delete(attr)

            if !valid_float?(value)
              errors[attr] = "#{value.inspect} is not valid value for #{attr.inspect}, it should be a Float"
            elsif range && !range.include?(value.to_f)
              errors[attr] = "#{value.inspect} is out of range, #{attr.inspect} should be a Float between #{range.min} and #{range.max}"
            end

            !errors.key?(attr)
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

      def valid_datetime?(value)
        DateTime.strptime(value)
        true
      rescue
        false
      end

    end
  end
end
