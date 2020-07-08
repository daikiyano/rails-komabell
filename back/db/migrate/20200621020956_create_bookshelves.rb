class CreateBookshelves < ActiveRecord::Migration[6.0]
  def change
    create_table :bookshelves do |t|
      t.references :user, null: false, foreign_key: true
      t.string :lsbn, null: false
      t.string :imageurl
      t.text :memo

      t.timestamps
    end
  end
end

