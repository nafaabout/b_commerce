module BCommerce
  RSpec.describe Product do
    let(:auth_token) { rand.to_s }
    let(:products_con) { Product.new(store_hash: 'a_hash', auth_token: auth_token) }

    it 'inherits from BCommerce::Base' do
      expect(Product).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(Product::PATH).to eq('/catalog/products')
      end
    end

    describe '#url' do
      it "returns store_url + products_path" do
        expect(products_con.url).to eq(products_con.store_url + Product::PATH)
      end
    end

    describe '#headers' do
      it 'returns base headers + { "X-Auth-Token" => auth_token }' do
        expect(products_con.headers).to eq(Base::HEADERS.merge('X-Auth-Token' => auth_token))
      end
    end
  end
end
