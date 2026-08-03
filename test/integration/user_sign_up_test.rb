require "test_helper"

class UserSignUpTest < ActionDispatch::IntegrationTest
  test "signs up with valid details and is redirected to the company profile" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          email: "new_sign_up@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to edit_company_path
    follow_redirect!
    assert_response :success
  end

  test "rejects sign up with mismatched password confirmation" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "mismatch@example.com",
          password: "password123",
          password_confirmation: "somethingelse"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "rejects sign up with a duplicate email" do
    User.create!(email: "duplicate@example.com", password: "password123")

    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "duplicate@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
