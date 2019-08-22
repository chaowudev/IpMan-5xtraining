class ApplicationController < ActionController::Base
  before_action :set_locale
  helper_method :current_user

  private

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_user
    redirect_to new_session_path, notice: t('controller.notice.application.authorize_before_signin') if current_user.nil?
  end

end
