class Api::V1::MyPagesController < ApplicationController
  # skip_before_action :require_login, only: [:update]
  def update
    if session_user
      user = User.find(session_user.id)
      logger.debug(session_user.id)
      logger.debug("hey")
      logger.debug(mypage_params)
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

  def mypage_params
    params.require(:user).permit(:email,:username,:gender,:age,:description,:image,:twitter_id,:facebook_id,:wantedly_id,:github_id)

  end
end
