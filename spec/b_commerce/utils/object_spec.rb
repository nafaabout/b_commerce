module BCommerce
  RSpec.describe Object do

    describe '#integer?' do
      it 'returns true if object is convertible to Integer' do
        expect("12").to be_integer
      end

      it 'returns false if object is not convertible to integer' do
        expect("[23]").to_not be_integer
        expect([23]).to_not be_integer
        expect({}).to_not be_integer
        expect(nil).to_not be_integer
        expect(false).to_not be_integer
        expect(true).to_not be_integer
      end
    end

    describe '#string?' do
      it 'returns true if object is convertible to Integer' do
        expect("12").to be_string
      end

      it 'returns false if object is not convertible to string' do
        expect(23).to_not be_string
        expect([23]).to_not be_string
        expect({}).to_not be_string
        expect(nil).to_not be_string
        expect(false).to_not be_string
        expect(true).to_not be_string
      end
    end
  end
end
