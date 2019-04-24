module BCommerce
  module Catalog

    class SomeResource < Resource
      attribute :type, values: ['physical', 'digital']
      attribute :name, type: String, length: 1..255
    end

    RSpec.describe Resource do

      it 'inherits from BCommerce::Base' do
        expect(Resource).to be < Base
      end

      describe '.attribute' do
        let(:some_resource){ SomeResource.new }

        context 'FOR Enum attribute' do
          it 'generates validation method' do
            expect(some_resource).to respond_to(:valid_type?)
          end

          context 'IF attribute value is in the enum' do
            specify 'generated method returns true' do
              some_resource.attributes[:type] = 'physical'
              expect(some_resource.valid_type?).to be true
            end
          end

          context 'IF attribute value is not in the enum' do
            specify 'generated method returns false' do
              some_resource.attributes[:type] = 'not_in_enum_values'
              expect(some_resource.valid_type?).to be false
            end
          end
        end

        context 'FOR string attribute' do
          it 'generates validation method' do
            expect(some_resource).to respond_to(:valid_name?)
          end

          context 'IF attribute value length is within length range' do
            specify 'valid_#{attr}? method returns true' do
              some_resource.attributes[:name] = 'not long name'
              expect(some_resource.valid_name?).to be true
            end
          end

          context 'IF attribute value length is NOT in length range' do
            specify 'valid_#{attr}? method returns false' do
              some_resource.attributes[:name] = ''
              expect(some_resource.valid_name?).to be false
              some_resource.attributes[:name] = 's' * 256
              expect(some_resource.valid_name?).to be false
            end
          end
        end

        context 'FOR Array attribute'
        context 'FOR Boolean attribute'
        context 'FOR Integer attribute'
        context 'FOR Float attribute'
        context 'FOR DateTime attribute'
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
