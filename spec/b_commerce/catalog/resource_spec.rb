module BCommerce
  module Catalog

    RSpec.describe Resource do
      let(:resourceClass){ Class.new(Resource) }
      let(:resource){ resourceClass.new }

      it 'inherits from BCommerce::Base' do
        expect(Resource).to be < Base
      end

      describe '.attribute' do
        it 'adds the attribute with its options to .attributes hash' do
          expect{ resourceClass.attribute :name, type: String, length: 1..100 }.to\
            change{ resourceClass.attributes }.from({}).to({name: { type: String, length: 1..100 }})
        end

        context 'FOR Enum attribute' do
          let(:valid_types){ ['physical', 'digital'] }
          before do
            resourceClass.attribute :type, values: valid_types
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_type?)
          end

          context 'IF attribute value is in the enum' do
            specify 'valid_#{attr}? method returns true' do
              resource.attributes[:type] = 'physical'
              expect(resource.valid_type?).to be true
            end

            specify 'valid_#{attr}? method does not set #errors[attr]' do
              resource.attributes[:type] = 'physical'
              expect(resource.errors[:type]).to be nil
            end
          end

          context 'IF attribute value is not in the enum' do
            specify 'valid_#{attr}? method returns false' do
              resource.attributes[:type] = 'not_in_enum_values'
              expect(resource.valid_type?).to be false
            end

            specify 'valid_#{attr}? method sets #errors[attr]' do
              value = 'some value'
              resource.attributes[:type] = value
              resource.valid_type?
              expect(resource.errors[:type ]).to eq("Invalid value #{value.inspect} for attribute :type, valid values are #{valid_types.inspect}")
            end

          end
        end

        context 'FOR string attribute' do
          before do
            resourceClass.attribute :name, type: String, length: 1..255
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_name?)
          end

          context 'IF attribute value is NOT a string' do
            let(:value){ [:an_array, :not_a_string] }

            before do
              resource.attributes[:name] = value
            end

            specify 'valid_#{attr}? method returns false' do
              expect(resource.valid_name?).to be false
            end

            specify 'valid_#{attr}? method sets errors[attr]' do
              resource.valid_name?
              expect(resource.errors[:name]).to eq("#{value.inspect} is not a valid value, :name must be a String.")
            end
          end

          context 'IF attribute value length is within length range' do
            specify 'valid_#{attr}? method returns true' do
              resource.attributes[:name] = 'not long name'
              expect(resource.valid_name?).to be true
            end

          end

          context 'IF attribute value length is NOT in length range' do
            specify 'valid_#{attr}? method returns false' do
              resource.attributes[:name] = ''
              expect(resource.valid_name?).to be false
              resource.attributes[:name] = 's' * 256
              expect(resource.valid_name?).to be false
            end

            specify 'valid_#{attr}? method sets #errors[attr]' do
              resource.attributes[:name] = 'm' * 256
              resource.valid_name?
              expect(resource.errors[:name]).to eq(":name should be a" +
                                                   " String of length between #{1.inspect} and #{255.inspect}")
            end
          end
        end

        context 'FOR Array attribute' do
          before do
            resourceClass.attribute :categories, type: Array, values_type: Integer
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_categories?)
          end

          context 'IF :values_type passed' do

            context 'AND values is not an Array' do
              let(:value) { { value: :not_array } }

              before do
                resource.attributes[:categories] = value
              end

              specify 'valid_#{attr}? returns false' do
                expect(resource.valid_categories?).to be false
              end

              specify 'valid_#{attr}? sets errors[attr]' do
                resource.valid_categories?
                expect(resource.errors[:categories]).to eq("#{value.inspect} is invalid, :categories must be an Array of Integers")
              end
            end

            context 'AND all values are of the given type' do
              it 'returns true' do
                resource.attributes[:categories] = [13, '24']
                expect(resource.valid_categories?).to be true
              end
            end

            context 'AND some values are not of the given type' do
              let(:values) { [13, 'f4'] }

              before do
                resource.attributes[:categories] = values
              end

              specify 'valid_#{attr}? method sets #errors[attr]' do
                resource.attributes[:categories] = values
                resource.valid_categories?
                expect(resource.errors[:categories]).to\
                  eq("#{values[1].inspect} is not valid for :categories," +
                    " all values must be #{Integer.inspect}s")
              end

              it 'returns false' do
                expect(resource.valid_categories?).to be false
              end
            end
          end

          context 'IF :values_type NOT passed OR not a Class' do
            context 'AND :validate_with is passed' do
              before do
                resourceClass.attribute(:custom_fields, type: Array, validate_with: :validate_custom_fields)
              end

              it 'valid_#{attr}? method calls method passed in :validate_with' do
                expect(resource).to receive(:validate_custom_fields)
                resource.valid_custom_fields?
              end

              context 'IF method returns false' do
                it 'sets errors[attr]' do
                  expect(resource).to receive(:validate_custom_fields).and_return(false)
                  value = { name: 'Hora', size: 234 }
                  resource.attributes[:custom_fields] = value
                  resource.valid_custom_fields?
                  expect(resource.errors[:custom_fields]).to eq("#{value.inspect} is invalid for :custom_fields per :validate_custom_fields method")
                end
              end
            end

            context 'AND :validate_with is NOT passed' do
              it 'raises an error' do
                expect{ resourceClass.attribute(:goodies, type: Array) }.to \
                  raise_error(ArgumentError, 'For type Array, :values_type or :validate_with arguments should be passed.')
              end
            end
          end
        end

        context 'FOR Boolean attribute' do
          before do
            resourceClass.attribute :is_visible, values: BOOLEAN
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_is_visible?)
          end

          context 'IF attribute value is a Boolean' do
            specify 'valid_#{attr}? method returns true' do
              BOOLEAN.each do |val|
                resource.attributes[:is_visible] = val
                expect(resource.valid_is_visible?).to be(true),\
                  "#{val.inspect} not valid, valid values are #{BOOLEAN.inspect}"
              end
            end
          end

          context 'IF attribute value is not a Boolean' do
            specify 'valid_#{attr}? method returns true' do
              resource.attributes[:is_visible] = 'true'
              expect(resource.valid_is_visible?).to be false
            end
          end
        end

        context 'FOR Integer attribute' do
          before do
            resourceClass.attribute :inventory_level, type: Integer, range: (0..100)
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_inventory_level?)
          end

          context 'IF attribute value is an Integer' do
            it 'returns true' do
              resource.attributes[:inventory_level] = '44'
              expect(resource.valid_inventory_level?).to be true
              resource.attributes[:inventory_level] = 34
              expect(resource.valid_inventory_level?).to be true
            end
          end

          context 'IF attribute value is NOT an Integer' do
            specify 'valid_#{attr}? method sets #errors[attr]' do
              value = 'df3'
              resource.attributes[:inventory_level] = value
              resource.valid_inventory_level?
              expect(resource.errors[:inventory_level]).to\
                eq("#{value.inspect} is not a valid value for" +
                   " :inventory_level, it must be an Integer")
            end

            it 'returns false' do
              resource.attributes[:inventory_level] = 'er2'
              expect(resource.valid_inventory_level?).to be false
              resource.attributes[:inventory_level] = 2.4
              expect(resource.valid_inventory_level?).to be false
            end
          end

          context 'IF attribute value is in given range' do
            it 'returns true' do
              resource.attributes[:inventory_level] = rand(0..100)
              expect(resource.valid_inventory_level?).to be true
            end
          end

          context 'IF attribute value is NOT in given range' do
            specify 'valid_#{attr}? method sets #errors[attr]' do
              value = 101
              resource.attributes[:inventory_level] = value
              resource.valid_inventory_level?
              expect(resource.errors[:inventory_level]).to\
                eq("#{value.inspect} is out of range, :inventory_level must be an Integer between 0 and 100")
            end

            it 'returns false' do
              resource.attributes[:inventory_level] = rand(101..1000)
              expect(resource.valid_inventory_level?).to be false
              resource.attributes[:inventory_level] = rand(-100..-1)
              expect(resource.valid_inventory_level?).to be false
            end
          end
        end

        context 'FOR Float attribute' do
          before do
            resourceClass.attribute :weight, type: Float, range: (0..100)
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_weight?)
          end

          context 'IF attribute value is a Float' do
            it 'returns true' do
              resource.attributes[:weight] = '44'
              expect(resource.valid_weight?).to be true
              resource.attributes[:weight] = 34
              expect(resource.valid_weight?).to be true
            end
          end

          context 'IF attribute value is NOT a Float' do
            let(:value){ 'er2' }

            before do
              resource.attributes[:weight] = value
            end

            specify 'valid_#{attr}? method sets #errors[attr]' do
              resource.valid_weight?
              expect(resource.errors[:weight]).to eq("#{value.inspect} is not valid value for :weight, it should be a Float")
            end

            it 'returns false' do
              expect(resource.valid_weight?).to be false
            end
          end

          context 'IF attribute value is in given range' do
            it 'returns true' do
              resource.attributes[:weight] = 10.5
              expect(resource.valid_weight?).to be true
            end
          end

          context 'IF attribute value is NOT in given range' do
            specify 'valid_#{attr}? method sets #errors[attr]' do
              value = 101.6
              resource.attributes[:weight] = value
              resource.valid_weight?
              expect(resource.errors[:weight]).to eq("#{value.inspect} is out of range, :weight should be a Float between 0 and 100")
            end

            it 'returns false' do
              resource.attributes[:weight] = 101.6
              expect(resource.valid_weight?).to be false
              resource.attributes[:weight] = -2
              expect(resource.valid_weight?).to be false
            end
          end
        end

        context 'FOR DateTime attribute' do
          before do
            resourceClass.attribute :preorder_release_date, type: DateTime
          end

          it 'generates valid_#{attr}? method' do
            expect(resource).to respond_to(:valid_preorder_release_date?)
          end

          context 'IF attribute value is a valid datetime string of the format ("%Y-%m-%dT%H:%M:%S%z")' do
            it 'returns true' do
              resource.attributes[:preorder_release_date] = '2019-04-24T19:08:48+01:00'
              expect(resource.valid_preorder_release_date?).to be true
            end
          end

          context 'IF attribute value is NOT a valid datetime' do
            let(:invalid_date){ '2019-04-24 19:08:48' }
            before do
              resource.attributes[:preorder_release_date] = invalid_date
            end

            specify 'valid_#{attr}? method sets #errors[attr]' do
              resource.valid_preorder_release_date?
              expect(resource.errors[:preorder_release_date]).to eq("#{invalid_date.inspect} is not valid Date for :preorder_release_date, " +
                                                                    "valid value should be a DateTime instance or a string of the format " +
                                                                    "#{VALID_DATE_FORMAT.inspect} like #{DateTime.now.to_s.inspect}")
            end

            it 'returns false' do
              expect(resource.valid_preorder_release_date?).to be false
            end
          end
        end
      end

      describe '#valid?' do
        context 'IF all the attributes are valid' do
          it 'returns true' do
            resourceClass.attribute :name, type: String, length: 1..100
            resourceClass.attribute :inventory_level, type: Integer, range: (0..100)
            expect(resource).to receive(:valid_name?).and_return(true)
            expect(resource).to receive(:valid_inventory_level?).and_return(true)
            expect(resource).to be_valid
          end
        end

        context 'IF any attributes is invalid' do
          it 'returns false' do
            resourceClass.attribute :name, type: String, length: 1..100
            resourceClass.attribute :inventory_level, type: Integer, range: (0..100)
            expect(resource).to receive(:valid_name?).and_return(false)
            allow(resource).to receive(:valid_inventory_level?).and_return(true)
            expect(resource).to_not be_valid
          end
        end
      end

      describe '#new' do
        it 'raise and error if called on Resource' do
          expect{ Resource.new }.to raise_error('BCommerce::Catalog::Resouce cannot be instantiated directly')
        end

        it 'creates an instance of the resource called on' do
          expect(resourceClass.new).to be_a(resourceClass)
        end

        it 'sets the #attributes to the given attributes' do
          attrs = { id: rand(100), name: rand.to_s }
          res = resourceClass.new(attrs)
          expect(res.attributes).to be(attrs)
        end
      end

      describe '#save'
      describe '#update'
      describe '#delete'
    end

  end
end
