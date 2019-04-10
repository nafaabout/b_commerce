module BCommerce
  RSpec.describe Base do
    let(:store_hash){ rand.to_s }
    let(:client_id){ rand.to_s }
    let(:auth_token){ rand.to_s }
    let(:base){ Base.new }

    before do
      Base::API_VERSION = %i(v2 v3).sample
    end

    after do
      Base.send(:remove_const, :API_VERSION) if Base::API_VERSION
    end

    it 'defines API_HOST' do
      expect(Base::API_HOST).to eq('https://api.bigcommerce.com')
    end

    it 'defines HEADERS' do
      expect(Base::HEADERS).to eq({ 'accept' => 'application/json',
                                    'content-type' => 'application/json' })
    end

    describe '#store_hash' do
      context 'WHEN store_hash is set' do
        it 'returns store_hash set with .setup method' do
          Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
          expect(base.store_hash).to be store_hash
        end
      end

      context 'WHEN store_hash is not set' do
        it 'raises an error' do
          expect{ base.store_hash }.to raise_error(MissingCredentials)
        end
      end
    end

    describe '.client_id' do
      context 'WHEN client_is is set' do
        it 'returns client_id set with Base.setup' do
          Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
          expect(Base.client_id).to be(client_id)
        end
      end

      context 'WHEN client_id not set' do
        it 'raises and error' do
          expect{ base.client_id }.to raise_error(MissingCredentials)
        end
      end
    end

    describe '.auth_token' do
      context 'WHEN client_is is set' do
        it 'returns auth_token set with Base.setup' do
          Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
          expect(Base.auth_token).to be(auth_token)
        end
      end

      context 'WHEN auth_token not set' do
        it 'raises and error' do
          expect{ base.auth_token }.to raise_error(MissingCredentials)
        end
      end
    end

    describe '.setup(client_id:, store_hash:, auth_token:)' do
      it 'sets store_hash' do
        Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(Base.store_hash).to be store_hash
      end

      it "sets stores's auth_token" do
        Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(Base.auth_token).to be auth_token
      end

      it "sets application's client_id" do
        Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(Base.client_id).to be client_id
      end
    end

    describe '#base_url' do
      it 'returns API_HOST' do
        expect(base.base_url).to eq(Base::API_HOST)
      end
    end

    describe '#store_path' do
      it 'returns the /stores/{store_hash}/{API_VERSION}' do
				Base.setup(client_id: client_id, store_hash: store_hash, auth_token: auth_token)
        expect(base.store_path).to eq("/stores/#{store_hash}/#{Base::API_VERSION}")
      end
    end
  end
end
