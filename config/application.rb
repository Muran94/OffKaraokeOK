# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'elasticsearch/rails/instrumentation'

module KaraokeOffApp
  class Application < Rails::Application
    config.load_defaults 5.1

    config.assets.enabled = true

    config.autoload_paths += Dir[Rails.root.join('app', 'uploaders')]

    config.i18n.default_locale = :ja

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: true,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
