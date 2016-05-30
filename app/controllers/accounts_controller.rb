class AccountsController < ApplicationController

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
    category_key = params[:category_key]
    if category_key.present?
      categories[key: category_key]
    else
      default_category
    end
  end

  def default_category
    categories[key: 'system']
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
