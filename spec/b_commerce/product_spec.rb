module BCommerce
  RSpec.describe Product do
    let(:id){ nil }
    let(:auth_token) { rand.to_s }
    let(:products_con) { Product.new(store_hash: 'a_hash', auth_token: auth_token, id: id) }

    it 'inherits from BCommerce::Base' do
      expect(Product).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(Product::PATH).to eq('/catalog/products')
      end
    end

    describe '#url' do
      context 'IF #id is empty' do
        let(:id) { nil }

        it 'returns store_url + products_path' do
          expect(products_con.url).to eq(products_con.store_url + Product::PATH)
        end
      end

      context 'IF #id is not empty' do
        let(:id){ rand(1000) }

        it 'returns store_url + Product::PATH + #id' do
          expect(products_con.url).to eq(products_con.store_url + Product::PATH + "/#{id}")
        end
      end
    end

    describe '#headers' do
      it 'returns Base::HEADERS + { "x-auth-token" => auth_token }' do
        expect(products_con.headers).to eq(Base::HEADERS.merge('x-auth-token' => auth_token))
      end
    end
  end
end
