class Admin::UsersController < ApplicationController
  before_action :request_login
  before_action :authorize_role
  before_action :find_user, only: %i[show edit update destroy]
  before_action :options_content, only: %i[new create edit update]

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_permit_params)
    if @user.save
      redirect_to admin_users_path, notice: t('controller.notice.admin.create_success')
    else
      flash[:notice] = t('controller.notice.admin.create_failure')
      render :new
    end
  end

  def show
    @tasks = @user.tasks.page(params[:page]).per(5)
  end

  def edit
  end

  def update
    user = User.find_by_email(params[:user][:email])
    if @user.update(user_permit_params)
      redirect_to admin_users_path, notice: t('controller.notice.admin.update_success')
    else
      flash[:notice] = t('controller.notice.admin.update_failure')
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: t('controller.notice.admin.delete_success')
  end

  private

  def options_content
    @roles = User.roles.keys
  end

  def user_permit_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end
end
