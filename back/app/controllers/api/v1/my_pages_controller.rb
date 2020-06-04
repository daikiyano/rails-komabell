class Api::V1::MyPagesController < ApplicationController
  # skip_before_action :require_login, only: [:update]
  def update
    if session_user
      user = User.find(session_user.id)  
      if image = params[:user][:image]
        
        logger.debug("##################")
        # metadata = "data:image/jpeg;base64," 
        # logger.debug(metadata)
        # base64_string = image[metadata.size..-1] 
        # logger.debug(base64_string)
        # blob = Base64.decode64(base64_string) 
        image = image.split(",")[-1]
        logger.debug(image.class)
        # image = image + "="
        decoded_data = Base64.decode64(image).force_encoding('UTF-8')
        logger.debug(decoded_data)
        

      end
            
      user.update!(mypage_params)
      response_success(:user, :update)
    else
      response_unauthorized
    end
    rescue ActiveRecord::RecordNotFound
    response_unprocessable_entity
  end

  def index
  end


  private

  def create_extension(image)
    content_type = rex_image(image)
    content_type[%r/\b(?!.*\/).*/]
  end

  def rex_image(image)
    image[%r/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/]
  end

  def mypage_params
    params.require(:user).permit(:email,:username,:gender,:age,:description,:image,:twitter_id,:facebook_id,:wantedly_id,:github_id)

  end
end
