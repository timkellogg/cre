require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'json'
require 'dotenv'
require 'haml'
Dotenv.load
require 'rest-client'

configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
    require File.basename(lib, '.*') 
  }
end
 
get '/' do 
	haml :index
end

get '/about' do 
	haml :about 
end 

get '/legislators' do 
	haml :legislators
end

post '/legislators' do 

	@delimiters = ""

	first_name = params.fetch "first_name"
	first_name.capitalize!
	if first_name.empty?
		@first_name = ""
	else 
		@delimiters << "First Name: #{first_name},"
		@first_name = "&first_name=#{first_name}"
	end

	last_name = params.fetch "last_name"
	last_name.capitalize!
	if last_name.empty?
		@last_name = ""
	else 
		@delimiters << "Last Name: #{last_name},"
		@last_name = "&last_name=#{last_name}"
	end

	party = params.fetch "party"
	if party.empty?
		@party = ""
	else 
		@delimiters << "Party: #{party},"
		@party = "&party=#{party}"
	end

	state = params.fetch "state"
	if state.empty?
		@state = ""
	else 
		@delimiters << "State: #{state},"
		@state = "&state=#{state}"
	end

	district = params.fetch "district"
	if district.empty?
		@district = ""
	else 
		@delimiters << "District: #{district},"
		@district = "&district=#{district}"
	end

	chamber = params.fetch "chamber"
	if chamber.empty?
		@chamber = ""
	else 
		@delimiters << "Chamber: #{chamber},"
		@chamber = "&chamber=#{chamber}"
	end

	in_office = params.fetch "in_office"
	if in_office.empty?
		@in_office = ""
	else 
		@delimiters << "In Office: #{chamber},"
		@in_office = "&in_office=#{in_office}"
	end

	gender = params.fetch "gender"
	if gender.empty?
		@gender = ""
	else 
		@delimiters << "Gender: #{gender},"
		@gender = "&gender=#{gender}"
	end

	term_start = params.fetch "term_start"
	if term_start.empty?
		@term_start = ""
	else 
		@delimiters << "Term Start: #{term_start},"
		@term_start = "&term_start=#{term_start}"
	end

	term_end = params.fetch "term_end"
	if term_end.empty?
		@term_end = ""
	else 
		@delimiters << "Term End: #{term_end},"
		@term_end = "&term_end=#{term_end}"
	end

	response = RestClient::Request.execute(method: :get, url: "congress.api.sunlightfoundation.com/legislators?#{@first_name}#{@last_name}#{@party}#{@state}#{@district}#{@chamber}#{@in_office}#{@gender}#{@term_start}#{@term_end}&apikey=" + ENV['SUNLIGHT_API_KEY'], timeout: 10)

	base    = JSON.parse(response)
	@result    = base["results"]

	haml :"legislators/results"
end 

get '/bills' do 
	haml :bills 
end

get '/polls' do 
	haml :polls
end

post '/polls' do 

	@topic = params.fetch "topic"
	@delimiters = ""

	after = params.fetch "after"
	if after.empty?
		@after = ""
	else 
		@delimiters << "After #{after},"
		@after = "&after=#{after}"
	end

	before = params.fetch "before" 
	if before.empty?
		@before = ""
	else 
		@delimiters << "To #{before}"
		@before = "&before=#{before}"
	end

	response = RestClient::Request.execute(method: :get, url: "http://elections.huffingtonpost.com/pollster/api/polls.json?page=1&topic=#{@topic}#{@before}#{@after}", timeout: 10)
	@result    = JSON.parse(response)

	haml :"/polls/results"
end

get '/finance/districts' do 
	haml :"finance/districts"
end

get '/finance/pacs' do 
	haml :"finance/pacs"
end

post '/finance/pacs' do 

	@delimiters = ""

	ctype = params.fetch "ctype"
	if ctype.empty?
		@ctype = ""
	else 
		@delimiters << "Committee Type: #{ctype},"
		@ctype = "&ctype=#{ctype}"
	end

	fec_id = params.fetch "fec_id"
	if fec_id.empty?
		@fec_id = ""
	else 
		@delimiters << "FEC id: #{fec_id},"
		@fec_id = "&fec_id=#{fec_id}"
	end

	min_raised = params.fetch "min_raised"
	if min_raised.empty?
		@min_raised = ""
	else 
		@delimiters << "Min. Cash Raised (2014): #{min_raised},"
		@min_raised = "&min_raised=#{min_raised}"
	end

	min_spent = params.fetch "min_spent"
	if min_spent.empty?
		@min_spent = ""
	else 
		@delimiters << "Min. Cash Spent (2014): #{min_spent},"
		@min_spent = "&min_spent=#{min_spent}"
	end

	min_coh = params.fetch "min_coh"
	if min_coh.empty?
		@min_coh = ""
	else 
		@delimiters << "Min. Cash on Hand: #{min_coh},"
		@min_coh = "&min_coh=#{min_coh}"
	end

	response = RestClient::Request.execute(method: :get, url: "realtime.influenceexplorer.com/api//committee/?format=json&page=1&page_size=100
	                         #{@fec_id}#{@ctype}#{@min_coh}#{@min_spent}#{@min_raised}&apikey=" + ENV['SUNLIGHT_API_KEY'], timeout: 10)

	base       = JSON.parse(response)
	@result    = base["results"]

	haml :"finance/pacs/results"
end

get '/finance/outside_spenders' do 
	haml :"finance/outside_spenders"
end

post '/finance/outside_spenders' do 

	@delimiters = ""

	ctype = params.fetch "ctype"
	if ctype.empty?
		@ctype = ""
	else 
		@delimiters << "Committee Type: #{ctype},"
		@ctype = "&ctype=#{ctype}"
	end 

	fec_id = params.fetch "fec_id"
	if fec_id.empty?
		@fec_id = ""
	else 
		@delimiters << "FEC id: #{fec_id},"
		@fec_id = "&fec_id=#{fec_id}"
	end

	min_ies = params.fetch "min_ies"
	if min_ies.empty?
		@min_ies = ""
	else 
		@delimiters << "Min. Amount Given: #{min_ies},"
		@min_ies = "&min_ies=#{min_ies}"
	end 

	response = RestClient::Request.execute(method: :get, url: "realtime.influenceexplorer.com/api//outside-spenders/?format=json&page=
	                            1&page_size=100&#{@ctype}#{@fec_id}#{@min_ies}&apikey=" + ENV['SUNLIGHT_API_KEY'], timeout: 10)
	base       = JSON.parse(response)
	@result    = base["results"]

	haml :"finance/outside-spenders/results"
end

post '/finance/districts' do 

	@delimiters = ""

	state = params.fetch "state"
	if state.empty?
		@state = ""
	else
		@delimiters << "State: #{state}," 
		@state = "&state=#{state}"
	end

	office = params.fetch "office"
	if office.empty?
		@office = ""
	else 
		@delimiters << "Office: #{office},"
		@office = "&office=#{office}"
	end

	office_district = params.fetch "office_district"
	if office_district.empty?
		@office_district = ""
	else 
		@delimiters << "Office District: #{office_district},"
		@office_district = "&office_district=#{office_district}"
	end

	term_class = params.fetch "term_class"
	if term_class.empty?
		@term_class = ""
	else 
		@delimiters << "Re-Election Year: #{term_class},"
		@term_class = "&term_class=#{term_class}"
	end

	incumbent_party = params.fetch "incumbent_party"
	if incumbent_party.empty?
		@incumbent_party = ""
	else 
		@delimiters << "Incumbent Party: #{incumbent_party},"
		@incumbent_party = "&incumbent_party=#{incumbent_party}"
	end
 
	response = RestClient::Request.execute(method: :get, url: "realtime.influenceexplorer.com/api//districts/?format=json&page=1&page_size=100
	                        #{@state}#{@office}#{@office_district}#{@term_class}#{@incumbent_party}&apikey=" + ENV['SUNLIGHT_API_KEY'], timeout: 10)
	base       = JSON.parse(response)
	@result    = base["results"]

	haml :"finance/districts/results"
end

get '/finance' do
	haml :finance 
end

get '/finance/outside-spenders' do 
	haml :"finance/outside-spenders"
end

get '/finance/candidates' do 
	haml :"finance/candidates"
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
								&page_size=50&apikey=" + ENV['SUNLIGHT_API_KEY']
	base       = JSON.parse(api_result)
	@result    = base["results"]

	haml :"finance/candidates/results"
end

get '/textsearch' do
	haml :textsearch
end

post '/textsearch' do 

	@phrase = params.fetch "phrase"
	@raw    = @phrase.gsub('_', ' ')
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

	bioguide_id = params.fetch "bioguide_id"
	if bioguide_id.empty?
		@bioguide_id = ""
	else 
		@delimiters << "Bioguide id: #{bioguide_id},"
		@bioguide_id = "&bioguide_id=#{bioguide_id}"
	end 

	cr_pages = params.fetch "cr_pages"
	if cr_pages.empty?
		@cr_pages = ""
	else
		@delimiters << "C. Record Pages: #{cr_pages},"
		@cr_pages = "&cr_pages=#{cr_pages}"
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
									#{@start_date}#{@end_date}#{@title}#{@bioguide_id}#{@cr_pages}&apikey=" + ENV['SUNLIGHT_API_KEY'] 						
	base       = JSON.parse(api_result)
	@result    = base["results"]

	haml :"textsearch/results" 
end
