module BCommerce
  RSpec.describe Products do
    let(:id){ nil }
    let(:auth_token) { rand.to_s }
    let(:client_id){ rand.to_s }
    let(:products) { Products.new(store_hash: 'a_hash',
                                  client_id: client_id,
                                  auth_token: auth_token,
                                  id: id) }

    it 'inherits from BCommerce::Base' do
      expect(Products).to be < Base
    end

    describe "PATH" do
      it "returns '/catalog/products'" do
        expect(Products::PATH).to eq('/catalog/products')
      end
    end

    describe '#headers' do
      it 'returns Base::HEADERS + { "x-auth-client" => client_id, "x-auth-token" => auth_token }' do
        expect(products.headers).to eq(Base::HEADERS.merge('x-auth-client' => client_id,
                                                           'x-auth-token' => auth_token))
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
