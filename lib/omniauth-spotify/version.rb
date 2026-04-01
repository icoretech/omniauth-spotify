# frozen_string_literal: true

require "omniauth/spotify/version"

# Backward compatibility for historical constant usage.
module Omniauth
  module Spotify
    VERSION = OmniAuth::Spotify::VERSION
  end
end
