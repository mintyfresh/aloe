# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'blueprinter'
gem 'bootsnap', require: false
gem 'bootstrap'
gem 'ed25519'
gem 'has_unique_attribute'
gem 'importmap-rails', '~> 1.2'
gem 'omniauth'
gem 'omniauth-discord'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'pundit'
gem 'rails', '~> 7.0.7'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'annotate'
  gem 'mini_racer'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :test do
  gem 'rspec-rails'
end
