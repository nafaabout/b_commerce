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
        self.class.attributes.each_key do |attr|
          return false if !send(:"valid_#{attr}?")
        end
        true
      end

      def errors
        @errors ||= {}
      end

      class << self
        def attributes
          @attributes ||= {}
        end

        def attribute(attr, options = {})
          if options[:type]
            type = options[:type].to_s.downcase
            send(:"define_#{type}_attribute", attr, options)
          elsif(options[:values])
            define_enum_attribute(attr, options)
          end
          self.attributes[attr.to_sym] = options
        end

        private

        def define_enum_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attr = attr.to_sym
            valid_values = options[:values]
            value = attributes[attr]

            errors.delete(attr)
            if(!valid_values.include?(value))
              errors[attr] = "Invalid value #{value.inspect} for attribute #{attr.inspect}, valid values are #{valid_values.inspect}"
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
              attr = attr.to_sym
              value = attributes[attr]
              type = options[:values_type]

              errors.delete(attr)

              if !value.is_a?(Array)
                errors[attr] = "#{value.inspect} is invalid, #{attr.inspect} must be an Array"
                if type
                  errors[attr] += " of #{type.inspect}s"
                end
              else
                type_method = type.to_s
                value.all? do |v|
                  send(type_method, v)
                rescue StandardError
                  errors[attr] = "#{v.inspect} is not valid for #{attr.inspect}," +
                    " all values must be #{type.inspect}s"
                end
              end

              !errors.key?(attr)
            end
          elsif options.key?(:validate_with)
            define_method(:"valid_#{attr}?") do
              attr = attr.to_sym
              value = attributes[attr]
              validation_meth = options[:validate_with]

              errors.delete(attr)

              if !send(validation_meth)
                errors[attr] = "#{value.inspect} is invalid for #{attr.inspect} per #{validation_meth.inspect} method"
              end

              !errors.key?(attr)
            end
          end
        end

        def define_string_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attr = attr.to_sym
            length_range = options[:length]
            attr_value = attributes[attr]

            errors.delete(attr)

            if !attr_value.is_a?(String)
              errors[attr] = "#{attr_value.inspect} is not a valid value, #{attr.inspect} must be a String."
            elsif length_range && !length_range.include?(attr_value.to_s.length)
              errors[attr] = "#{attr.inspect} should be a" +
                " String of length between #{length_range.min.inspect} and #{length_range.max.inspect}"
            end

            !errors.key?(attr)
          end
        end

        def define_datetime_attribute(attr, options)
          define_method("valid_#{attr}?") do
            attr = attr.to_sym
            value = attributes[attr]

            errors.delete(attr)

            if !value.is_a?(DateTime) &&
                !(value.is_a?(String) && valid_datetime?(attributes[attr]))

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
            attr = attr.to_sym
            value = attributes[attr]
            return false unless value.is_a?(String) || value.is_a?(Numeric)

            errors.delete(attr)
            range = options[:range]

            if !valid_integer?(value)
              errors[attr] = "#{value.inspect} is not a valid value for" +
                " #{attr.inspect}, it must be an Integer"
            elsif range && !range.include?(value.to_i)
              errors[attr] = "#{value.inspect} is out of range, #{attr.inspect} must be an Integer between #{range.min} and #{range.max}"
            end

            !errors.key?(attr)
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
