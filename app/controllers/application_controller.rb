class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def page
    params[:page].try(:to_i) || 1
  end

  def per_page
    params[:per_page].try(:to_i) || Kaminari.config.default_per_page
  end

  def filter_params
    params[:philtre]
  end

  def filter
    Philtre.new(filter_params)
  end
end
