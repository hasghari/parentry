$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'combustion'
Combustion.initialize! :active_record

require 'yaml'
require 'erb'
require 'pry'

require 'parentry'
require 'support/models'

require 'action_view'
require 'action_controller'
require 'database_cleaner'
require 'rspec/rails'

require 'support/array'

RSpec.configure do |config|
  config.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')
  DatabaseCleaner.strategy = :transaction

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }

  config.before { DatabaseCleaner.start }
  config.after  { DatabaseCleaner.clean }
end
