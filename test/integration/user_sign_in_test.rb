require "test_helper"

class UserSignInTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "sign_in_test@example.com", password: "password123")
  end

  test "signs in with valid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: "password123" } }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "rejects invalid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: "wrongpassword" } }

    assert_response :unprocessable_entity
    assert_no_match(/signed in successfully/i, response.body)
  end
end
