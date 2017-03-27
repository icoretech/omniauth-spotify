# Spotify OmniAuth Strategy

This gem provides a simple way to authenticate to the Spotify Web API using OmniAuth with OAuth2.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-spotify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-spotify

## Usage

You'll need to register an app on Spotify, you can do this here - https://developer.spotify.com/my-applications/#!/applications

Usage of the gem is very similar to other OmniAuth strategies.
You'll need to add your app credentials to `config/initializers/omniauth.rb`:

```ruby
keys = Rails.application.secrets

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, keys.spotify['client_id'], keys.spotify['client_secret'], scope: 'playlist-read-private user-read-private user-read-email'
end
```

Please replace the example `scope` provided with your own.
Read more about scopes here: https://developer.spotify.com/web-api/using-scopes/

Or with Devise in `config/initializers/devise.rb`:

```ruby
keys = Rails.application.secrets

config.omniauth :spotify, keys.spotify['client_id'], keys.spotify['client_secret'], scope: 'playlist-read-private user-read-private user-read-email'
```

## Forcing a Permission-Request Dialog

If a user has given permission for an app to access a scope, that permission won't be asked again unless the user revokes access.
In these cases, authorization sequences proceed without user interation.

To force a permission dialog being shown to the user, which also makes it possible for them to switch Spotify accounts,
set either `request.env['rack.session'][:ommiauth_spotify_force_approval?]` or `flash[:ommiauth_spotify_force_approval?]` (Rails apps only)
to a truthy value on the request that performs the Omniauth redirection. 

Alternately, you can pass `show_dialog=true` when you redirect to your spotify auth URL if you prefer not to use the session. 
```
http://localhost:3000/auth/spotify?show_dialog=true
```

## Auth Hash Schema

* Authorization data is available in the `request.env['omniauth.auth'].credentials` -- a hash that also responds to
the `token`, `refresh_token`, `expires_at`, and `expires` methods.

```ruby
 {
    "token" => "xxxx",
    "refresh_token" => "xxxx",
    "expires_at" => 1403021232,
    "expires" => true
 }
```

* Information about the authorized Spotify user is available in the `request.env['omniauth.auth'].info` hash. e.g.

```ruby
 {
    :name => "Claudio Poli",
    :nickname => "SomeName",
    :email => "claudio@icorete.ch",
    :urls => {"spotify" => "https://open.spotify.com/user/1111111111"},
    :image => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/s320x320/301234_1962753760624_625151598_n.jpg",
    :birthdate => Mon, 01 Mar 1993, # Date class
    :country_code => "IT",
    :product => "open",
    :follower_count => 10
  }
```

The username/nickname is also available via a call to `request.env['omniauth.auth'].uid`.

  * Unless the `user-read-private` scope is included, the `birthdate`, `country`, `image`, and `product` fields may be `nil`,
    and the `name` field will be set to the username/nickname instead of the display name.
  * The email field will be nil if the 'user-read-email' scope isn't included.


* The raw response to the `me` endpoint call is also available in  `request.env['omniauth.auth'].extra['raw_info']`. e.g.

```ruby
{
  "country" => "IT",
  "display_name" => "Claudio Poli",
  "birthdate" => "1993-03-01",
  "email" => "claudio@icorete.ch",
  "external_urls" => {
    "spotify" => "https://open.spotify.com/user/1111111111"
  },
  "followers" => {
    "href" => nil,
    "total" => 10
  },
  "href" => "https://api.spotify.com/v1/users/1111111111",
  "id" => "1111111111",
  "images" => [
    {
      "height" => nil,
      "url" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/s320x320/301234_1962753760624_625151598_n.jpg",
      "width" => nil
    }
  ],
  "product" => "open",
  "type" => "user",
  "uri" => "spotify:user:1111111111"
}

```

## More

This gem is brought to you by the [AudioBox](https://audiobox.fm) guys.
Enjoy!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
