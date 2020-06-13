class Api::V1::Myskill::UserSkillCategoriesController < ApplicationController


    def index
            @user_skill_arrays = SkillCategory.joins(:user_skill_categories).where(user_skill_categories: {user_id: session_user.id}).select(:id,:tag_name,:icon_url,:skill)
            logger.debug(@user_skill_arrays.to_yaml)             
        render json: { status: 'success', data: @user_skill_arrays }
      end

    def create  
        skill_arrays = params[:user_skill_category][:skill_arrays]
        if session_user && skill_arrays
            begin
                UserSkillCategory.transaction do
                    skill_arrays.each { |skill_array|
                        selected_category = SkillCategory.find(skill_array[0])
                        # logger.debug(@selected_category.id)
                        logger.debug("###############3")
                        skill_check = UserSkillCategory.find_by(user_id: session_user.id,skill_category_id: selected_category.id)
                        logger.debug(skill_check.id)
                        if !skill_check.present?
                          # UserSkillCategory.update(user_id: session_user.id,skill_category_id: selected_category.id,skill: skill_array[2])
                        # else
                          UserSkillCategory.create(user_id: session_user.id,skill_category_id: selected_category.id,skill: skill_array[2])
                        end
                        # logger.debug(skill.tag_name)
                    }
                end
                
                @user_tag = SkillCategory.where(user_id: session_user.id)
                render json: { status: 'success', data: @user_tag}
            rescue => e
                response_unprocessable_entity
                logger.debug(e)
                # logger.debug("@@@@@@@@@@@")
            end
        else
            response_unauthorized
        end
    end

  def update
    skill_arrays = params[:user_skill_category][:skill_arrays]
    category_list = params[:user_skill_category][:category_list]
    
    logger.debug(category_list)
    if session_user && skill_arrays
      
      
      begin
          UserSkillCategory.transaction do
            delete_tag = UserSkillCategory.where.not(skill_category_id: category_list).where(user_id: session_user.id)
            logger.debug(delete_tag.to_yaml)
            delete_tag.delete_all
            logger.debug("??????????????")
            user_tags = UserSkillCategory.where(user_id: session_user.id)
            logger.debug("@@@@@@@@@@@")
            logger.debug(skill_arrays)
            logger.debug(user_tags.to_yaml)
              skill_arrays.each { |skill_array|
                  selected_category = SkillCategory.find(skill_array[0])
                  logger.debug("###############3")
                  skill_check = UserSkillCategory.find_or_create_by(user_id: session_user.id,skill_category_id: selected_category.id)
                  # skill_check = UserSkillCategory.find_by(user_id: session_user.id,skill_category_id: selected_category.id)
                  # logger.debug(skill_check.to_yaml)
                  # if skill_check.new_record?
                    skill_check.update_attributes(user_id: session_user.id,skill_category_id: selected_category.id,skill: skill_array[2])
                  # else
                  #   skill_check.create(user_id: session_user.id,skill_category_id: selected_category.id,skill: skill_array[2])
                  # end
                 
              }
          end
          
          @user_tag = UserSkillCategory.where(user_id: session_user.id)
          render json: { status: 'success', data: @user_tag}
      rescue => e
          response_unprocessable_entity
          logger.debug(e)
      end
  else
      response_unauthorized
  end

  end



  private

  def mypage_params
    params.require(:user_skill_category).permit(:skill_arrays,:category_list)
  end

end