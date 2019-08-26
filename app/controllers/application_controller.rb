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
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def request_login
    redirect_to new_session_path, notice: t('controller.notice.application.authorize_before_signin') if current_user.nil?
  end

  def authorize_role
    redirect_to tasks_path, notice: t('controller.notice.application.authorize_is_admin') if current_user.user?
  end
end
