module Api
    module V1 

        class BooksController < ApplicationController
            skip_before_action :require_login, only: [:search,:show]

            PER_PAGE = "100"

            def search
                @books = RakutenWebService::Books::Book.search(booksGenreId: "001005")
                # @root = RakutenWebService::Ichiba::Genre.root # root genre
            #    ビジネス
                # 101905
                # コンピューター
                # 101912
                page = "1"
                url = "https://qiita.com/api/v2/tags?page=" + page + "&per_page=" + PER_PAGE + "&sort=count"
                uri = URI.parse(url)
                response = Net::HTTP.get(uri)
                
                results = JSON.parse(response)
                logger.debug(results)

                for result in results do
                    if result["id"] == "初心者"
                        logger.debug(result["id"])
                    end
                    logger.debug(result["id"])
                    logger.debug(result["icon_url"])
                   
                       
                end
                 render json: { status: 'success', data: @books,tag: results }
               
            end

            def show
                begin
                    @books = RakutenWebService::Books::Book.search(isbn: params[:isbn])
                    render json: { status: 'success', data: @books }
                rescue => e
                    logger.error e
                    response_not_found
                end

                
                # json_request = JSON.parse(response)
                # for object in json_request do
                #     logger.debug(object["id"])
                #     logger.debug(object["icon_url"])
                # end
              
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