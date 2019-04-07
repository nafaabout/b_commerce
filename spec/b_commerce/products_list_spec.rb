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
                                                      "Invalid value #{value.inspect}, expected value of type #{Integer.inspect}.")
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
                                                           "Invalid value #{value.inspect}, expected value of type #{Integer.inspect}.")
        end
      end
    end

    describe '#name' do
      it 'returns self' do
        name = "some_name"
        expect(products.name(name)).to be(products)
      end

      context 'WHEN passed a String' do
        it 'sets name filter on the query' do
          name = 'some name'
          expect{ products.name(name) }.to change{ products.query[:name] }.to(name)
        end
      end

      context 'WhEN passed a non String' do
        it 'raises InvalidValue' do
          value = 123
          expect{ products.name(value) }.to raise_error(InvalidValue,
                                                        "Invalid value #{value.inspect}, expected value of type #{String.inspect}.")
        end
      end

      context 'WHEN passed a filters hash' do
        it 'sets the name:{filter} query for all the filters' do
          filters = { like: 'Hora' }
          expect{ products.name(filters) }.to change{ products.query }
            .to({ "name:like" => filters[:like] })
        end
      end

      context 'WHEN a value of a filter is not a String' do
        it 'raises InvalidValue' do
          value = 234
          expect{ products.name(like: value) }.to raise_error(InvalidValue,
                                                              "Invalid value #{value.inspect}, expected value of type #{String.inspect}.")
        end
      end
    end

    describe '#all' do
      let(:page_one_products){ { id: rand(100), title: 'some product title'} }

      it 'returns page 1 of products of the store from Bigcommerce' do
        Excon.stub({ method: :get, path: products.path }, { body: { data: page_one_products }.to_json })
        expect(products.all).to eq(page_one_products)
      end
    end
 end
end
