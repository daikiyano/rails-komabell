class CreateSkillCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_categories do |t|
      t.string :tag_name, null: false, unique: true
      t.string :icon_url
      t.integer :followers_count
      t.integer :items_count

      t.timestamps
    end
  end
end
