# Convert chamber abbr into full name 
def get_chamber(value)
	value == 'H' || value == 'h' ? 'House' : 'Senate'
end

# Convert 'R', 'D', and 'I' to 'Republican', 'Democrat', 'Independent'
def get_party(value)
	if value == 'D' || value == 'd'
		'Democrat' 
	elsif value == 'I' || value == 'i'
		'Independent'
	elsif value == 'R' || value == 'r'
		'Republican'
	else 
		'Other'
	end 
end

# Convert boolean into no or yes
def convert_boolean(bool)
	bool == false ? 'No' : 'Yes'
end

# Convert State Abbreviation to Full State Name
def convert_abbreviation(abbreviation)
	state_hash = { "AL" => "Alabama", "AK" => "Alaska", "AZ" => "Arizona", "AR" => "Arkansas", "CA" => "California",
				   "CO" => "Colorado", "CT" => "Connecticut", "DE" => "Deleware", "DC" => "Washington, D.C.", "FL" =>
				   "Florida", "GA" => "Georgia", "HI" => "Hawaii", "ID" => "Idaho", "IL" => "Illinois", "IN" => "Indiana",
				   "IA" => "Iowa", "KS" => "Kansas", "KY" => "Kentucky", "LA" => "Louisiana", "ME" => "Maine", "MD" => 
				   "Maryland", "MA" => "Massachusetts", "MI" => "Michigan", "MN" => "Minnesota", "MS" => "Mississippi", 
				   "MO" => "Missouri", "MT" => "Montana", "NE" => "Nebraska", "NV" => "Nevada", "NH" => "New Hampshire",
				   "NJ" => "New Jersey", "NM" => "New Mexico", "NY" => "New York", "NC" => "North Carolina", "ND" =>
				   "North Dakota", "OH" => "Ohio", "OK" => "Oklahoma", "OR" => "Oregon", "PA" => "Pennsylvania", "RI" =>
				   "Rhode Island", "SC" => "South Carolina", "SD" => "South Dakota", "TN" => "Tennessee", "TX" => "Texas",
				   "UT" => "Utah", "VT" => "Vermont", "VA" => "Virginia", "WA" => "Washington", "WV" => "West Virginia", 
				   "WI" => "Wisconsin", "WY" => "Wyoming"
				}
	state_hash[abbreviation]
end

# Convert nil value into no info display message
def convert_nil(value)
	value.nil? || value == 0 ? 'No Information Available' : value 
end

# Convert nil value into na display message 
def convert_to_na(value)
	value.nil? ? 'NA' : value 
end

# Convert string to decimal-delimited set
def comma_numbers(number, delimiter = ',')
  number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end

# Convert nil result into display message
def convert_result_nil(value)
	value.nil? ? '[nothing...]' : value
end

# Convert Committee Types into Full Names
def convert_committee(committee) 
	committee_hash = {"C" => "Communication Cost", "D" => "Delegate", "E" => "Electioneering", "H" => "House", 
					  "I" => "Independent Expenditor (Person or Group)", "N" => "PAC - Nonqualified", "O" => "Super PAC",
					  "P" => "Presidential", "Q" => "PAC - Qualified", "S" => "Senate", "U" => "Single Candidate Independent 
					  Expenditure", "V" => "PAC with Non-Contribution Account - Qualified", "X" => "Party - Nonqualified", 
					  "Y" => "Party - Qualified", "Z" => "National Party Nonfederal Account"
					}
	committee_hash[committee]
end







