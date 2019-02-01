# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

Dotenv::Railtie.load if %w[development test].include? ENV["RAILS_ENV"]

module ThanksyServer
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
    config.autoload_paths += Dir[Rails.root.join("app")]
  end
end
