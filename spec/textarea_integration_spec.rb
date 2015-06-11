require 'capybara/rspec'
require './app'

Capybara.app = Sinatra::Application 
set :show_exceptions, false 

# Valid congressional search 
describe 'the congressional search record path with valid search', {:type => :feature} do 
	it 'follows the user from index through congressional records search results' do 
		visit '/textsearch'
		expect(page).to have_content 'Full Congressional Text Search'	# Title
		expect(page).to have_content 'C. Records'						# Header
		expect(page).to have_content 'Web Design by Kellogg Web Studio' # Footer
		fill_in 'phrase', :with => 'Patriot Act'						# Enter search term
		find('#state').find(:xpath, 'option[4]').select_option 			# Select CA from state option list			
		find('#party').find(:xpath, 'option[1]').select_option			# Select Democrat from party option list			
		click_button 'Search'											# Click link
		expect(page).to have_content 'Search again?'					# Find back button 
		expect(page).to have_content 'Your results were limited to:'	# Find result count field
		expect(page).to have_css '.result-item'							# Find element rows 
	end
end

# Invalid congressional search 
describe 'the congressional search record path with invalid search', {:type => :feature} do
	it 'follows the user from index through congressional search with bad phrase' do 
		visit '/textsearch'
		expect(page).to have_content 'Full Congressional Text Search'	# Title
		expect(page).to have_content 'C. Records'						# Header
		expect(page).to have_content 'Web Design by Kellogg Web Studio' # Footer
		fill_in 'phrase', :with => 'aslfasfjio;eaf'
		click_button 'Search'
		expect(page).to have_content 'Search again?'					# Find back button 
		expect(page).to have_no_content '.result_item:'					# Find there's no results
	end
end