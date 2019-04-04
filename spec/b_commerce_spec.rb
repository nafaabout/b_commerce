RSpec.describe BCommerce do
  it "has a version number" do
    expect(BCommerce::VERSION).not_to be nil
  end

  describe '.[]' do
    it 'returns the #{Resource}List class' do
      expect(BCommerce[:products]).to be(BCommerce::ProductsList)
    end

    it 'raise an error NameError: uninitialized constant BCommerce::#{Resource}List' do
      expect{ BCommerce[:strange_resource] }.to raise_error(NameError)
    end
  end
end
