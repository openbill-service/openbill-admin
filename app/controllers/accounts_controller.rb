class AccountsController < ApplicationController
  DEFAULT_CATEGORY_ID = '12832d8d-43f5-499b-82a1-3466cadcd809'

  helper_method :filter, :filter_params, :current_category

  def index
    render locals: {
      accounts: accounts,
      categories: categories
    }
  end

  def show
  end

  private

  def current_category
    category_id = params[:category_id]
    if category_id.present?
      categories[id: category_id]
    else
      default_category
    end
  end

  def default_category
    categories[id: DEFAULT_CATEGORY_ID]
  end

  def filter_params
    params[:philtre]
  end

  def filter
    Philtre.new(filter_params)
  end

  def accounts
    filter.apply(Openbill.service.accounts).where(category_id: current_category.id).paginate page, per_page
  end

  def categories
    @_categories ||= Openbill.service.categories
  end
end
