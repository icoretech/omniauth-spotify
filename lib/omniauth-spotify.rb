require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Spotify < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, 'spotify'

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site          => 'https://api.spotify.com/v1',
        :authorize_url => 'https://accounts.spotify.com/authorize',
        :token_url     => 'https://accounts.spotify.com/api/token',
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['id'] }

      info do
        {
          # display_name may be empty if user does not request
          #  'user-read-private'
          :name => raw_info['display_name'] || raw_info['id'],
          :nickname => raw_info['id'],
          :email => raw_info['email'],
          :urls => raw_info['external_urls'],
          :image => image_url
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def image_url
        if images = raw_info['images']
          if first = images.first
            first['url']
          end
        end
      end

      def raw_info
        @raw_info ||= access_token.get('me').parsed
      end

      # Workaround for for https://github.com/intridea/omniauth-oauth2/issues/28
      def callback_url
        full_host + script_name + callback_path + query_string
      end
    end
  end
end
