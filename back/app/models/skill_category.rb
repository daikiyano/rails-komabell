class SkillCategory < ApplicationRecord
    has_many :users,through: :user_skill_categories
    has_many :user_skill_categories,dependent: :destroy

end
