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
	@delimiters << "Committee Type: #{ctype}," if !ctype.empty?

	fec_id = params.fetch "fec_id"
	@delimiters << "FEC id: #{fec_id},"	if !fec_id.empty?

	min_raised = params.fetch "min_raised"
	@delimiters << "Min. Cash Raised (2014): #{min_raised}," if !min_raised.empty?	

	min_spent = params.fetch "min_spent"
	@delimiters << "Min. Cash Spent (2014): #{min_spent}," if !min_spent.empty?	

	min_coh = params.fetch "min_coh"
	@delimiters << "Min. Cash on Hand: #{min_coh}," if !min_coh.empty?

	response = RestClient::Request.execute(method: :get, 
		                                      url: "realtime.influenceexplorer.com/api//committee/",
		                                  headers: {params: {
		                                  					  :ctype => ctype,
		                                  					  :fec_id => fec_id,
		                                  					  :min_raised => min_raised,
		                                  					  :min_spent => min_spent,
		                                  					  :min_coh => min_coh,
		                                  					  :page => 1,
		                                  					  :page_size => 100,
										  				      :apikey => ENV['SUNLIGHT_API_KEY']}}, 
										  timeout: 8000)  				      				                

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
	@delimiters << "Committee Type: #{ctype}," if !ctype.empty?

	fec_id = params.fetch "fec_id"
	@delimiters << "FEC id: #{fec_id},"	if !fec_id.empty?

	min_ies = params.fetch "min_ies"
	@delimiters << "Min. Amount Given: #{min_ies},"	if !min_ies.empty?

	response = RestClient::Request.execute(method: :get, 
		                                      url: "realtime.influenceexplorer.com/api//outside-spenders/",
		                                  headers: {params: {
		                                  					  :ctype => ctype,
		                                  					  :fec_id => fec_id,
		                                  					  :min_ies => min_ies,
		                                  					  :page => 1,
		                                  					  :page_size => 100,
										  				      :apikey => ENV['SUNLIGHT_API_KEY']}}, 		                                  					  
		                                  timeout: 8000)

	base       = JSON.parse(response)
	@result    = base["results"]

	haml :"finance/outside-spenders/results"
end

post '/finance/districts' do 

	@delimiters = ""

	state = params.fetch "state"
	@delimiters << "State: #{state}," if !state.empty?

	office = params.fetch "office"
	@delimiters << "Office: #{office},"	if !office.empty?

	office_district = params.fetch "office_district"
	@delimiters << "Office District: #{office_district}," if !office_district.empty?

	term_class = params.fetch "term_class"
	@delimiters << "Re-Election Year: #{term_class}," if !term_class.empty?

	incumbent_party = params.fetch "incumbent_party"
	@delimiters << "Incumbent Party: #{incumbent_party}," if !incumbent_party.empty?

	response = RestClient::Request.execute(method: :get, 
										      url: "realtime.influenceexplorer.com/api//districts/",
										  headers: {params: {
										  				      :state => state, 
										  				      :office => office,
										  				      :office_district => office_district,
										  				      :term_class => term_class,
										  				      :incumbent_party => incumbent_party,
										  				      :page => 1,
										  				      :page_size => 100,
										  				      :apikey => ENV['SUNLIGHT_API_KEY']}}, 
										 timeout: 8000)	                     

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

	@delimiters = ""

	fec_id = params.fetch "fec_id"
	@delimiters << "FEC id: #{fec_id}," if !fec_id.empty?

	office = params.fetch "office"
	@delimiters << "Office: #{office}," if !office.empty?

	state = params.fetch "state"
	@delimiters << "State: #{state}," if !state.empty?	

	term_class = params.fetch "term_class"
	@delimiters << "Re-Election Year: #{term_class}," if !term_class.empty?	

	party = params.fetch "party"
	@delimiters << "Party: #{party}," if !party.empty?	

	is_incumbent = params.fetch "is_incumbent"
	@delimiters << "Incumbent: #{is_incumbent}," if !is_incumbent.empty?	
 
	api_result = RestClient::Request.execute(method: :get,
											 url: "realtime.influenceexplorer.com/api//candidates/",
									     headers: {params: {
									     				  	:state => state,
									     				  	:fec_id => fec_id,
									     				  	:office => office,
									     				  	:term_class => term_class,
									     				  	:party => party,
									     				  	:is_incumbent => is_incumbent,
									     				  	:page => 1,
									     				  	:page_size => 50,
									     				  	:apikey => ENV['SUNLIGHT_API_KEY']}}, 
									     timeout: 8000) 

	base       = JSON.parse(api_result)
	@result    = base["results"]

	haml :"finance/candidates/results"
end

get '/textsearch' do
	haml :textsearch
end

post '/textsearch' do 

	phrase = params.fetch "phrase"
	@delimiters = ""

	title = params.fetch "title"
	@delimiters << "Title: #{title}," if !title.empty?

	state = params.fetch "state"
	@delimiters << "State: #{state}," if !state.empty?

	bioguide_id = params.fetch "bioguide_id"
	@delimiters << "Bioguide id: #{bioguide_id}," if !bioguide_id.empty?

	cr_pages = params.fetch "cr_pages"
	@delimiters << "C. Record Pages: #{cr_pages},"	if !cr_pages.empty?

    party = params.fetch "party"
	@delimiters << "Party: #{party}," if !party.empty?   

    chamber = params.fetch "chamber"
    @delimiters << "Chamber: #{chamber}," if !chamber.empty?

	start_date = params.fetch "start_date"
	@delimiters << "From #{start_date},"

	end_date = params.fetch "end_date" 
	@delimiters << "To #{end_date}"

	# Replace spaces and commas with underscores to make valid html request url 
	phrase.sub!(' ', '_')
	phrase.sub!(',', '_')

	api_result = RestClient::Request.execute(method: :get, 
                                            url: "capitolwords.org/api/1/text.json", 
                                        headers: {params: { 
                                        				   :phrase => phrase, 
                                        				   :state => state,
                                        				   :bioguide_id => bioguide_id,
                                        				   :cr_pages => cr_pages,
                                        				   :party => party,
                                        				   :chamber => chamber,
                                        				   :start_date => start_date,
                                        				   :end_date => end_date,
                                                           :page => 0,
                                                           :apikey => ENV['SUNLIGHT_API_KEY']}}, 
                                        timeout: 8000)    						
	base       = JSON.parse(api_result)
	@result    = base["results"]

	haml :"textsearch/results" 
end

