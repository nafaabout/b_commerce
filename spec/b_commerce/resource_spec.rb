module BCommerce

  RSpec.describe Resource do
    let(:resourceClass){ Class.new(Resource) }
    let(:resource){ resourceClass.new }
    let(:store_hash){ rand.to_s }

    before do
      BCommerce::Base.setup(client_id: 'id', store_hash: store_hash, auth_token: 'token')
      resourceClass::API_VERSION = 'v3'
      resourceClass::PATH = '/resources'
      resourceClass.attribute(:id, type: Integer)
    end

    it 'inherits from BCommerce::Base' do
      expect(Resource).to be < Base
    end

    describe '.attribute' do
      it 'adds the attribute with its options to .attributes hash' do
        expect{ resourceClass.attribute :name, type: String, length: 1..100 }.to\
          change{ resourceClass.attributes }.to({id: { type: Integer }, name: { type: String, length: 1..100 }})
      end

      it 'defines setter method for the attribute' do
        expect{ resourceClass.attribute :name, type: String, length: 1..100 }.to\
          change{ resource.respond_to?(:name=) }.from(false).to(true)
      end

      it 'defines getter method for the attribute' do
        expect{ resourceClass.attribute :name, type: String, length: 1..100 }.to\
          change{ resource.respond_to?(:name) }.from(false).to(true)
      end

      context 'IF NOT passed neither :type nor :values arguments' do
        it 'raise error' do
          expect{ resourceClass.attribute :name, length: 1..100 }.to\
            raise_error(ArgumentError, "expected :type or :values argument for .attribute method, no one provided for :name")
        end
      end

      context 'IF passed required: true' do
        it 'adds the attribute to the required_attributes hash' do
          expect{ resourceClass.attribute :id, type: Integer, required: true }.to\
            change{ resourceClass.required_attributes[:id] }.to({ type: Integer, required: true })
        end
      end

      context 'IF passed readonly: true' do
        it 'adds the attribute to the required_attributes hash' do
          expect{ resourceClass.attribute :id, type: Integer, readonly: true }.to\
            change{ resourceClass.readonly_attributes[:id] }.to({ type: Integer, readonly: true })
        end
      end

      context 'FOR Enum attribute' do
        let(:valid_types){ ['physical', 'digital'] }

        before do
          resourceClass.attribute :type, values: valid_types
        end

        it 'generates valid_#{attr}? method' do
          expect(resource).to respond_to(:valid_type?)
        end

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :type, values: valid_types, required: true
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:type] = nil
              expect(resource.valid_type?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:type] = nil
              resource.valid_type?
              expect(resource.errors[:type]).to eq("missing value for required attribute :type")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :type, values: valid_types, required: false
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:type] = nil
              expect(resource.valid_type?).to be true
            end
          end
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

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :name, type: Object, required: true, validate_with: :some_method
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:name] = nil
              expect(resource.valid_name?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:name] = nil
              resource.valid_name?
              expect(resource.errors[:name]).to eq("missing value for required attribute :name")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :name, type: Object, required: false, validate_with: :some_method
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:name] = nil
              expect(resource.valid_name?).to be true
            end
          end
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

      context 'FOR Object attribute' do
        before do
          resourceClass.attribute :custom_url, type: Object, validate_with: :some_method
        end

        it 'generates valid_#{attr}? method' do
          expect(resource).to respond_to(:valid_custom_url?)
        end

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :custom_url, type: Object, required: true, validate_with: :some_method
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:custom_url] = nil
              expect(resource.valid_custom_url?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:custom_url] = nil
              resource.valid_custom_url?
              expect(resource.errors[:custom_url]).to eq("missing value for required attribute :custom_url")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :custom_url, type: Object, required: false, validate_with: :some_method
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:custom_url] = nil
              expect(resource.valid_custom_url?).to be true
            end
          end
        end

        context 'IF attribute[attr] value is invalid' do
          before do
            expect(resource).to receive(:some_method).and_return(false)
          end

          specify 'valid_#{attr}? returns false' do
            resource.attributes[:custom_url] = 'invalid value'
            expect(resource.valid_custom_url?).to be false
          end

          specify 'valid_#{attr}? sets errors[attr]' do
            value = 'invalid value'
            resource.attributes[:custom_url] = value
            resource.valid_custom_url?
            expect(resource.errors[:custom_url]).to\
              eq("#{value.inspect} is invalid for :custom_url per :some_method method")
          end
        end

        context 'IF :validate_with NOT passed' do
          it 'raises error' do
            expect{ resourceClass.attribute :custom_url, type: Object, validate_with: nil }.to\
              raise_error(ArgumentError, ':validate_with is required for attributes of type Object')
          end
        end

        context 'IF :validate_with passed' do
          specify 'valid_#{attr}? calls method passed in :validate_with' do
            resourceClass.attribute :custom_url, type: Object, validate_with: :some_method
            resource.attributes[:custom_url] = 'invalid value'
            expect(resource).to receive(:some_method)
            resource.valid_custom_url?
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

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :categories, type: Array, required: true, values_type: Integer
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:categories] = []
              expect(resource.valid_categories?).to be false
            end

            specify 'sets errors[attr]' do
              [[], nil].each do |empty_value|
                resource.attributes[:categories] = empty_value
                resource.valid_categories?
                expect(resource.errors[:categories]).to eq("missing value for required attribute :categories")
              end
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :categories, type: Array, required: false, values_type: Integer
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:categories] = nil
              expect(resource.valid_categories?).to be true
            end
          end
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

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :inventory_level, type: Integer, range: (0..100), required: true
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:inventory_level] = nil
              expect(resource.valid_inventory_level?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:inventory_level] = nil
              resource.valid_inventory_level?
              expect(resource.errors[:inventory_level]).to eq("missing value for required attribute :inventory_level")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :inventory_level, type: Array, required: false, values_type: Integer
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:inventory_level] = nil
              expect(resource.valid_inventory_level?).to be true
            end
          end
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

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :weight, type: Float, range: (0..100), required: true
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:weight] = nil
              expect(resource.valid_weight?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:weight] = nil
              resource.valid_weight?
              expect(resource.errors[:weight]).to eq("missing value for required attribute :weight")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :weight, type: Array, required: false, values_type: Integer
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:weight] = nil
              expect(resource.valid_weight?).to be true
            end
          end
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

        context 'IF attribute is required' do
          before do
            resourceClass.attribute :preorder_release_date, type: DateTime, required: true
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns false' do
              resource.attributes[:preorder_release_date] = nil
              expect(resource.valid_preorder_release_date?).to be false
            end

            specify 'sets errors[attr]' do
              resource.attributes[:preorder_release_date] = nil
              resource.valid_preorder_release_date?
              expect(resource.errors[:preorder_release_date]).to eq("missing value for required attribute :preorder_release_date")
            end
          end
        end

        context 'IF attribute is NOT required' do
          before do
            resourceClass.attribute :preorder_release_date, type: Array, required: false, values_type: Integer
          end

          context 'AND attributes[attr] is missing' do
            specify 'valid_#{attr}? returns true' do
              resource.attributes[:preorder_release_date] = nil
              expect(resource.valid_preorder_release_date?).to be true
            end
          end
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

    describe '#path' do
      let(:resource_path){ "/stores/#{store_hash}/#{resourceClass::API_VERSION}/resources" }

      context 'IF attributes[:id] is set' do
        it 'returns STORE_PATH/PATH/id' do
          id = rand(100)
          resource.id = id
          expect(resource.path).to eq("#{resource_path}/#{id}")
        end
      end

      context 'IF attributes[:id] is NOT set' do
        it 'returns STORE_PATH/PATH' do
          resource.id = nil
          expect(resource.path).to eq(resource_path)
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
          resource.attributes[:name] = '' # lenght 0
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

    describe '#save' do
      before do
        allow(resource.connection).to receive(:request)
      end

      context 'IF passed validate: true' do
        it 'validates attributes before it save' do
          expect(resource).to receive(:valid?).and_return(false)
          resource.save
        end

        context 'AND attributes are valid' do
          it 'calls the API with the resource attributes' do
            expect(resource.connection).to receive(:request).with(method: :post,
                                                                  path: resource.path,
                                                                  headers: resource.headers,
                                                                  body: resource.attributes.to_json)
            resource.save(validate: false)
          end
        end

        context 'AND attributes are NOT valid' do
          it 'does not call the API' do
            expect(resource).to receive(:valid?).and_return(false)
            expect(resource.connection).to_not receive(:request)
            resource.save(validate: true)
          end

          it 'returns false' do
            expect(resource).to receive(:valid?).and_return(false)
            expect(resource.save(validate: true)).to be false
          end
        end
      end

      context 'IF passed validate: false' do
        it 'does not validate attributes' do
          expect(resource).to_not receive(:valid?)
          resource.save(validate: false)
        end
      end

      context 'IF attributes[:id] is set' do
        it 'sends a PUT request' do
          resource.attributes[:id] = rand(100)
          expect(resource.connection).to receive(:request).with(hash_including(method: :put))
          resource.save(validate: false)
        end
      end

      context 'IF attributes[:id] is NOT set' do
        it 'sends a POST request' do
          resource.attributes[:id] = nil
          expect(resource.connection).to receive(:request).with(hash_including(method: :post))
          resource.save(validate: false)
        end
      end
    end

    describe '#delete'
    describe '#exists?'

    describe '#reload' do
      context 'IF attribute[:id] is set' do
        let(:id){ rand(100) }
        let(:attributes) { { id: id, name: 'Some good prod', price: 12.4 } }
        let(:status) { 200 }
        let(:response){ Excon::Response.new(body: { data: attributes }.to_json, status: status) }

        before do
          resource.id = id
          resourceClass.attribute(:name, type: String)
          resourceClass.attribute(:price, type: Float)
          expect(resource.connection).to receive(:get)
            .with(path: resource.path, headers: resource.headers, query: resource.query)
            .and_return(response)
        end

        it 'gets attributes of the resource from remote store' do
          resource.reload
        end

        it 'sets the attributes to the attributes of the response' do
          expect{ resource.reload }.to change{ resource.attributes }.to(attributes)
        end

        context 'IF response status is not 200' do
          let(:status){ 404 }

          it 'does not set attributes' do
          expect{ resource.reload }.to_not change{ resource.attributes }
          end
        end
      end
    end

    describe '#new?' do
      context 'IF attributes[:id] is set' do
        it 'returns false' do
          resource = resourceClass.new(id: rand(100))
          expect(resource.new?).to be false
        end
      end

      context 'IF attributes[:id] is NOT set' do
        it 'returns true' do
          resource = resourceClass.new(id: nil)
          expect(resource.new?).to be true
        end
      end
    end

    describe '#persisted?'
  end

end
