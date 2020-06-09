class Api::V1::Myskill::UserSkillCategoriesController < ApplicationController
  def new
  end

  def create  
    skill_arrays = params[:user_skill_category][:skill_arrays]
    if session_user && skill_arrays
      skill_arrays.each{ |skill_array|
      @selected_category = SkillCategory.find(skill_array[0])
      logger.debug(@selected_category.tag_name)
      # logger.debug(skill.tag_name)
      # logger.debug(session_user.to_yaml)
      }
      logger.debug("##########")
    else
      response_unauthorized
    end

  end

  def update
  end

  private

  def mypage_params
    params.require(:user_skill_category).permit(:skill_arrays)
  end

end