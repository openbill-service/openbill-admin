class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  private

  def set_locale
    I18n.locale = locale_from_cookie || locale_from_browser || I18n.default_locale
  end

  def locale_from_cookie
    loc = cookies[:locale]&.to_sym
    loc if I18n.available_locales.include?(loc)
  end

  def locale_from_browser
    http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def page
    params[:page].try(:to_i) || 1
  end

  def per_page
    params[:per_page].try(:to_i) || Kaminari.config.default_per_page
  end
end
