class CreateUserSkillCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_skill_categories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill_category, null: false, foreign_key: true
      t.integer :skill

      t.timestamps
    end
    add_index :user_skill_categories, :skill
    add_index :user_skill_categories, [:user_id,:skill_category_id],unique: true
  end
end
