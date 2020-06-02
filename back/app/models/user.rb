class User < ApplicationRecord
    has_one_attached :image
    validates :email, uniqueness: true

    
end
