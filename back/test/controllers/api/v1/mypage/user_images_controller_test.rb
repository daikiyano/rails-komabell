require 'test_helper'

class Api::V1::Mypage::UserImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get api_v1_mypage_user_images_update_url
    assert_response :success
  end

end
