# frozen_string_literal: true

require_relative 'test_helper'

require 'uri'

class OmniauthSpotifyTest < Minitest::Test
  def build_strategy
    OmniAuth::Strategies::Spotify.new(nil, 'client-id', 'client-secret')
  end

  def test_uses_current_spotify_endpoints
    client_options = build_strategy.options.client_options

    assert_equal 'https://api.spotify.com', client_options.site
    assert_equal 'https://accounts.spotify.com/authorize', client_options.authorize_url
    assert_equal 'https://accounts.spotify.com/api/token', client_options.token_url
  end

  def test_uid_info_and_extra_are_derived_from_raw_info
    strategy = build_strategy
    payload = {
      'id' => 'sampleuser',
      'display_name' => 'Sample User',
      'email' => 'sample@example.test',
      'external_urls' => { 'spotify' => 'https://open.spotify.com/user/sampleuser' },
      'images' => [{ 'url' => 'https://i.scdn.co/image/sample-image-id' }],
      'birthdate' => '1993-03-01',
      'country' => 'IT',
      'product' => 'open',
      'followers' => { 'total' => 10 }
    }

    strategy.instance_variable_set(:@raw_info, payload)

    assert_equal 'sampleuser', strategy.uid
    assert_equal(
      {
        name: 'Sample User',
        nickname: 'sampleuser',
        email: 'sample@example.test',
        urls: { 'spotify' => 'https://open.spotify.com/user/sampleuser' },
        image: 'https://i.scdn.co/image/sample-image-id',
        birthdate: Date.new(1993, 3, 1),
        country_code: 'IT',
        product: 'open',
        follower_count: 10
      },
      strategy.info
    )
    assert_equal({ 'raw_info' => payload }, strategy.extra)
  end

  def test_birthdate_parsing_is_nil_when_value_is_invalid
    strategy = build_strategy
    strategy.instance_variable_set(:@raw_info, { 'id' => 'sampleuser', 'birthdate' => 'not-a-date' })

    assert_nil strategy.info[:birthdate]
  end

  def test_raw_info_calls_me_endpoint_and_memoizes
    strategy = build_strategy
    token = FakeAccessToken.new({ 'id' => 'sampleuser' })

    strategy.define_singleton_method(:access_token) { token }

    first_call = strategy.raw_info
    second_call = strategy.raw_info

    assert_equal({ 'id' => 'sampleuser' }, first_call)
    assert_same first_call, second_call
    assert_equal 1, token.calls.length
    assert_equal 'v1/me', token.calls.first[:path]
  end

  def test_callback_url_prefers_configured_value
    strategy = build_strategy
    callback = 'https://example.test/auth/spotify/callback'
    strategy.options[:callback_url] = callback

    assert_equal callback, strategy.callback_url
  end

  def test_request_phase_redirects_to_spotify_with_expected_params
    previous_request_validation_phase = OmniAuth.config.request_validation_phase
    OmniAuth.config.request_validation_phase = nil

    app = ->(_env) { [404, { 'Content-Type' => 'text/plain' }, ['not found']] }
    strategy = OmniAuth::Strategies::Spotify.new(app, 'client-id', 'client-secret')
    env = Rack::MockRequest.env_for('/auth/spotify', method: 'POST')
    env['rack.session'] = {}

    status, headers, = strategy.call(env)

    assert_equal 302, status
    location = URI.parse(headers['Location'])
    params = URI.decode_www_form(location.query).to_h

    assert_equal 'accounts.spotify.com', location.host
    assert_equal 'client-id', params.fetch('client_id')
  ensure
    OmniAuth.config.request_validation_phase = previous_request_validation_phase
  end

  def test_force_approval_key_enables_show_dialog
    previous_request_validation_phase = OmniAuth.config.request_validation_phase
    OmniAuth.config.request_validation_phase = nil

    app = ->(_env) { [404, { 'Content-Type' => 'text/plain' }, ['not found']] }
    strategy = OmniAuth::Strategies::Spotify.new(app, 'client-id', 'client-secret')
    env = Rack::MockRequest.env_for('/auth/spotify', method: 'POST')
    env['rack.session'] = { 'omniauth_spotify_force_approval?' => true }

    status, headers, = strategy.call(env)
    params = URI.decode_www_form(URI.parse(headers['Location']).query).to_h

    assert_equal 302, status
    assert_equal 'true', params.fetch('show_dialog')
    refute env['rack.session'].key?('omniauth_spotify_force_approval?')
  ensure
    OmniAuth.config.request_validation_phase = previous_request_validation_phase
  end

  def test_legacy_force_approval_key_enables_show_dialog
    previous_request_validation_phase = OmniAuth.config.request_validation_phase
    OmniAuth.config.request_validation_phase = nil

    app = ->(_env) { [404, { 'Content-Type' => 'text/plain' }, ['not found']] }
    strategy = OmniAuth::Strategies::Spotify.new(app, 'client-id', 'client-secret')
    env = Rack::MockRequest.env_for('/auth/spotify', method: 'POST')
    env['rack.session'] = { 'ommiauth_spotify_force_approval?' => true }

    status, headers, = strategy.call(env)
    params = URI.decode_www_form(URI.parse(headers['Location']).query).to_h

    assert_equal 302, status
    assert_equal 'true', params.fetch('show_dialog')
    refute env['rack.session'].key?('ommiauth_spotify_force_approval?')
  ensure
    OmniAuth.config.request_validation_phase = previous_request_validation_phase
  end

  def test_show_dialog_query_param_is_forwarded
    previous_request_validation_phase = OmniAuth.config.request_validation_phase
    OmniAuth.config.request_validation_phase = nil

    app = ->(_env) { [404, { 'Content-Type' => 'text/plain' }, ['not found']] }
    strategy = OmniAuth::Strategies::Spotify.new(app, 'client-id', 'client-secret')
    env = Rack::MockRequest.env_for('/auth/spotify?show_dialog=true', method: 'POST')
    env['rack.session'] = {}

    status, headers, = strategy.call(env)
    params = URI.decode_www_form(URI.parse(headers['Location']).query).to_h

    assert_equal 302, status
    assert_equal 'true', params.fetch('show_dialog')
  ensure
    OmniAuth.config.request_validation_phase = previous_request_validation_phase
  end

  def test_query_string_is_ignored_during_callback_request
    strategy = build_strategy
    request = Rack::Request.new(Rack::MockRequest.env_for('/auth/spotify/callback?code=abc&state=xyz'))
    strategy.define_singleton_method(:request) { request }

    assert_equal '', strategy.query_string
  end

  def test_query_string_is_kept_for_non_callback_requests
    strategy = build_strategy
    request = Rack::Request.new(Rack::MockRequest.env_for('/auth/spotify?show_dialog=true'))
    strategy.define_singleton_method(:request) { request }

    assert_equal '?show_dialog=true', strategy.query_string
  end

  class FakeAccessToken
    attr_reader :calls

    def initialize(parsed_payload)
      @parsed_payload = parsed_payload
      @calls = []
    end

    def get(path)
      @calls << { path: path }
      Struct.new(:parsed).new(@parsed_payload)
    end
  end
end
