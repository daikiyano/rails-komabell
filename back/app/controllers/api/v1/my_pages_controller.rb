class Api::V1::MyPagesController < ApplicationController
  # skip_before_action :require_login, only: [:update]
  
  def update
    if session_user
      user = User.find(session_user.id)  
      if user.update(mypage_params)
        response_success(:user, :update) 
      else
        response_unprocessable_entity
      end
    else
      response_unauthorized
    end
    
  end
  

  def index
  end


 

  private


  def mypage_params
    params.require(:user).permit(:email,:username,:gender,:age,:description,:twitter_id,:facebook_id,:wantedly_id,:github_id)
  end
  
end
