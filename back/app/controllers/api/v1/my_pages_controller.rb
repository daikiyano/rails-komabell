class Api::V1::MyPagesController < ApplicationController
  skip_before_action :require_login, only: [:update]
  def update
    
    # logger.debug("hey")
    #   logger.debug(session_user)
    # # end
    user = User.find(params[:id])
    logger.debug(user.email)
    logger.debug("hey")
    user.update(mypage_params)
    logger.debug(user.username)
    render json: {test: user ,success: "Welcome back, #{user.email}"}
  rescue ActiveRecord::RecordNotFound
  end

  def index
  end


  private

  def mypage_params
    params.require(:user).permit(:email,:username,:gender,:age,:description,:image,:twitter_id,:facebook_id,:wantedly_id,:github_id)
  end
end
