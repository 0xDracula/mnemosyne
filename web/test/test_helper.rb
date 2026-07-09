ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    fixtures :all

    def sign_in_as(staff)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:hackclub] = OmniAuth::AuthHash.new(
        provider: "hackclub",
        uid: "ident!#{staff.user_id}",
        info: {},
        extra: { raw_info: { "slack_id" => staff.user_id } }
      )
      get "/auth/hackclub/callback"
    end
  end
end
