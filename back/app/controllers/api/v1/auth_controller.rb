module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :require_login, only: [:login, :auto_login,:token_check,:create,:signin]
      
      def create
        user = User.new(email: params[:email])
          if user.save
            user.update!(login_token: SecureRandom.urlsafe_base64,
            login_token_valid_until: Time.now + 60.minutes)
            url = "http://localhost:8080?token=" + user.login_token
            UserMailer.magic_login_email(user,url).deliver_later
            render json: {test: "send_email" ,success: "Welcome back, #{user.email}"}
          else
            logger.debug(user.errors.full_messages)
            # rescue ActiveRecord::RecordNotFound
            # rescue ActiveRecord::RecordNotFound
            response_unprocessable_entity
            # render json: {error: user.errors.full_messages }
        end
      end

      def signin
        user = User.find_by!(email: params[:email])
        user.update!(login_token: SecureRandom.urlsafe_base64,
        login_token_valid_until: Time.now + 60.minutes)
        url = "http://localhost:8080?token=" + user.login_token
        UserMailer.magic_login_email(user,url).deliver_later
        render json: {test: "send_email" ,success: "Welcome back, #{user.email}"}
        rescue ActiveRecord::RecordNotFound
        response_unprocessable_entity
        # render json: { error: 'メールアドレスが未登録です' }
      end

      # マジックリンクのtokenが有効か確認し、有効だったらemailをrenderする
      def token_check
          user = User.where(login_token: params[:token]).where('login_token_valid_until > ?', Time.now).first
          if user
            user.update!(login_token: nil, login_token_valid_until: 1.year.ago)
            render json: {email: user.email}
          else
            # render json: { error: "トークンが無効です"}
            response_unauthorized
          end
      end

      #マジックリンくが有効だったら、emailを元にtokenを発行する
      def login
        user = User.where(email: params[:email]).first
        if user
          payload = {user_id: user.id,email: user.email}
          token = encode_token(payload)
          logger.debug("if文の中に入りましたaaaaaaaaaaaaaaaaaa")
            # テスト
            logger.debug(token)
            render json: {token: token ,success: "Welcome back, #{user.email}"}
      
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

      private

      def auth_params
        params.permit(:user).permit(:email,:login_token,:login_token_valid_until)
      end
    
    end
  end
end
