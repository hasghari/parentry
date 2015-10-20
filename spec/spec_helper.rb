$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yaml'
require 'erb'
require 'active_record'
require 'pry'

ActiveRecord::Base.configurations = YAML.load(ERB.new(IO.read(File.dirname(__FILE__) + '/db/database.yml')).result)
ActiveRecord::Base.establish_connection(:test)
ActiveRecord::Migration.verbose = false

require 'combustion/database'
Combustion::Database.create_database(ActiveRecord::Base.configurations['test'])
load File.join(File.dirname(__FILE__), 'db', 'schema.rb')

require 'parentry'
require 'support/models'

require 'action_view'
require 'action_controller'
require 'database_cleaner'
require 'rspec/rails'

require 'support/fixture_helper'
ActiveRecord::FixtureSet.context_class.send :include, FixtureHelper

RSpec.configure do |config|
  config.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')
  DatabaseCleaner.strategy = :transaction

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  config.after(:suite) { Combustion::Database.drop_database(ActiveRecord::Base.configurations['test']) }

  config.before { DatabaseCleaner.start }
  config.after  { DatabaseCleaner.clean }
end
