module QueryMethods

  def self.extended(base)
    puts "Extending #{base.to_s}"
    base.include InstanceMethods
  end

  protected

  def generate_enum_params_query_methods(params:)
    params.each do |param, values|
      define_method param do |filters = {}|
        if values.include?(filters)
          query[param] = filters
        elsif filters.is_a?(Hash)
          check_filters_validity(param, filters: filters)
          filters.each do |f, v|
            unless valid_value_for?(param, value: v)
              raise BCommerce::InvalidValue.new(v, valid_values: values)
            end
            query["#{param}:#{f}"] = v
          end
        else
          raise BCommerce::InvalidValue.new(filters, valid_values: values)
        end

        self
      end
    end

  end

  def generate_non_enum_params_query_methods(params:)
    params.each do |param, type|
      define_method param do |filters = {}|
        type_check_method = type.to_s.downcase + '?'
        if filters.is_a?(Hash)
          filters.each do |f, v|
            if !v.public_send(type_check_method)
              raise BCommerce::InvalidValue.new(v, valid_types: type)
            end
            query["#{param}:#{f}"] = send(type.to_s, v)
          end
        elsif filters.public_send(type_check_method)
          query[param] = send(type.to_s, filters)
        else
          raise BCommerce::InvalidValue.new(filters, valid_types: type)
        end

        self
      end
    end

  end

  module InstanceMethods

    protected

    def check_filters_validity(param, filters:)
      type = self.class::QUERY_PARAMS.dig(:enum, param)
      type ||= self.class::QUERY_PARAMS.dig(:not_enum, param)
      invalid_f = invalid_filters(param, filters.keys)
      if !invalid_f.empty?
        raise BCommerce::InvalidFilters.new(invalid_f, attr: :type,
                                            valid_filters: valid_filters_for(type))
      end
      true
    end

    def invalid_filters(type, filters)
      filters - valid_filters_for(type)
    end

    def valid_filters_for(type)
      if [Integer, Numeric].include?(type)
        self.class::NUMBER_FILTERS
      elsif type == String
        self.class::STRING_FILTERS
      elsif type.is_a?(Array)
        self.class::ARRAY_FILTERS
      else
        []
      end
    end

    def valid_value_for?(param, value:)
      type_or_values = self.class::QUERY_PARAMS[param]
      if type_or_values.is_a?(Array)
        type_or_values.include?(value)
      else
        value.is_a?(type_or_values)
      end
    end

  end
end
