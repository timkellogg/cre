require 'spec_helper'

describe '#get_chamber' do 
  it 'returns the correct chamber from abbreviation' do 
    house   = 'h'
    senate  = 'S'
    expect(get_chamber(house)).to eq 'House'
    expect(get_chamber(senate)).to eq 'Senate'
  end 
end

describe '#get_party' do 
	it 'returns the correct party from abbreviation' do 
		rep = 'r'
		dem = 'd'
		ind = 'I'
		expect(get_party(rep)).to eq 'Republican'
		expect(get_party(dem)).to eq 'Democrat'
		expect(get_party(ind)).to eq 'Independent'
	end
end

describe '#convert_boolean' do 
	it 'changes boolean to yes or no' do 
		fbool = false 
		tbool = true 
		expect(convert_boolean(fbool)).to eq 'No'
		expect(convert_boolean(tbool)).to eq 'Yes'
	end
end

describe '#convert_abbreviation' do 
	it 'converts state abbreviations into full texts' do 
		state_abb = 'AL'
		expect(convert_abbreviation(state_abb)).to eq 'Alabama'
	end 
end

describe '#convert_nil' do 
	it 'converts a nil value to a string to display' do 
		nothing = nil 
		zero    = 0
		expect(convert_nil(nothing)).to eq 'No Information Available'
		expect(convert_nil(zero)).to eq 'No Information Available'
	end
end

describe '#convert_to_na' do 
	it 'convert nil value to NA string to display' do 
		nothing = nil 
		value   = 'Some value'
		expect(convert_to_na(nothing)).to eq 'NA'
		expect(convert_to_na(value)).to eq value 
	end
end

describe '#comma_numbers' do 
	it 'converts a string into a number format' do 
		small = 10
		large = 124890234
		expect(comma_numbers(small)).to eq '10' 
		expect(comma_numbers(large)).to eq '124,890,234'
	end
end

describe '#convert_result_nil' do 
	it 'converts a result into string to display' do 
		nothing = nil 
		value   = 'Some value'
		expect(convert_result_nil(nothing)).to eq '[nothing...]'
		expect(convert_result_nil(value)).to eq value 
	end
end

describe '#convert_committee' do 
	it 'converts a committee abbreviation into full name' do 
		communication = 'C'
		expect(convert_committee(communication)).to eq 'Communication Cost'
	end
end

describe '#convert_date' do 
	it 'changes out %2F with -' do 
		original_date = '06%2F14%2F2015'
		expect(convert_date(original_date)).to eql '06-14-2015'
	end
end






















