module BCommerce
  RSpec.describe Products do
    let(:id){ nil }
    let(:auth_token) { rand.to_s }
    let(:products) { Products.new(store_hash: 'a_hash', auth_token: auth_token, id: id) }

    it 'inherits from BCommerce::Base' do
      expect(Products).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(Products::PATH).to eq('/catalog/products')
      end
    end

    describe '#url' do
      context 'IF #id is empty' do
        let(:id) { nil }

        it 'returns store_url + products_path' do
          expect(products.url).to eq(products.store_url + Products::PATH)
        end
      end

      context 'IF #id is not empty' do
        let(:id){ rand(1000) }

        it 'returns store_url + Products::PATH + #id' do
          expect(products.url).to eq(products.store_url + Products::PATH + "/#{id}")
        end
      end
    end

    describe '#headers' do
      it 'returns Base::HEADERS + { "x-auth-token" => auth_token }' do
        expect(products.headers).to eq(Base::HEADERS.merge('x-auth-token' => auth_token))
      end
    end
  end
end
