require "test_helper"

module FireEngine
  class HomeControllerTest < ActionDispatch::IntegrationTest
    teardown do
      OmniAuth.config.test_mode = false
      OmniAuth.config.mock_auth[:hackclub] = nil
    end

    test "community manager has fire engine access by default" do
      staff = Staff.create!(user_id: "UTESTCM2", community_manager: true)
      sign_in_as(staff)

      get fire_engine_root_path

      assert_response :success
      assert_select "h1", "Fire Engine"
    end

    test "firefighter has fire engine access" do
      staff = Staff.create!(user_id: "UTESTFF2", firefighter: true)
      sign_in_as(staff)

      get fire_engine_root_path

      assert_response :success
    end

    test "unauthenticated visitor is redirected to login" do
      get fire_engine_root_path

      assert_redirected_to login_path
    end
  end
end
