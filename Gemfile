# frozen_string_literal: true

source "https://rubygems.org"

gemspec

if ENV["OMNIAUTH_OAUTH2"] == "head"
  gem "omniauth-oauth2", git: "https://github.com/omniauth/omniauth-oauth2.git"
elsif ENV["OMNIAUTH_OAUTH2"]
  gem "omniauth-oauth2", ENV["OMNIAUTH_OAUTH2"]
end

gem "rails", ENV["RAILS_VERSION"] if ENV["RAILS_VERSION"]

gem "minitest", ">= 5.20"
gem "rack-test", ">= 2.1"
gem "rake", ">= 13.1"
gem "rubocop-minitest", ">= 0.39", require: false
gem "standard", ">= 1.54.0"
gem "webmock", ">= 3.24"
