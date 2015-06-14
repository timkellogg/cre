require 'view_helpers'
require 'capybara/rspec'
require 'rspec'
require './app'

Capybara.app = Sinatra::Application
set :environment, :test

RSpec.configure do |config|
  config.include Capybara::DSL
end

