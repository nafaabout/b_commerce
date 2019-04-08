module BCommerce

  class InvalidFilters < StandardError
    def initialize(invalid_filters, attr:, valid_filters:)
      message = "Invalid filters #{invalid_filters.inspect} for #{attr.inspect} attribute"
      message += ", Valid filters are #{valid_filters.inspect}" if valid_filters.size > 0
      super(message)
    end
  end

  class InvalidValue < StandardError
    def initialize(value, attr:, valid_types: nil, valid_values: nil)
      if valid_types
        super("Invalid value #{value.inspect} for #{attr.inspect}, expected value of type #{valid_types.inspect}.")
      elsif valid_values
        super("Invalid value #{value.inspect} for #{attr.inspect}, expected one of #{valid_values.inspect}.")
      else
        super("Invalid value #{value.inspect} for #{attr.inspect}")
      end
    end
  end

end
