require 'spec_helper'

=begin 
These tests only check the presence of static assets; they do not check the functionality of those assets. 
That can be found on the respective pages integration spec samplepage_integration_spec.rb
=end 

# Checks for static assets common to all pages 
shared_examples 'a page' do 

  it 'has a header' do
    expect(page).to have_css 'footer.footer'
  end

  it 'has a brand' do       
		expect(page).to have_css 'nav.navbar.navbar-default'
  end

  it 'has favicons' do 
		page.all('link[rel~="icon"]').each do |fav|				
			visit fav[:href]
			page.status_code.should be 200
		end 
  end

  it 'points to brand page' do
    brand = page.first(:css, '#navbar-brand')
    visit brand[:src]                                      
    expect(page.status_code).to be 200 
  end
end 

# Index 
describe 'index.html' do
  before { visit '/' }  

  it_behaves_like 'a page'    

  it 'has a main menu' do
    expect(page).to have_css 'div#main-menu' 
  end

  it 'has main link bar' do 
 		expect(page).to have_css 'div#main-menu a', count: 5   	
  end 

end

# About 
describe 'about.html' do 
	before { visit '/about' }

	it_behaves_like 'a page'
end 

# Textsearch 
describe 'textsearch.html' do 
	before { visit '/textsearch' }

	it_behaves_like 'a page'
end

# Polls 
describe 'polls.html' do 
	before { visit '/polls' } 

	it_behaves_like 'a page'

end

# Legislators 
describe 'legislators.html' do 
	before { visit '/legislators' }

	it_behaves_like 'a page'
end 

# Finance 
describe 'finance.html' do 
	before { visit '/finance' }

	it_behaves_like 'a page'
end 

#Bills 
describe 'bills.html' do 
	before { visit '/bills' }

	it_behaves_like 'a page'
end 


























