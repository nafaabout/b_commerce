module QueryMethods

  def self.extended(base)
    base.include InstanceMethods
  end

  protected

  def generate_enum_params_query_methods(params:)
    params.each do |param, valid_values|
      define_method param do |filters = {}|
        if filters.is_a?(Array)
          filters = { in: filters }
        elsif filters.is_a?(Hash)
          check_filters(param, filters: filters.keys, valid_filters: self.class::ARRAY_FILTERS)
          values = filters.values.flatten
        else
          values = [filters].flatten
        end

        check_values(param, values: values, valid_values: valid_values)

        set_query(param, filters)

        self
      end
    end

  end

  def generate_non_enum_params_query_methods(params:)
    params.each do |param, type|
      define_method param do |filters = {}|
        if filters.is_a?(Array)
          values = filters
          filters = { in: filters }
        elsif filters.is_a?(Hash)
          check_filters(param, filters: filters.keys, valid_filters: valid_filters_for(type))
          values = filters.values.flatten
        else
          values = [filters].flatten
        end

        check_values_type(param, values: values, valid_type: type)

        set_query(param, filters)

        self
      end
    end

  end

  module InstanceMethods

    def query
      @query ||= {}
    end

    protected

    def set_query(param, filters)
      if filters.is_a?(Hash)
        filters.each do |f, v|
          query["#{param}:#{f}"] = v.is_a?(Array) ? v.join(',') : v
        end
      else
        query[param] = filters.is_a?(Array) ? filters.join(',') : filters
      end
    end

    def check_filters(param, filters:, valid_filters:)
      invalid_filters = Array(filters) - valid_filters
      if !invalid_filters.empty?
        raise BCommerce::InvalidFilters.new(invalid_filters, attr: param,
                                            valid_filters: valid_filters)
      end
    end

    def check_values_type(param, values:, valid_type:)
      meth = valid_type.to_s.downcase + '?'
      invalid_values = Array(values).select{ |v| !v.public_send(meth) }
      if !invalid_values.empty?
        raise BCommerce::InvalidValue.new(invalid_values, attr: param, valid_types: valid_type)
      end
    end

    def check_values(param, values:, valid_values:)
      invalid_values = values - valid_values
      if !invalid_values.empty?
        raise BCommerce::InvalidValue.new(invalid_values, attr: param, valid_values: valid_values)
      end
    end

    def valid_filters_for(type)
      if [Integer, Numeric].include?(type)
        self.class::NUMBER_FILTERS
      elsif type == String
        self.class::STRING_FILTERS
      else
        []
      end
    end
  end
end
