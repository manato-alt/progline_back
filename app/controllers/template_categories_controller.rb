class TemplateCategoriesController < ApplicationController
  def index
    categories = TemplateCategory.all
    render json: categories
  end
end
