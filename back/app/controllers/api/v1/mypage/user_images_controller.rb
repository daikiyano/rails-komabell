class Api::V1::Mypage::UserImagesController < ApplicationController
  def update
    if session_user
      user = User.find(session_user.id)  
      if image = params[:user][:image]
        user.parse_base64(params[:user][:image])
        if user.save
          response_success(:user, :update) 
        else
          response_unprocessable_entity
        end
      else 
        response_bad_request
      end     
      
    else
      response_unauthorized
    end
  end

  private
  def images_params
    params.require(:user).permit(:image)
  end
end
