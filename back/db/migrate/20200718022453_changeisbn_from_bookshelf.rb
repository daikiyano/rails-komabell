class ChangeisbnFromBookshelf < ActiveRecord::Migration[6.0]
  def change
    rename_column :bookshelves ,:lsbn, :isbn
  end
end
