require 'spec_helper'

describe 'the financial pac search engine', {:type => :feature} do 
	context 'with valid search terms' do 
		it 'retrieves the correct result page' do 
			visit '/finance/pacs'
			expect(page).to have_content "Political Action Committee (PAC) Spending Portal"							
			expect(page).to have_content 'Web Design by Kellogg Web Studio' 	
			expect(page).to have_css '.text-info'
			page.all('link[rel~="icon"]').each do |fav|				
				visit fav[:href]
				page.status_code.should be 200
			end 
			visit '/finance/pacs'
			select 'Super PACs', :from => 'ctype'		
			fill_in 'fec_id', :with => 'C00484642'
			fill_in 'min_coh', :with => '70,000'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_content 'Your results were limited to:'	
			expect(page).to have_content 'SENATE MAJORITY PAC'	
			expect(page).to_not have_css '#result-none'					
		end
	end

	context 'with invalid search' do 
		it 'retrieves the results page correctly' do 
			visit '/finance/pacs'					
			select 'Independent Person/Group', :from => 'ctype'
			fill_in 'min_raised', :with => '99999999'
			fill_in 'min_spent', :with => '999999999'
			fill_in 'min_coh', :with => '0'
			click_button 'Search'
			expect(page).to have_content 'Search again?'					
			expect(page).to have_no_content '.result_item:'	
			expect(page).to have_css '#result-none'				
		end
	end
end