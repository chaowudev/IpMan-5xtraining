class SessionsController < ApplicationController
  def new 
  end

  def create  # log-in
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: t('controller.notice.sessions.login_success')
    else
      flash[:notice] = t('controller.notice.sessions.login_failure')
      render :new
    end
  end

  def destroy  # log-out
    session[:user_id] = nil
    redirect_to new_session_path, notice: t('controller.notice.sessions.logout_success')
  end
end