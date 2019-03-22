RSpec.describe BCommerce::Base do
  it 'defines API_HOST' do
    expect(BCommerce::Base::API_HOST).to eq('api.bigcommerce.com')
  end

  it 'defines BASE_PATH' do
    expect(BCommerce::Base::BASE_PATH).to eq({ v2: 'https://api.bigcommerce.com/stores/%{store_hash}/v2',
                                               v3: 'https://api.bigcommerce.com/stores/%{store_hash}/v3' })
  end

end
