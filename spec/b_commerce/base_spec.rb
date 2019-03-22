RSpec.describe BCommerce::Base do
  it 'defines API_HOST' do
    expect(BCommerce::Base::API_HOST).to eq('api.bigcommerce.com')
  end

  it 'defines BASE_PATH' do
    expect(BCommerce::Base::BASE_PATH).to eq({ v2: 'https://api.bigcommerce.com/stores/%{store_hash}/v2',
                                               v3: 'https://api.bigcommerce.com/stores/%{store_hash}/v3' })
  end

  it 'defines HEADERS' do
    expect(BCommerce::Base::HEADERS).to eq({ 'Accept' => 'application/json',
                                             'Content-Type' => 'application/json' })
  end

  describe '.new(store_hash:, auth_token:)' do
    let(:store_hash){ rand.to_s }
    let(:auth_token){ rand.to_s }
    let(:instance){ BCommerce::Base.new(store_hash: store_hash, auth_token: auth_token) }

    it 'returns an instance' do
      expect(instance).to be_instance_of(BCommerce::Base)
    end

    it 'sets #store_hash' do
      expect(instance.store_hash).to be(store_hash)
    end

    it 'sets #auth_token' do
      expect(instance.auth_token).to be(auth_token)
    end
  end
end
