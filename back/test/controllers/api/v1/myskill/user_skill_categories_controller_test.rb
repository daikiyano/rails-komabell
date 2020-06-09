require 'test_helper'

class Api::V1::Myskill::UserSkillCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get api_v1_myskill_user_skill_categories_new_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_myskill_user_skill_categories_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_myskill_user_skill_categories_update_url
    assert_response :success
  end

end
