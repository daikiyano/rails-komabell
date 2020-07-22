class Api::V1::Book::BookshelvesController < ApplicationController
  
  def index
    @bookshelves = Bookshelf.where(user_id: session_user.id)
    logger.debug(@bookshelves)
    render json: { status: 'success', bookshelves: @bookshelves}
  end
  def create
    user_id = session_user.id
    logger.debug("hey")
    logger.debug(session_user.id)
    bookshelf = Bookshelf.new(bookshelf_params)
    bookshelf.user_id = session_user.id
    if bookshelf.save
      @bookshelf = Bookshelf.exists?(isbn: params[:bookshelf][:isbn],user_id: session_user.id)
      render json: { status: 'success' , IsBookshelf: @bookshelf}
    else
      response_unprocessable_entity
    end
  end

  def destroy
    logger.debug("hey")
    logger.debug(params[:bookshelf][:isbn])
    bookshelf = Bookshelf.find_by(isbn: params[:bookshelf][:isbn],user_id: session_user.id)
    logger.debug(bookshelf.to_yaml)
    if bookshelf.destroy
      @bookshelf = Bookshelf.exists?(isbn: params[:bookshelf][:isbn],user_id: session_user.id)
      render json: { status: 'success',  IsBookshelf: @bookshelf}
    else
      response_unprocessable_entity
    end
  end

  private
  def bookshelf_params
    params.require(:bookshelf).permit(:isbn,:imageurl,:memo)
  end

  
end

# reate_table "bookshelves", force: :cascade do |t|
#   t.bigint "user_id", null: false
#   t.string "lsbn", null: false
#   t.string "imageurl"
#   t.text "memo"
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.index ["user_id"], name: "index_bookshelves_on_user_id"