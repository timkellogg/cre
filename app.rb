require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'json'
require 'rest_client'
require 'dotenv'
Dotenv.load

# Load all lib files 
configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
    require File.basename(lib, '.*') 
  }
end


get '/' do 
	erb :index
end

get '/legislators' do 
	erb :legislators
end

get '/bills' do 
	erb :bills 
end

# Finance Routes 
get '/finance' do
	erb :finance 
end

# Finance/candidates
get '/finance/candidates' do 
	erb :"finance/candidates"
end

post '/finance/candidates' do 

	# Retrieving form data and parsing into output/api formats
	@state = params.fetch "state"
	@delimiters = ""

	fec_id = params.fetch "fec_id"
	if fec_id.empty?
		@fec_id = ""
	else 
		@delimiters << "FEC id: #{fec_id},"
		@fec_id = "&fec_id=#{fec_id}"
	end

	office = params.fetch "office"
	if office.empty?
		@office = ""
	else 
		@delimiters << "Office: #{office},"
		@office = "&office=#{office}"
	end

	state = params.fetch "state"
	if state.empty?
		@state = ""
	else 
		@delimiters << "State: #{state},"
		@state = "&state=#{state}"
	end

	term_class = params.fetch "term_class"
	if term_class.empty?
		@term_class = ""
	else 
		@delimiters << "Re-Election Year: #{term_class},"
		@term_class = "&term_class=#{term_class}"
	end


	party = params.fetch "party"
	if party.empty?
		@party = ""
	else 
		@delimiters << "Party: #{party},"
		@party = "&party=#{party}"
	end


	is_incumbent = params.fetch "is_incumbent"
	if is_incumbent.empty?
		@is_incumbent = ""
	else 
		@delimiters << "Incumbent: #{is_incumbent},"
		@is_incumbent = "&is_incumbent=#{is_incumbent}"
	end


	# API call to campaign finance api  
	api_result = RestClient.get "realtime.influenceexplorer.com/api//candidates/?format=json&page=1
								#{@fec_id}#{@office}#{@state}#{@term_class}#{@party}#{@is_incumbent}
								&page_size=10&apikey=" + ENV['SUNLIGHT_API_KEY']
	base       = JSON.parse(api_result)
	@result    = base["results"]

	erb :"finance/candidates/results"
end



# Congressional Full-Text Search Portal
get '/textsearch' do
	erb :textsearch
end

post '/textsearch' do 

	# Retrieving form data and parsing it into output/api formats 
	@phrase = params.fetch "phrase"
	@delimiters = ""

	title = params.fetch "title"
	if title.empty?
		@title = "" 
	else 
		@delimiters << "Title: #{title},"
		@title = "&title=#{title}"
	end

	state = params.fetch "state"
	if state.empty? 
		@state = ""
	else 
		@delimiters << "State: #{state},"
		@state = "&state=#{state}"
	end

    party = params.fetch "party"
    if party.empty?
    	@party = ""
    else 
    	@delimiters << "Party: #{party},"
    	@party = "&party=#{party}"
    end 

    chamber = params.fetch "chamber"
    if chamber.empty?
    	@chamber = ""
    else 
    	@delimiters << "Chamber: #{chamber}," 
    	@chamber ="&chamber=#{chamber}"
    end

	start_date = params.fetch "start_date"
	if start_date.empty?
		@start_date = ""
	else 
		@delimiters << "From #{start_date},"
		@start_date = "&start_date=#{start_date}"
	end

	end_date = params.fetch "end_date" 
	if end_date.empty?
		@end_date = ""
	else 
		@delimiters << "To #{end_date}"
		@end_date = "&end_date=#{end_date}"
	end
	

	# Replace spaces and commas with underscores to make valid html request url 
	@phrase.sub!(' ', '_')
	@phrase.sub!(',', '_')

	# API call to capitol words 
	api_result = RestClient.get "capitolwords.org/api/1/text.json?phrase=#{@phrase}&page=0#{@state}#{@chamber}#{@party}
									#{@start_date}#{@end_date}#{@title}&apikey=" + ENV['SUNLIGHT_API_KEY'] 					
	@result = api_result.to_json	
	# base       = JSON.parse(api_result)
	# @result    = base["results"]


	erb :"textsearch/results" 
end




