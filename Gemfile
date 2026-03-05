# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

if ENV['OMNIAUTH_OAUTH2'] == 'head'
  gem 'omniauth-oauth2', git: 'https://github.com/omniauth/omniauth-oauth2.git'
elsif ENV['OMNIAUTH_OAUTH2']
  gem 'omniauth-oauth2', ENV['OMNIAUTH_OAUTH2']
end

gem 'rails', ENV['RAILS_VERSION'] if ENV['RAILS_VERSION']

gem 'minitest', '>= 5.20'
gem 'rack-test', '>= 2.1'
gem 'rake', '>= 13.1'
gem 'rubocop', '>= 1.70'
gem 'rubocop-minitest', '>= 0.36'
gem 'webmock', '>= 3.24'
