# Test Layout

This suite follows the same structure used across icoretech OmniAuth gems.

- `test/test_helper.rb`: shared bootstrapping and test dependencies.
- `test/omniauth_spotify_test.rb`: strategy/unit-level behavior and mapping assertions.
- `test/rails_integration_test.rb`: end-to-end Rack/Rails request+callback flow.

Conventions:
- Keep provider-specific mapping expectations in the strategy/unit test.
- Keep full OAuth callback flow assertions in the Rails integration test.
