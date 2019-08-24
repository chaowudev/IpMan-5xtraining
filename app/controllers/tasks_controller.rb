class TasksController < ApplicationController
  before_action :request_login
  before_action :options_content, only: %i[new create edit update]
  before_action :find_task, only: %i[show edit update destroy]
  before_action :search, only: :index
  before_action :sort_with_type, only: :index
  before_action :select_status_with, only: :index

  def index
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
    return search if params[:direction].blank?
    priority_sort_direction
  end

  def search
    if params[:search]
      search_params = params[:search].downcase
      @tasks = current_user.tasks.search_title_or_description_with(search_params).page(params[:page]).per(5)
    else
      @tasks = current_user.tasks.sort_by_date(sort_column).page(params[:page]).per(5)
    end
  end

  def select_status_with
    case
    when params[:status] == 'to_do' && params[:search] == ''
      @tasks = current_user.tasks.where(status: 'to_do').page(params[:page]).per(5)
    when params[:status] == 'doing' && params[:search] == ''
      @tasks = current_user.tasks.where(status: 'doing').page(params[:page]).per(5)
    when params[:status] == 'done' && params[:search] == ''
      @tasks = current_user.tasks.where(status: 'done').page(params[:page]).per(5)
    when params[:status] == 'achive' && params[:search] == ''
      @tasks = current_user.tasks.where(status: 'achive').page(params[:page]).per(5)
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
