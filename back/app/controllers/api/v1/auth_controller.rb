module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :require_login, only: [:login, :auto_login]
      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          payload = {user_id: user.id,email: user.email}
          token = encode_token(payload)
          render json: {jwt: token,success: "Welcome back, #{user.email}"}
        else
          response_unauthorized
        end
      end

      def auto_login
        if session_user 
          render json: session_user
        else
          render json: {errors: "No user Logged In"}
        end
      end

      def user_is_authed
        render json: {message: "You are authorized"}
      end
    end
  end
end
