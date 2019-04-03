module BCommerce
  RSpec.describe Base do
    let(:store_hash){ rand.to_s }
    let(:client_id){ rand.to_s }
    let(:auth_token){ rand.to_s }
    let(:instance){ Base.new }

    before do
      Base::API_VERSION = %i(v2 v3).sample
    end

    after do
      Base.send(:remove_const, :API_VERSION) if Base::API_VERSION
    end

    it 'defines API_HOST' do
      expect(Base::API_HOST).to eq('api.bigcommerce.com')
    end

    it 'defines STORE_PATH' do
      expect(Base::STORE_PATH).to eq({ v2: '/stores/%{store_hash}/v2',
                                       v3: '/stores/%{store_hash}/v3' })
    end

    it 'defines HEADERS' do
      expect(Base::HEADERS).to eq({ 'accept' => 'application/json',
                                    'content-type' => 'application/json' })
    end

    # describe '.stores_auth_tokens' do
    #   it 'returns a Hash of auth_tokens previously cached by Base.setup' do
    #     tokens = { 'store_hash_1' => 'token_1', 'store_hash_2' => 'token_2' }
    #     tokens.each do |store_hash, auth_token|
    #       Base.setup(client_id: 'id', store_hash: store_hash, auth_token: auth_token)
    #     end
    #     expect(Base.stores_auth_tokens).to eq(tokens)
    #   end
    # end
    #
    # describe '.auth_token_for(store_hash:)' do
    #   it 'returns Base.stores_auth_tokens[store_hash]' do
    #     Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
    #     expect(Base.auth_token_for(store_hash: store_hash)).to be(auth_token)
    #   end
    # end

    describe '.client_id' do
      it 'returns client_id set with Base.setup' do
        Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(Base.client_id).to be(client_id)
      end
    end

    describe '.setup(client_id:, store_hash:, auth_token:)' do
      it 'sets store_hash' do
        expect{ Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token) }.to\
          change{ Base.store_hash }.to(store_hash)
      end

      it "sets stores's auth_token" do
        expect{ Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token) }.to\
          change{ Base.auth_token }.to(auth_token)
      end

      it "sets application's client_id" do
        expect{ Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token) }.to\
          change{ Base.client_id }.to(client_id)
      end
    end

    describe '#base_url' do
      it 'returns "https://#{API_HOST}#{STORE_PATH[API_VERSION]}" % store_hash' do
        expect(instance.base_url).to eq("https://#{Base::API_HOST}")
      end
    end

    describe '#store_path' do
      it 'returns the /stores/{store_hash}/{API_VERSION}' do
				Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(instance.store_path).to eq("#{Base::STORE_PATH[Base::API_VERSION]}" % { store_hash: store_hash })
      end
    end
  end
end
