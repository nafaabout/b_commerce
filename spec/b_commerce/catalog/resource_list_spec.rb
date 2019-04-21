module BCommerce
  module Catalog
    class TestResource < Resource

    end

    class TestResourceList < ResourceList
      PATH = '/catalog/tests'
      API_VERSION = :v3

      QUERY_PARAMS = { id: Integer, name: String }
      generate_non_enum_params_query_methods(params: QUERY_PARAMS)
    end

    RSpec.describe ResourceList do
      let(:tests_list){ TestResourceList.new }

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

      describe '#where' do
        it 'sets the filters from the passed hash' do
          expect{ tests_list.where(id: { in: [12, 3] }, name: { like: 'hora' }) }.to\
            change{ tests_list.query }.to({ "id:in" => '12,3', "name:like" => 'hora' })
        end

        it 'returns self' do
          expect(tests_list.where()).to be(tests_list)
        end
      end

      describe '#create' do
        let(:attrs){ { id: rand(100), name: rand.to_s } }
        let(:test_resource){ TestResource.new(attrs) }

        it 'creates an instance of the resource with the given args' do
          expect(TestResource).to receive(:new).with(attrs).and_return(test_resource)
          tests_list.create(attrs)
        end

        it 'saves it to the store' do
          expect(test_resource).to receive(:save)
          expect(TestResource).to receive(:new).and_return(test_resource)
          tests_list.create({})
        end

        it 'returns the created resource' do
          allow(TestResource).to receive(:new).and_return(test_resource)
          expect(tests_list.create).to be(test_resource)
        end
      end
    end
  end
end
