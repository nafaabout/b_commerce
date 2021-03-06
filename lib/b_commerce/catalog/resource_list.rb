# frozen_string_literal: true
module BCommerce
  module Catalog
    class ResourceList < Base
      extend QueryMethods
      API_VERSION = 'v3'

      ARRAY_FILTERS  = [:in, :not_in]
      NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
      STRING_FILTERS = [:like] + ARRAY_FILTERS

      def all
        resp = connection.get(path: path, query: query)
        response_data(response: resp)
      end

      def where(filters = {})
        filters.each do |filter, value|
          send(filter, value)
        end
        self
      end

      def create(attrs = {})
        resource = resource_class.new(attrs)
        resource.save
        resource
      end

      def delete
        connection.delete(path: path, query: query)
      end

      protected

      def response_data(response:)
        resources = JSON(response.body, symbolize_names: true)
        resources[:data] if resources
      end

      def resource_class
        return @resource_class if @resource_class
        class_name = self.class.to_s
        class_name['List'] = ''
        @resource_class = eval(class_name)
      end
    end
  end
end
