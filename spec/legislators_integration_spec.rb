require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application 
Capybara.default_wait_time = 5
set :show_exceptions, false 

# Legislative Search
describe 'the legislator search engine', {:type => :feature} do 

	context 'with valid search terms' do 
		it 'lets the user search for representatives' do 
			visit '/legislators'
			expect(page).to have_content 'Legislator Lookup'
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/legislators'
			fill_in 'first_name', :with => 'Ed'		
			fill_in 'last_name', :with => 'Royce'	
			click_button 'Search'
			expect(page).to have_content 'Search again?'
			# scope to look up result of Ed Royce
			expect(page).to have_content 'Kellogg Web Studio'
			brand = page.first(:css, '#navbar-brand')
    		visit brand[:src]                                      
    		expect(page.status_code).to be 200 
		end 
	end 
end


