# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/spotify/version'

Gem::Specification.new do |spec|
  spec.name = 'omniauth-spotify'
  spec.version = OmniAuth::Spotify::VERSION
  spec.authors = ['Claudio Poli']
  spec.email = ['masterkain@gmail.com']

  spec.summary = 'OmniAuth strategy for Spotify OAuth2 authentication.'
  spec.description = 'OAuth2 strategy for OmniAuth that authenticates users with Spotify and exposes account metadata.'
  spec.homepage = 'https://github.com/icoretech/omniauth-spotify'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['source_code_uri'] = 'https://github.com/icoretech/omniauth-spotify'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/icoretech/omniauth-spotify/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/icoretech/omniauth-spotify/releases'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir[
    'lib/**/*.rb',
    'README*',
    'LICENSE*',
    '*.gemspec'
  ]
  spec.require_paths = ['lib']

  spec.add_dependency 'cgi', '>= 0.3.6'
  spec.add_dependency 'omniauth-oauth2', '>= 1.8', '< 1.9'
end
