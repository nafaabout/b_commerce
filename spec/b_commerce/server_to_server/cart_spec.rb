module BCommerce
  module ServerToServer
    RSpec.describe Cart do
      let(:attributes) {
        {
          customer_id: {
            type: Integer},
            line_items: {
              type: Array,
              validate_with: :validate_line_items
            },
            gift_certificates: {
              type: Array,
              validate_with: :validate_gift_certificates
            }
        }
      }

      it 'has validation methods for all cart attributes' do
        attributes.each do |attr, options|
          expect(Cart.attributes[attr]).to eq(options), "expected #{options.inspect} for #{attr.inspect}, got #{Cart.attributes[attr]}"
        end
      end
    end
  end
end
