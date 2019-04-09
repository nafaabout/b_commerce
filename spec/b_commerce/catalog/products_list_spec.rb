module BCommerce
 RSpec.describe ProductsList do
    let(:store_hash) { rand.to_s }
    let(:auth_token) { rand.to_s }
    let(:client_id) { rand.to_s }
    let(:products) { ProductsList.new }

    it 'inherits from BCommerce::Base' do
      expect(ProductsList).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(ProductsList::PATH).to eq('/catalog/products')
      end
    end

    describe '#headers' do
      before do
        ProductsList.setup(client_id: client_id,
                           store_hash: store_hash,
                           auth_token: auth_token)
      end

      it 'returns Base::HEADERS + { "x-auth-client" => client_id, "x-auth-token" => auth_token }' do
        expect(products.headers).to eq(Base::HEADERS.merge('x-auth-client' => client_id,
                                                           'x-auth-token' => auth_token))
      end
    end

    describe '#id' do
      it 'returns the self' do
        id = rand(1..100)
        expect(products.id(id)).to be(products)
      end

      context 'WHEN passed an Integer' do
        it 'sets the id filter on the query' do
          id = rand(1..100)
          expect{ products.id(id) }.to change{ products.query[:id] }.to(id)
        end

      end

      context "WHEN passed a non Integer" do
        it 'raises InvalidValue' do
          value = 'd24g'
          expect{ products.id(value) }.to raise_error(InvalidValue,
                                                      "Invalid value #{[value].inspect} for :id, expected value of type #{Integer.inspect}.")
        end
      end

      context 'WHEN passed a filters hash' do
        it 'sets the id:{filter} query for all the filters' do
          filters = { min: 23, max: 25 }
          expect{ products.id(filters) }.to change{ products.query }
            .to({ "id:min" => filters[:min], "id:max" => filters[:max] })
        end
      end

      context 'WHEN a value of a filter is not convertible to Integer' do
        it 'raises InvalidValue' do
          value = 'd24g'
          expect{ products.id(max: value) }.to raise_error(InvalidValue,
                                                           "Invalid value #{[value].inspect} for :id, expected value of type #{Integer.inspect}.")
        end
      end
    end

    describe '#type' do
      it 'returns self' do
        type = 'physical'
        expect(products.type(type)).to be(products)
      end

      context 'WHEN passed one of ["physical", "digital"]' do
        it 'sets type filter on the query' do
          type = %w(physical digital).sample
          expect{ products.type(type) }.to change{ products.query[:type] }.to(type)
        end
      end

      context 'WHEN passed value other than ["physical", "digital"]' do
        it 'raises InvalidValue' do
          value = 'not physical or digital'
          expect{ products.type(value) }.to raise_error(InvalidValue,
                                                        "Invalid value #{[value].inspect} for :type, expected one of #{['physical', 'digital'].inspect}.")
        end
      end

      context 'WHEN passed a filters hash' do
        it 'raises InvalidFilters error' do
          filters = { like: 'physical' }
          expect{ products.type(filters) }.to raise_error(InvalidFilters,
                                                          'Invalid filters [:like] for :type attribute, Valid filters are [:in, :not_in]')
        end
      end
    end

    describe '#all' do
      let(:page_one_products){ { id: rand(100), title: 'some product title'} }

      before do
        ProductsList.setup(client_id: client_id,
                           store_hash: store_hash,
                           auth_token: auth_token)
      end

      it 'returns page 1 of products of the store from Bigcommerce' do

        Excon.stub({ method: :get, path: products.path }, { body: { data: page_one_products }.to_json })
        expect(products.all).to eq(page_one_products)
      end
    end
 end
end