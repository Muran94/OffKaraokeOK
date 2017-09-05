ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'active_decorator/rspec'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'simplecov'
SimpleCov.start do
  # テスト対象となるファイルをグループ化
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Decorators', 'app/decorators'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'

  # フィルター（テストしたくないファイルを指定）
  add_filter 'spec/*'
end

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

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include MailerMacros

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
  config.before :each do
    reset_email
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
