require "test_helper"

class UserQuizAttemptsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_quiz_attempts_create_url
    assert_response :success
  end

  test "should get show" do
    get user_quiz_attempts_show_url
    assert_response :success
  end
end
