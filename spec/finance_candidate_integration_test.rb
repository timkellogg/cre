require 'spec_helper'

describe 'the financial candidate search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/finance/candidates'
			expect(page).to have_content "Candidate's Spending Portal"							
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/finance/candidates'
			fill_in 'fec_id', :with => 'H6CA39020'		
			select 'House', :from => 'Office'		
			select 'CA', :from => 'State'					
			select 'Republican', :from => 'Party'	
			select 'True', :from 'is_incumbent'
			click_button 'Search'											
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_css '.result-item'	
			expect(page).to have_content 'Royce'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search combo of office:house and re-election year' do 
		it 'retrieves the results page correctly' do 
			visit '/finance/candidates'
			expect(page).to have_content 'Full Congressional Text Search'						
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 
			select 'House', :from 'Office'
			select '2018', :from 'term_class'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'	
			expect(page).to have_css '#result-none'				
		end
	end
end