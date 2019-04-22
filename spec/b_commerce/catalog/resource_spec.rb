module BCommerce
  module Catalog

    class SomeResource < Resource

    end

    RSpec.describe Resource do

      it 'inherits from BCommerce::Base' do
        expect(Resource).to be < Base
      end

      describe '#new' do
        it 'raise and error if called on Resource' do
          expect{ Resource.new }.to raise_error('BCommerce::Catalog::Resouce cannot be instantiated directly')
        end

        it 'creates an instance of the resource called on' do
          expect(SomeResource.new).to be_a(SomeResource)
        end

        it 'sets the #attributes to the given attributes' do
          attrs = { id: rand(100), name: rand.to_s }
          res = SomeResource.new(attrs)
          expect(res.attributes).to be(attrs)
        end
      end

      describe '#save'
      describe '#update'
      describe '#delete'
    end

  end
end
