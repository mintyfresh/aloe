# frozen_string_literal: true

require_relative 'boot'
require_relative 'env'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aloe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.helper false
      g.assets false
    end

    # Apply bootstrap error styling to form fields.
    config.action_view.field_error_proc = proc { |html_tag, _|
      fragment = Nokogiri::HTML.fragment(html_tag)
      element  = fragment.child

      # Append the `is-invalid` CSS class to the input element.
      element[:class] = [*element[:class], 'is-invalid'].join(' ')

      element.to_html.html_safe # rubocop:disable Rails/OutputSafety
    }

    # Load component translations from `app/components/**/*.yml`.
    path = config.paths.add 'app/components', glob: '**/*.yml'
    config.i18n.railties_load_path << path

    # Include indices in nested-attribute error keys.
    config.active_record.index_nested_attribute_errors = true

    # Correctly handle i18n lookups for indexed nested attributes.
    config.active_model.i18n_customize_full_message = true

    # @return [String] the default host of the application
    def default_host
      config.default_host or raise 'config.default_host is not set'
    end
  end
end
