module Api
    module V1 
        class BooksController < ApplicationController
            skip_before_action :require_login, only: [:search,:show]
            def search
                category = params[:book_category]

                if category = params[:book_category]
                    begin
                        if category == "001005"
                            @books = RakutenWebService::Books::Book.search(booksGenreId: "001005")
                        else 
                            @books = RakutenWebService::Books::Book.search(title: category)
                        end
                        render json: { status: 'success', data: @books}
                    rescue => e
                        logger.error e
                        response_not_found
                else
                    response_bad_request
                end
                   
                # @root = RakutenWebService::Ichiba::Genre.root # root genre
            #    ビジネス
                # 101905
                # コンピューター
                # 101912
            end

            def show
                begin
                    @books = RakutenWebService::Books::Book.search(isbn: params[:isbn])
                    render json: { status: 'success', data: @books }
                rescue => e
                    logger.error e
                    response_not_found
                end
            end

        end
    end
end


# @books = RakutenWebService::Books::Book.search(isbn: "001020",sort:"sales")
 #  ビジネスヒット
#  @books = RakutenWebService::Books::Book.search(booksGenreId: "001020",sort:"sales")

                #  @books = RakutenWebService::Books::Book.search(booksGenreId: "001006",sort:"reviewCount")

                #  コンピューター新着
                #  001005
                #  ビジネス経済新着
                #  001006