module BCommerce
  module Catalog
    class CategoriesList < ResourceList
      PATH = '/catalog/categories'
      API_VERSION = :v3

      def tree
        resp = connection.get(path: "#{path}/tree")
        response_data(response: resp)
      end
    end
  end
end
