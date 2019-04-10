module BCommerce
  module Catalog
    RSpec.describe ProductsList do
      let(:store_hash) { rand.to_s }
      let(:auth_token) { rand.to_s }
      let(:client_id) { rand.to_s }
      let(:products_list) { ProductsList.new }

      it 'inherits from BCommerce::ResourceList' do
        expect(ProductsList).to be < ResourceList
      end

      specify 'API_VERSION is :v3' do
        expect(ProductsList::API_VERSION).to be :v3
      end

      describe "PATH" do
        it "returns '/catalog/products'" do
          expect(ProductsList::PATH).to eq('/catalog/products')
        end
      end

      describe '#headers' do
        before do
          Base.setup(client_id: client_id,
                     store_hash: store_hash,
                     auth_token: auth_token)
        end

        it 'returns Base::HEADERS + { "x-auth-client" => client_id, "x-auth-token" => auth_token }' do
          expect(products_list.headers).to eq(Base::HEADERS.merge('x-auth-client' => client_id,
                                                             'x-auth-token' => auth_token))
        end
      end

      describe '#id' do
        it 'returns the self' do
          id = rand(1..100)
          expect(products_list.id(id)).to be(products_list)
        end

        context 'WHEN passed an Integer' do
          it 'sets the id filter on the query' do
            id = rand(1..100)
            expect{ products_list.id(id) }.to change{ products_list.query[:id] }.to(id)
          end

        end

        context "WHEN passed a non Integer" do
          it 'raises InvalidValue' do
            value = 'd24g'
            expect{ products_list.id(value) }.to raise_error(InvalidValue,
                                                        "Invalid value #{[value].inspect} for :id, expected value of type #{Integer.inspect}.")
          end
        end

        context 'WHEN passed a filters hash' do
          it 'sets the id:{filter} query for all the filters' do
            filters = { min: 23, max: 25 }
            expect{ products_list.id(filters) }.to change{ products_list.query }
              .to({ "id:min" => filters[:min], "id:max" => filters[:max] })
          end
        end

        context 'WHEN a value of a filter is not convertible to Integer' do
          it 'raises InvalidValue' do
            value = 'd24g'
            expect{ products_list.id(max: value) }.to raise_error(InvalidValue,
                                                             "Invalid value #{[value].inspect} for :id, expected value of type #{Integer.inspect}.")
          end
        end
      end

      describe '#type' do
        it 'returns self' do
          type = 'physical'
          expect(products_list.type(type)).to be(products_list)
        end

        context 'WHEN passed one of ["physical", "digital"]' do
          it 'sets type filter on the query' do
            type = %w(physical digital).sample
            expect{ products_list.type(type) }.to change{ products_list.query[:type] }.to(type)
          end
        end

        context 'WHEN passed value other than ["physical", "digital"]' do
          it 'raises InvalidValue' do
            value = 'not physical or digital'
            expect{ products_list.type(value) }.to raise_error(InvalidValue,
                                                          "Invalid value #{[value].inspect} for :type, expected one of #{['physical', 'digital'].inspect}.")
          end
        end

        context 'WHEN passed a filters hash' do
          it 'raises InvalidFilters error' do
            filters = { like: 'physical' }
            expect{ products_list.type(filters) }.to raise_error(InvalidFilters,
                                                            'Invalid filters [:like] for :type attribute, Valid filters are [:in, :not_in]')
          end
        end
      end

    end
  end
end
