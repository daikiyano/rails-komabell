module Api
    module V1 

        class BooksController < ApplicationController
            skip_before_action :require_login, only: [:search]

            def search
                @books = RakutenWebService::Books::Book.search(title: "ruby")
                # @root = RakutenWebService::Ichiba::Genre.root # root genre


                 render json: { status: 'success', data: @books }
                   
                
            end
        end
    end
end
