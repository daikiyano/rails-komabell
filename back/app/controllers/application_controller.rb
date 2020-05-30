class ApplicationController < ActionController::API
    before_action :require_login
    def logged_in?
        !!session_user
    end

    def require_login
        render json: {message: 'please login'},status: :unauthorized unless logged_in? 
    end

    def encode_token(payload)
        JWT.encode(payload,'my_secret','HS256')
    end

    def session_user
        decoded_hash = decoded_token
        if !decoded_hash.empty?
            user_id = decoded_hash[0]['user_id']
            @user = User.find_by(id: user_id)
        else 
            nil
        end
    end

    def auth_header
      logger.debug(request.headers['Authorization'])
        logger.debug("session")
        request.headers['Authorization']
    end 

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'my_secret', true,algorithm: 'HS256')
            rescue JWT::DecodeError
                []
            end
        end
    end

    def response_success(class_name, action_name)
        render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
      end
      
      # 400 Bad Request
      def response_bad_request
        render status: 400, json: { status: 400, message: 'Bad Request' }
      end
      
      # 401 Unauthorized
      def response_unauthorized
        render status: 401, json: { status: 401, message: 'Unauthorized' }
      end

      def response_unprocessable_entity
        render status: 422, json: { status: 422, message: 'unprocessable_entity' }
      end
      
      # 404 Not Found
      def response_not_found(class_name = 'page')
        render status: 404, json: { status: 404, message: "#{class_name.capitalize} Not Found" }
      end
      
      # 409 Conflict
      def response_conflict(class_name)
        render status: 409, json: { status: 409, message: "#{class_name.capitalize} Conflict" }
      end
      
      # 500 Internal Server Error
      def response_internal_server_error
        render status: 500, json: { status: 500, message: 'Internal Server Error' }
      end

end
