require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application 
set :show_exceptions, false 

describe 'the financial district search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/finance/districts'
			expect(page).to have_content "Districts' Spending Portal"							
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/finance/districts'	
			select 'H', :from => 'office'		
			select 'CA', :from => 'state'					
			select 'Republican', :from => 'incumbent_party'
			fill_in 'office_district', :with => 39
			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_content 'Royce'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search combo of office:house and re-election year' do 
		it 'retrieves the results page correctly' do 
			visit '/finance/districts'					
			select 'H', :from => 'office'
			select '2018', :from => 'term_class'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'	
			expect(page).to have_css '#result-none'				
		end
	end
end