class Api::V1::Book::BookshelvesController < ApplicationController
  
  def index
    @bookshelves = Bookshelf.where(user_id: session_user.id)
    logger.debug(@bookshelves)
    render json: { status: 'success', data: @books}
  end
  def create
    user_id = session_user.id
    logger.debug("hey")
    logger.debug(session_user.id)
    bookshelf = Bookshelf.new(bookshelf_params)
    bookshelf.user_id = session_user.id
    if bookshelf.save
      response_success(:bookshelf, :create) 
    else
      response_unprocessable_entity
    end
  end

  def update
  end

  private
  def bookshelf_params
    params.require(:bookshelf).permit(:lsbn,:imageurl,:memo)
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