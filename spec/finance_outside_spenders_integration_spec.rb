require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application 
set :show_exceptions, false 

describe 'the financial outside_spenders search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/finance/outside_spenders'
			expect(page).to have_content "Outside Spending Portal"							
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/finance/outside_spenders'	
			select 'Super PACs', :from => 'ctype'		
			fill_in 'fec_id', :with => 'C00484642'	
			fill_in 'min_ies', :with => '1000'				
			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_content 'SENATE MAJORITY PAC'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search' do 
		it 'retrieves the results page correctly' do 
			visit '/finance/outside_spenders'					
			select 'Senate Campaign Committees', :from => 'ctype'
			fill_in 'fec_id', :with => 'C1231231'
			fill_in 'min_ies', :with => '9999999'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'	
			expect(page).to have_css '#result-none'				
		end
	end
end