require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'json'
require 'rest_client'
require 'dotenv'
Dotenv.load


get '/' do 
	erb :index
	# jhash = JSON.parse(api_result) 
end

get '/textsearch' do
	erb :textsearch
end

get '/legislators' do 
	erb :legislators
end

get '/bills' do 
	erb :bills 
end

get '/finance' do 
	erb :finance 
end


post '/textsearch' do 

	@phrase = params.fetch "phrase"

	title = params.fetch "title"
	if title.empty?
		@title = "" 
	else 
		@title = "&title=#{title}"
	end

	state = params.fetch "state"
	if state.empty? 
		@state = ""
	else 
		@state = "&state=#{state}"
	end

    party = params.fetch "party"
    if party.empty?
    	@party = ""
    else 
    	@party = "&party=#{party}"
    end 

    chamber = params.fetch "chamber"
    if chamber.empty?
    	@chamber = ""
    else 
    	@chamber ="&chamber=#{chamber}"
    end

	start_date = params.fetch "start_date"
	if start_date.empty?
		@start_date = ""
	else 
		@start_date = "&start_date=#{start_date}"
	end

	end_date = params.fetch "end_date" 
	if end_date.empty?
		@end_date = ""
	else 
		@end_date = "&end_date=#{end_date}"
	end


	# Replace spaces and commas with underscores to make valid html request url 
	@phrase.sub!(' ', '_')
	@phrase.sub!(',', '_')

	api_result = RestClient.get "capitolwords.org/api/1/text.json?phrase=#{@phrase}&page=0#{@state}#{@chamber}#{@party}
									#{@start_date}#{@end_date}#{@title}&apikey=" + ENV['SUNLIGHT_API_KEY']
	base       = JSON.parse(api_result)
	@result    = base["results"]

	erb :output
end


get '/output' do 

end


