# Spotify OmniAuth Strategy

This gem provides a simple way to authenticate to Spotify Web API using OmniAuth with OAuth2.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-spotify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-spotify

## Usage

You'll need to register an app on Spotify, you can do this here - https://developer.spotify.com/my-applications/#!/

Usage of the gem is very similar to other OmniAuth strategies.
You'll need to add your app credentials to `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, 'app_id', 'app_secret', scope: 'playlist-read-private user-read-private user-read-email'
end
```

Please replace the example `scope` provided with your own.
Read more about scopes here: https://developer.spotify.com/web-api/using-scopes/

Or with Devise in `config/initializers/devise.rb`:

```ruby
config.omniauth :spotify, 'app_id', 'app_secret', scope: 'playlist-read-private user-read-private user-read-email'
```

## Auth Hash Schema

Here's an example auth hash, available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => "spotify",
  :uid => "1111111111",
  :info => {
    :name => "Claudio Poli",
    :email => "claudio@icorete.ch"
  },
  :credentials => {
    :token => "xxxx",
    :refresh_token => "xxxx",
    :expires_at => 1403021232,
    :expires => true
  },
  :extra => {
    :raw_info => {
      :country => "IT",
      :display_name => "Claudio Poli",
      :email => "claudio@icorete.ch",
      :external_urls => {
        :spotify => "https://open.spotify.com/user/1111111111"
      },
      :href => "https://api.spotify.com/v1/users/1111111111",
      :id => "1111111111",
      :images => [
        {
          "height" => nil,
          "url" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/s320x320/301234_1962753760624_625151598_n.jpg",
          "width" => nil
        }
      ],
      :product => "open",
      :type => "user",
      :uri => "spotify:user:1111111111"
    }
  }
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
