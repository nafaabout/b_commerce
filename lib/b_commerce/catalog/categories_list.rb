module BCommerce
  module Catalog
    class CategoriesList < ResourceList
      PATH = '/catalog/categories'
      API_VERSION = :v3

      QUERY_PARAMS = {
        enum: {
          is_visible: [true, false, 1, 0]
        },
        non_enum: {
          name: String,
          parent_id: Integer,
          page_title: String,
          keyword: String,
          page: Integer,
          limit: Integer,
          include_fields: String,
          exclude_fields: String,
          categories: String
        }
      }
      generate_enum_params_query_methods(params: QUERY_PARAMS[:enum])
      generate_non_enum_params_query_methods(params: QUERY_PARAMS[:non_enum])

      def tree
        resp = connection.get(path: "#{path}/tree")
        response_data(response: resp)
      end
    end
  end
end
