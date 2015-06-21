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
			fill_in 'fec_id', :with => 'H6CA39020'		

			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_css '.result-item'	
			expect(page).to have_content 'Royce'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search' do 
		it 'retrieves the results page correctly' do 
			visit '/bills'
			expect(page).to have_content 'Bill Search Engine'						
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 

			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'	
			expect(page).to have_css '#result-none'				
		end
	end
end