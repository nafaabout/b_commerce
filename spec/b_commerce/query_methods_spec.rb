module BCommerce

  class ListClass
    extend QueryMethods

    ARRAY_FILTERS  = [:in, :not_in]
    NUMBER_FILTERS = [:min, :max, :greater, :less] + ARRAY_FILTERS
    STRING_FILTERS = [:like] + ARRAY_FILTERS

    QUERY_PARAMS = {
      enum: {
        type: ['physical', 'digital', 'somthing else']
      },

      non_enum: {
        id: Integer,
        price: Float,
        name: String
      }
    }
  end

  RSpec.describe QueryMethods do
    let(:list) { ListClass.new }

    describe '.generate_enum_params_query_methods' do
      it 'generates instance methods on the class for the given "params"' do
        expect{ ListClass.send(:generate_enum_params_query_methods, params: ListClass::QUERY_PARAMS[:enum]) }.to\
          change{ list.respond_to?(:type) }.to(true)
      end
    end

    describe '.generate_non_enum_params_query_methods' do
      it 'generates instance methods on the class for the given "params"' do
        expect{ ListClass.send(:generate_non_enum_params_query_methods, params: ListClass::QUERY_PARAMS[:non_enum]) }.to\
          change{ list.respond_to?(:id) && list.respond_to?(:price) && list.respond_to?(:name) }.to(true)
      end
    end

    describe 'Generated ENUM methods' do
      before do
        ListClass.send(:generate_enum_params_query_methods, params: ListClass::QUERY_PARAMS[:enum])
      end

      describe '#type as an example' do
        context 'WHEN passed a value of the enum' do
          it 'sets the query[:type] to the passed value' do
            value = ListClass::QUERY_PARAMS[:enum][:type].sample
            expect{ list.type(value) }.to change{ list.query[:type] }.to(value)
          end
        end

        context 'WHEN passed an array of valid values' do
          it 'sets query["type:in"] to values.jon(",")' do
            values = ListClass::QUERY_PARAMS[:enum][:type].sample(2)
            expect{ list.type(values) }.to change{ list.query['type:in'] }.to(values.join(','))
          end
        end

        context 'WHEN passed a value not in the enum' do
          it 'raises InvalidValue error' do
            expect{ list.type('invalid_value') }.to raise_error(InvalidValue)
          end
        end

        context 'WHEN passed an invalid filter' do
          it 'raises InvalidFilters error' do
            values = ListClass::QUERY_PARAMS[:enum][:type]
            expect{ list.type(max: values) }.to raise_error{ InvalidFilters }
          end
        end

        context 'WHEN passed a filter with all values from the enum' do
          it 'sets the query["type:filter"] = values' do
            values = ListClass::QUERY_PARAMS[:enum][:type].sample(2)
            expect{ list.type(in: values) }.to change{ list.query["type:in"] }.to(values.join(','))
          end
        end

        context 'WHEN passed a filter with some values not in the enum' do
          it 'raise InvalidValue error' do
            values = ListClass::QUERY_PARAMS[:enum][:type].sample(2)
            values << 'invalid value'
            expect{ list.type(invalid_filter: values) }.to raise_error{ InvalidValue }
          end
        end
      end
    end


    describe 'Generated NON_ENUM methods' do
      before do
        ListClass.send(:generate_non_enum_params_query_methods, params: ListClass::QUERY_PARAMS[:non_enum])
      end

      describe '#id as an example for Integer' do
        context 'WHEN passed a value of valid type (Integer)' do
          it 'sets the query[:id] to the passed value' do
            expect{ list.id('90') }.to change{ list.query[:id] }.to('90')
            expect{ list.id(40) }.to change{ list.query[:id] }.to(40)
          end
        end

        context 'WHEN passed an array of valid values' do
          it 'sets query["id:in"] = values.join(",")' do
            values = [12, 45, 56]
            expect{ list.id(values) }.to change{ list.query['id:in'] }.to(values.join(','))
          end
        end

        context 'WHEN passed an invalid value (NOT Integer)' do
          it 'raises InvalidValue error' do
            expect{ list.id('er24') }.to raise_error(InvalidValue)
          end
        end

        context 'WHEN passed an invalid filter' do
          it 'raises InvalidFilters error' do
            expect{ list.id(like: '35') }.to raise_error(InvalidFilters)
          end
        end
      end
    end


    %w(include include_fields exclude_fields).each do |param|
      describe "Generated ##{param} method" do
        let(:valid_values) { ['value1', 'value2'] }

        before do
          ListClass.send(:generate_include_param_query_method, param: param, valid_values: valid_values)
        end

        context 'IF passed values are valid' do
          it 'accespts values as comma separated string' do
            expect{ list.send(param, 'value1,value2') }.to change{ list.query }.to({param => 'value1,value2'})
          end

          it 'accespts values as array' do
            expect{ list.send(param, ['value1', 'value2']) }.to change{ list.query }.to({param => 'value1,value2'})
            list.query.clear
            expect{ list.send(param, 'value1', 'value2') }.to change{ list.query }.to({param => 'value1,value2'})
          end
        end

        context 'IF passed values are NOT valid' do
          it 'raises error' do
            expect{ list.send(param, 'another_value') }.to raise_error(InvalidValue)
          end
        end
      end
    end

  end

end
