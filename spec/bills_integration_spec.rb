require 'spec_helper'

describe 'the bill search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/bills'
			expect(page).to have_content "Bill Search Engine"							
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/bills'
			fill_in 'bill_number', :with => '113'
			select 'Senate Bills', :from => 'bill_type'
			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_content 'Private Student Loan Act of 2013'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search' do 
		it 'retrieves the results page correctly' do 
			visit '/bills'
			expect(page).to have_content 'Bill Search Engine'						
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			fill_in 'bill_number', :with => '34j5b9asdfc%'
			select 'House Simple Resolutions', :from => 'bill_type'
			begin 
				click_button 'Search'
			rescue => e  	
				expect(page).to have_content 'Search again?'					
				expect(page).to have_css '#result-none'			
			end 	
		end
	end
end