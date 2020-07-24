module Api
    module V1 
        class SkillCategoriesController < ApplicationController
            skip_before_action :require_login, only: [:fetch_categories]

            def fetch_categories
                @skillcategories = SkillCategory.select(:id, :tag_name,:icon_url)
                logger.debug("#######TEST#####")
                render json: { status: 'success',tag: @skillcategories}
            end
        end
    end
end
