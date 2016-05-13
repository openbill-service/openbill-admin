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
    category_name = params[:category]
    return category_name if categories.map(&:name).include? category_name
    default_category
  end

  def default_category
    categories.first.try(:name) || 'UNKNOWN'
  end

  def filter_params
    params[:philtre]
  end

  def filter
    Philtre.new(filter_params)
  end

  def accounts
    filter.apply(Openbill.service.accounts).where(category: current_category).paginate page, per_page
  end

  def categories
    @_categories ||= Openbill.service.categories
  end
end
