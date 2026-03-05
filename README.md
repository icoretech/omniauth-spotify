# OmniAuth Spotify Strategy

[![Test](https://github.com/icoretech/omniauth-spotify/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/icoretech/omniauth-spotify/actions/workflows/test.yml?query=branch%3Amain)
[![Gem Version](https://badge.fury.io/rb/omniauth-spotify.svg)](https://badge.fury.io/rb/omniauth-spotify)

`omniauth-spotify` provides a Spotify OAuth2 strategy for OmniAuth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-spotify'
```

Then run:

```bash
bundle install
```

## Usage

Configure OmniAuth in your Rack/Rails app:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV.fetch('SPOTIFY_CLIENT_ID'), ENV.fetch('SPOTIFY_CLIENT_SECRET'),
           scope: 'user-read-email user-read-private'
end
```

## Provider App Setup

- Spotify developer dashboard: <https://developer.spotify.com/dashboard>
- OAuth scopes reference: <https://developer.spotify.com/documentation/web-api/concepts/scopes>
- Register callback URL (example): `https://your-app.example.com/auth/spotify/callback`

## Options

- `scope`
- `show_dialog`

## Forcing a Permission Dialog

Spotify may skip the permission dialog when the user already granted access. To force it:

- set `request.env['rack.session']['omniauth_spotify_force_approval?'] = true`, or
- pass `show_dialog=true` on the auth request URL.

Backward compatibility is preserved for the historical misspelled key:
`ommiauth_spotify_force_approval?`.

## Auth Hash

Example payload from `request.env['omniauth.auth']` (real shape, anonymized):

```json
{
  "uid": "1234567890",
  "info": {
    "name": "1234567890",
    "nickname": "1234567890",
    "email": "user@example.test",
    "urls": {
      "spotify": "https://open.spotify.com/user/1234567890"
    },
    "country_code": "IT",
    "product": "free",
    "follower_count": 24
  },
  "credentials": {
    "token": "sample-access-token",
    "refresh_token": "sample-refresh-token",
    "expires_at": 1710000000,
    "expires": true,
    "scope": "user-read-email user-read-private"
  },
  "extra": {
    "raw_info": {
      "country": "IT",
      "display_name": "1234567890",
      "email": "user@example.test",
      "explicit_content": {
        "filter_enabled": false,
        "filter_locked": false
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/user/1234567890"
      },
      "followers": {
        "href": null,
        "total": 24
      },
      "href": "https://api.spotify.com/v1/users/1234567890",
      "id": "1234567890",
      "images": [],
      "product": "free",
      "type": "user",
      "uri": "spotify:user:1234567890"
    }
  }
}
```

`info.image` and `info.birthdate` are included only when Spotify returns those fields.

## Development

```bash
bundle install
bundle exec rake
```

Run Rails integration tests with an explicit Rails version:

```bash
RAILS_VERSION='~> 8.1.0' bundle install
RAILS_VERSION='~> 8.1.0' bundle exec rake test_rails_integration
```

## Test Structure

- `test/omniauth_spotify_test.rb`: strategy/unit behavior
- `test/rails_integration_test.rb`: full Rack/Rails request+callback flow
- `test/test_helper.rb`: shared test bootstrap

## Compatibility

- Ruby: `>= 3.2` (tested on `3.2`, `3.3`, `3.4`, `4.0`)
- `omniauth-oauth2`: `>= 1.8`, `< 2.0`
- Rails integration lanes: `~> 7.1.0`, `~> 7.2.0`, `~> 8.0.0`, `~> 8.1.0`

## Release

Tag releases as `vX.Y.Z`; GitHub Actions publishes the gem to RubyGems.

## License

MIT
