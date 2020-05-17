class AddUserColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username,:string,limit: 25,after: :email
    add_column :users, :gender,:integer,limit: 1,after: :username
    add_column :users, :age,:integer, limit: 1,after: :gender
    add_column :users, :description,:text,after: :age
    add_column :users, :image,:string,limit: 80,after: :description
    add_column :users, :twitter_id,:string,limit: 40,after: :image
    add_column :users, :facebook_id,:string,limit: 40,after: :twitter_id
    add_column :users, :wantedly_id,:string,limit: 40,after: :facebook_id
    add_column :users, :github_id,:string,limit: 40,after: :wantedly_id
  end

  def up
    change_column :users, :email, :string,limit: 25, null: false, unique: true
  end

  def down
    change_column :users, :email, :string
  end
end

