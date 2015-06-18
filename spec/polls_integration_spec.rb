require 'spec_helper'

describe 'the poll search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'lets the user search for polls' do 
			visit '/polls'
			expect(page).to have_content 'Polling Data'
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/polls'
			select 'Approval Ratings', from: 'Topic'		
			click_button 'Search'
			expect(page).to have_content 'Search again?'
			expect(page).to have_content 'Basic Poll Information'
			expect(page).to have_content 'Poll Topics'
			expect(page).to have_content 'Kellogg Web Studio'
			brand = page.first(:css, '#navbar-brand')
    		visit brand[:src]                                      
    		expect(page.status_code).to be 200 
		end 
	end 
end

