class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_i18n_locale

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".login"
    redirect_to login_url
  end

  protected

  def set_i18n_locale
    return unless params[:locale]
    if I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale]
    else
      flash.now[:danger] = I18n.t ".controller.application.error"
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
