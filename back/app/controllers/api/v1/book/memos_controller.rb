class Api::V1::Book::MemosController < ApplicationController

    def update
        logger.debug(params[:bookshelf][:memo])
        @bookshelf = Bookshelf.find_by(user_id: session_user.id, isbn: params[:bookshelf][:isbn])
        logger.debug(@bookshelf.to_yaml)
        @bookshelf.memo = params[:bookshelf][:memo]
        if @bookshelf.update(bookshelf_params)
            render json: { status: 'success', data: @bookshelf}
        else
            response_unprocessable_entity
        end
    end

    private
    def bookshelf_params
        params.require(:bookshelf).permit(:isbn,:imageurl,:memo)
    end
end
