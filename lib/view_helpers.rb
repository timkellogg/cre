# View Helper Methods

# Method to switch out abbreviation with state 

# Switch out H and S for house and senate
def get_chamber(value)
	if value == 'H'
		'House'
	else 
		'Senate'
	end
end

# Convert False & True to No and Yes
def convert_boolean(bool) 
	if bool == false 
		'No'
	else 
		'Yes'
	end
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
				   "WI" => "Wisconsin", "WY" => "Wyoming"}

	state_hash[abbreviation]
end

