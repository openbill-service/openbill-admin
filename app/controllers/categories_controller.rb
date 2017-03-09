class CategoriesController < ApplicationController
  def index
    render locals: { categories: categories }
  end

  def new
    render locals: { category: OpenbillCategory.new }
  end

  def show
    redirect_to accounts_path(q: { category_id_eq: params[:id] })
  end

  def edit
    render :edit, locals: { category: category }
  end

  def create
    category = OpenbillCategory.new permitted_params

    if category.valid?
      category.save!
      redirect_to categories_path
    else
      render :new, locals: { category: category }
    end

  rescue => err
    flash.now[:error] = err.message
    render :new, locals: { category: category }
  end

  def update
    category.update permitted_params

    if category.valid?
      redirect_to categories_path
    else
      render :edit, locals: { category: category }
    end

  rescue => err
    flash.now[:error] = err.message
    render :edit, locals: { category: category }
  end

  def destroy
    category.destroy!
    redirect_to :back
  rescue => err
    redirect_to :back, flash: { error: err.message }
  end

  private

  def category
    OpenbillCategory.find params[:id]
  end

  def permitted_params
    params.require(:category).permit(:name, :parent_id)
  end

  def categories
    @_categories ||= OpenbillCategory.all
  end
end
