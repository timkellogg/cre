require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application 
set :show_exceptions, false 

describe 'the congressional search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/textsearch'
			expect(page).to have_content 'Full Congressional Text Search'	
			expect(page).to have_content 'C. Records'						
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			fill_in 'phrase', :with => 'Energy'		
			select 'All', :from => 'State'		
			select 'All', :from => 'Party'					
			fill_in 'cr_pages', :with => 'H9197-H9203'	
			fill_in 'title', :with => 'CULTIVATING AMERICAN ENERGY RESOURCES'	
			select 'All', :from => 'Chamber'	
			fill_in 'bioguide_id', :with => 'F000450'
			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_css '.result-item'							
		end
	end

	context 'with invalid search terms' do 
		it 'retrieves the results page correctly' do 
			visit '/textsearch'
			expect(page).to have_content 'Full Congressional Text Search'	
			expect(page).to have_content 'C. Records'						
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			fill_in 'phrase', :with => 'aslfasfjio;eaf'
			fill_in 'start_date', :with => '20121111'
			fill_in 'end_date', :with => '20150228'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'					
		end
	end
end

