module BCommerce
  module Catalog
    class TestList < ResourceList
      PATH = '/catalog/tests'
      API_VERSION = :v3
    end

    RSpec.describe ResourceList do
      let(:tests_list){ TestList.new }

      specify 'NUMBER_FILTERS is [:min, :max, :greater, :less, :in, :not_in]' do
        expect(ResourceList::NUMBER_FILTERS).to eq([:min, :max, :greater, :less, :in, :not_in])
      end

      specify 'ARRAY_FILTERS is [:in, :not_in]' do
        expect(ResourceList::ARRAY_FILTERS).to eq([:in, :not_in])
      end

      specify 'STRING_FILTERS is [:like, :in, :not_in]' do
        expect(ResourceList::STRING_FILTERS).to eq([:like, :in, :not_in])
      end

      describe '#all' do
        let(:page_one_tests){ { id: rand(100), title: 'some product title'} }
        let(:store_hash) { rand.to_s }
        let(:auth_token) { rand.to_s }
        let(:client_id) { rand.to_s }

        before do
          Base.setup(client_id: client_id,
                     store_hash: store_hash,
                     auth_token: auth_token)
        end

        it 'calls the api with the resource_list#path and #query' do
          page_one_tests = [{ name: 'Some Resource', price: rand }]
          tests_list.query[:id] = 234
          Excon.stub({ method: :get, path: tests_list.path, query: tests_list.query },
                     { body: { data: page_one_tests }.to_json })
          expect(tests_list.all).to eq(page_one_tests)
        end
      end
    end
  end
end
