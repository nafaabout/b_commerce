module BCommerce
  class ResourceList < Base
    extend QueryMethods

    ARRAY_FILTERS  = [:in, :not_in]
    NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
    STRING_FILTERS = [:like] + ARRAY_FILTERS

  end
end
