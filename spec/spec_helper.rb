require 'view_helpers'
require 'capybara/rspec'
require 'rspec'
require './app'

Capybara.app = Sinatra::Application
set :environment, :test

# Add capybara methods such as visit for RSpec 
RSpec.configure do |config|
  config.include Capybara::DSL
end

