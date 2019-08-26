class TasksController < ApplicationController
  before_action :request_login
  before_action :options_content, only: %i[new create edit update]
  before_action :find_task, only: %i[show edit update destroy]
  # before_action :search, only: :index
  # before_action :select_status_with, only: :index
  before_action :search_or_select_with, only: :index
  before_action :sort_with_type, only: :index

  def index
    # 在這判斷什麼時候要用到 search mehtod，什麼時候用到 select_status_with method
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.new(task_permit_params)
    if @task.save
      redirect_to tasks_path, notice: t('controller.notice.tasks.create_success')
    else
      # 待處理：如果不是重新整理的話，直接點選連結到下一頁，notice 還會再頁面上...
      flash[:notice] = t('controller.notice.tasks.create_failure')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_permit_params)
      redirect_to task_path, notice: t('controller.notice.tasks.update_success')
    else
      flash[:notice] = t('controller.notice.tasks.update_failure')
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('controller.notice.tasks.delete_success')
  end
  
  private

  def sort_with_type
    return search_or_select_with if params[:direction].blank?
    priority_sort_direction
  end

  def search_or_select_with
    if params[:search] && params[:status]
      search_title_or_description = params[:search].downcase
      select_status = params[:status]
      @tasks = current_user.tasks.search_or_select_with(search_title_or_description, select_status).page(params[:page]).per(5)
    elsif params[:search].blank? && status.in?(Task.statuses.keys)
      status = params[:status]&.to_sym
      @tasks = current_user.tasks.try(status).page(params[:page]).per(5)
    # elsif params[:tag]
    #   @tasks = current_user.tasks.search_tagged_with(params[:tag])
    else
      @tasks = current_user.tasks.sort_by_date(sort_column).page(params[:page]).per(5)
    end
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def priority_sort_direction
    direction = params[:direction] == 'asc' ? 'asc' : 'desc'
    @tasks = current_user.tasks.sort_priority_by(params[:direction]).page(params[:page]).per(5)
  end

  def options_content
    @statuses = Task.statuses.keys
    @emergency_levels = Task.emergency_levels.keys
  end
  
  def task_permit_params
    params.require(:task).permit(:title, :description, :status, :started_at, :deadline_at, :emergency_level, :tag_list)
  end
  
  def find_task
    @task = Task.find_by(id: params[:id])
  end
end
