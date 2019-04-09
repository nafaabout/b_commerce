module BCommerce
  class ResourceList < Base
    extend QueryMethods

    ARRAY_FILTERS  = [:in, :not_in]
    NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
    STRING_FILTERS = [:like] + ARRAY_FILTERS

    def all
      resp = connection.get(path: path, query: query)
      resources = JSON(resp.body, symbolize_names: true)
      resources[:data] if resources
    end
  end
end
