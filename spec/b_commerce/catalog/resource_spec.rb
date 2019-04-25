module BCommerce
  module Catalog

    class SomeResource < Resource

      private
      def validate_custom_fields
        true
      end
    end

    RSpec.describe Resource do

      it 'inherits from BCommerce::Base' do
        expect(Resource).to be < Base
      end

      describe '.attribute' do
        let(:some_resource){ SomeResource.new }

        context 'FOR Enum attribute' do
          before do
            SomeResource.attribute :type, values: ['physical', 'digital']
          end

          it 'generates valid_#{attr}? method' do
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
          before do
            SomeResource.attribute :name, type: String, length: 1..255
          end

          it 'generates valid_#{attr}? method' do
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

        context 'FOR Array attribute' do
          before do
            SomeResource.attribute :categories, type: Array, values_type: Integer
          end

          it 'generates valid_#{attr}? method' do
            expect(some_resource).to respond_to(:valid_categories?)
          end

          context 'IF :values_type passed' do

            context 'AND all values are of the given type' do
              it 'returns true' do
                some_resource.attributes[:categories] = [13, '24']
                expect(some_resource.valid_categories?).to be true
              end
            end

            context 'AND some values are not of the given type' do
              it 'returns false' do
                some_resource.attributes[:categories] = [13, 'f4']
                expect(some_resource.valid_categories?).to be false
              end
            end
          end

          context 'IF :values_type NOT passed OR not a Class' do
            context 'AND :validate_with is passed' do
              it 'generated method calls method passed in :validate_with' do
                expect(some_resource).to receive(:validate_custom_fields)
                SomeResource.attribute(:custom_fields, type: Array, validate_with: :validate_custom_fields)
                some_resource.valid_custom_fields?
              end
            end

            context 'AND :validate_with is NOT passed' do
              it 'raises an error' do
                expect{ SomeResource.attribute(:goodies, type: Array) }.to \
                  raise_error(ArgumentError, 'For type Array, :values_type or :validate_with arguments should be passed.')
              end
            end
          end
        end

        context 'FOR Boolean attribute' do
          before do
            SomeResource.attribute :is_visible, values: BOOLEAN
          end

          it 'generates valid_#{attr}? method' do
            expect(some_resource).to respond_to(:valid_is_visible?)
          end

          context 'IF attribute value is a Boolean' do
            specify 'generated method returns true' do
              BOOLEAN.each do |val|
                some_resource.attributes[:is_visible] = val
                expect(some_resource.valid_is_visible?).to be(true),\
                  "#{val.inspect} not valid, valid values are #{BOOLEAN.inspect}"
              end
            end
          end

          context 'IF attribute value is not a Boolean' do
            specify 'generated method returns true' do
              some_resource.attributes[:is_visible] = 'true'
              expect(some_resource.valid_is_visible?).to be false
            end
          end
        end

        context 'FOR Integer attribute' do
          before do
            SomeResource.attribute :inventory_level, type: Integer, range: (0..100)
          end

          it 'generates valid_#{attr}? method' do
            expect(some_resource).to respond_to(:valid_inventory_level?)
          end

          context 'IF attribute value is an Integer' do
            it 'returns true' do
              some_resource.attributes[:inventory_level] = '44'
              expect(some_resource.valid_inventory_level?).to be true
              some_resource.attributes[:inventory_level] = 34
              expect(some_resource.valid_inventory_level?).to be true
            end
          end

          context 'IF attribute value is NOT an Integer' do
            it 'returns false' do
              some_resource.attributes[:inventory_level] = 'er2'
              expect(some_resource.valid_inventory_level?).to be false
              some_resource.attributes[:inventory_level] = 2.4
              expect(some_resource.valid_inventory_level?).to be false
            end
          end

          context 'IF attribute value is in given range' do
            it 'returns true' do
              some_resource.attributes[:inventory_level] = rand(0..100)
              expect(some_resource.valid_inventory_level?).to be true
            end
          end

          context 'IF attribute value is NOT in given range' do
            it 'returns false' do
              some_resource.attributes[:inventory_level] = rand(101..1000)
              expect(some_resource.valid_inventory_level?).to be false
              some_resource.attributes[:inventory_level] = rand(-100..-1)
              expect(some_resource.valid_inventory_level?).to be false
            end
          end
        end

        context 'FOR Float attribute' do
          before do
            SomeResource.attribute :weight, type: Float, range: (0..100)
          end

          it 'generates valid_#{attr}? method' do
            expect(some_resource).to respond_to(:valid_weight?)
          end

          context 'IF attribute value is a Float' do
            it 'returns true' do
              some_resource.attributes[:weight] = '44'
              expect(some_resource.valid_weight?).to be true
              some_resource.attributes[:weight] = 34
              expect(some_resource.valid_weight?).to be true
            end
          end

          context 'IF attribute value is NOT a Float' do
            it 'returns false' do
              some_resource.attributes[:weight] = 'er2'
              expect(some_resource.valid_weight?).to be false
            end
          end

          context 'IF attribute value is in given range' do
            it 'returns true' do
              some_resource.attributes[:weight] = 10.5
              expect(some_resource.valid_weight?).to be true
            end
          end

          context 'IF attribute value is NOT in given range' do
            it 'returns false' do
              some_resource.attributes[:weight] = 101.6
              expect(some_resource.valid_weight?).to be false
              some_resource.attributes[:weight] = -2
              expect(some_resource.valid_weight?).to be false
            end
          end
        end

        context 'FOR DateTime attribute' do
          before do
            SomeResource.attribute :preorder_release_date, type: DateTime
          end

          it 'generates valid_#{attr}? method' do
            expect(some_resource).to respond_to(:valid_preorder_release_date?)
          end

          context 'IF attribute value is a valid datetime string of the format ("%Y-%m-%dT%H:%M:%S%z")' do
            it 'returns true' do
              some_resource.attributes[:preorder_release_date] = '2019-04-24T19:08:48+01:00'
              expect(some_resource.valid_preorder_release_date?).to be true
            end
          end

          context 'IF attribute value is NOT a valid datetime' do
            it 'returns false' do
              some_resource.attributes[:preorder_release_date] = '2019-04-24 19:08:48'
              expect(some_resource.valid_preorder_release_date?).to be false
            end
          end
        end
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
