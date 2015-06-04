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
	# state         =  params.fetch "state"
	# party 			  =  params.fetch "party"
	# chamber       =  params.fetch "chamber"
	# start_date    =  params.fetch "start_date"
	# end_date      =  params.fetch "end_date" 
	@phrase          =  params.fetch "phrase"
	# percentages   =  params.fetch "percentages"
	# api_response  =  RestClient.get 'capitolwords.org/api/1/'
	
	# Replace spaces with underscores to make valid html request url 
	@phrase.sub!(' ', '_')

	api_result = RestClient.get "capitolwords.org/api/1/text.json?phrase=#{@phrase}&page=0&apikey=" + ENV['SUNLIGHT_API_KEY']
	base       = JSON.parse(api_result)
	@result    = base["results"]
 	
	# JSON attributes to bring to view 
	# @title         = @result[0]["title"]
	# @speaker_state = @result[0]["speaker_state"]
	# @date 				 = @result[0]["date"]

	erb :output
end


get '/output' do 

end


