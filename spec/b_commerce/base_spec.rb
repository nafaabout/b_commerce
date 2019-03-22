module BCommerce
  RSpec.describe Base do
    let(:store_hash){ rand.to_s }
    let(:auth_token){ rand.to_s }
    let(:instance){ Base.new(store_hash: store_hash, auth_token: auth_token) }

    it 'defines API_HOST' do
      expect(Base::API_HOST).to eq('api.bigcommerce.com')
    end

    it 'defines BASE_PATH' do
      expect(Base::BASE_PATH).to eq({ v2: '/stores/%{store_hash}/v2',
                                      v3: '/stores/%{store_hash}/v3' })
    end

    it 'defines HEADERS' do
      expect(Base::HEADERS).to eq({ 'Accept' => 'application/json',
                                    'Content-Type' => 'application/json' })
    end

    describe '.new(store_hash:, auth_token:)' do
      it 'returns an instance' do
        expect(instance).to be_instance_of(Base)
      end

      it 'sets #store_hash' do
        expect(instance.store_hash).to be(store_hash)
      end

      it 'sets #auth_token' do
        expect(instance.auth_token).to be(auth_token)
      end
    end

    describe '#store_url' do
      it 'returns "https://#{API_HOST}#{BASE_PATH[API_VERSION]}" % store_hash' do
        Base::API_VERSION = :v3
        puts instance.store_url
        expect(instance.store_url).to eq("https://#{Base::API_HOST}#{Base::BASE_PATH[:v3]}" % { store_hash: store_hash })
      end
    end
  end
end
