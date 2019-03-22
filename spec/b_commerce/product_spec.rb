module BCommerce
  RSpec.describe Product do
    it 'inherits from BCommerce::Base' do
      expect(Product).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(Product::PATH).to eq('/catalog/products')
      end
    end

    describe '#url' do
      let(:products_con) { Product.new(store_hash: 'a_hash', auth_token: 'a_token') }

      it "returns store_url + products_path" do
        expect(products_con.url).to eq(products_con.store_url + Product::PATH)
      end
    end

    describe '#headers'
  end
end
