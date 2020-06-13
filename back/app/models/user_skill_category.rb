class UserSkillCategory < ApplicationRecord
  belongs_to :user
  belongs_to :skill_category
  validates :user_id,presence: true
  validates :skill_category_id,presence: true


end
