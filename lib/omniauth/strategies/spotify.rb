# frozen_string_literal: true

require 'date'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # OmniAuth strategy for Spotify OAuth2.
    class Spotify < OmniAuth::Strategies::OAuth2
      option :name, 'spotify'

      FORCE_APPROVAL_KEY = 'omniauth_spotify_force_approval?'
      LEGACY_FORCE_APPROVAL_KEY = 'ommiauth_spotify_force_approval?'

      option :client_options,
             site: 'https://api.spotify.com',
             authorize_url: 'https://accounts.spotify.com/authorize',
             token_url: 'https://accounts.spotify.com/api/token',
             connection_opts: {
               headers: {
                 user_agent: 'icoretech-omniauth-spotify gem',
                 accept: 'application/json',
                 content_type: 'application/json'
               }
             }

      uid { raw_info['id'] }

      info do
        {
          name: raw_info['display_name'] || raw_info['id'],
          nickname: raw_info['id'],
          email: raw_info['email'],
          urls: raw_info['external_urls'],
          image: image_url,
          birthdate: parse_birthdate(raw_info['birthdate']),
          country_code: raw_info['country'],
          product: raw_info['product'],
          follower_count: raw_info.dig('followers', 'total')
        }.compact
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('v1/me').parsed
      end

      def image_url
        raw_info.fetch('images', []).first&.fetch('url', nil)
      end

      def authorize_params
        super.tap do |params|
          params[:show_dialog] = true if force_approval_requested?
        end
      end

      def request_phase
        options[:authorize_params][:show_dialog] = request.params['show_dialog'] if request.params.key?('show_dialog')
        super
      end

      def callback_url
        return '' if @authorization_code_from_signed_request

        options[:callback_url] || super
      end

      def query_string
        return '' if request.params['code']

        super
      end

      private

      def force_approval_requested?
        session.delete(FORCE_APPROVAL_KEY) ||
          session.delete(LEGACY_FORCE_APPROVAL_KEY) ||
          flash_force_approval?(FORCE_APPROVAL_KEY) ||
          flash_force_approval?(LEGACY_FORCE_APPROVAL_KEY)
      end

      def flash_force_approval?(key)
        flashes = session.dig(:flash, 'flashes') || session.dig('flash', 'flashes')
        !!flashes&.[](key)
      end

      def parse_birthdate(value)
        return nil if value.to_s.empty?

        Date.iso8601(value)
      rescue Date::Error
        nil
      end
    end
  end
end
