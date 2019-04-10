module BCommerce
  module Catalog
    RSpec.describe CategoriesList do
      let(:store_hash){ rand.to_s }
      let(:client_id){ rand.to_s }
      let(:auth_token){ rand.to_s }

      let(:categories_list){ CategoriesList.new }

      it 'inherits from BCommerce::ResourceList' do
        expect(CategoriesList).to be < ResourceList
      end

      specify 'PATH is /catalog/categories' do
        expect(CategoriesList::PATH).to eq '/catalog/categories'
      end

      specify 'API_VERSION is :v3' do
        expect(CategoriesList::API_VERSION).to be :v3
      end

      describe '#tree' do
        before do
          BCommerce::Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        end

        it 'returns all categories tree' do
          categories = [{
            "children": [],
            "id": 58,
            "is_visible": true,
            "name": "add",
            "parent_id": 0,
            "url": "/sports/"
          }]

          Excon.stub({ method: :get, path: "#{categories_list.path}/tree" }, { body: { data: categories }.to_json })
          expect(categories_list.tree).to eq(categories)
        end
      end
    end
  end
end
