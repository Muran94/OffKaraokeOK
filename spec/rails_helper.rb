ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'simplecov'
SimpleCov.start

require 'factory_girl'
require 'shoulda-matchers'
require 'database_cleaner'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  [:controller, :request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, type: type
    config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
    config.include ::Rails::Controller::Testing::Integration, type: type
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Devise::TestHelpers, type: :controller

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    FactoryGirl.reload
  end

  # テスト実行後にDBをクリア
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w(categories jobs initials job_positions))
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each do
    DatabaseCleaner[:active_record].start
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner[:active_record].clean
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
