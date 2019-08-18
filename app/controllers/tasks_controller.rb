class TasksController < ApplicationController
  before_action :options_content, only: %i[new create edit update]
  before_action :find_task, only: %i[show edit update destroy]
  before_action :search, only: %i[index deadline_date]
  before_action :create_date, only: :index

  def index
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_permit_params)
    @task.user = User.first  # User 系統完成要移除
    if @task.save
      redirect_to tasks_path, notice: t('controller.notice.create_success')
    else
      # 待處理：如果不是重新整理的話，直接點選連結到下一頁，notice 還會再頁面上...
      flash[:notice] = t('controller.notice.create_failure')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_permit_params)
      redirect_to task_path, notice: t('controller.notice.update_success')
    else
      flash[:notice] = t('controller.notice.update_failure')
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('controller.notice.delete_success')
  end

  def deadline_date
    @tasks = Task.sort_by_deadline_date
  end
  
  private

  def create_date
    @tasks = Task.sort_by_created_date
  end

  def search
    if params[:search]
      @search_params = params[:search].downcase
      @tasks = Task.search_title_and_description(@search_params)
    else
      create_date
    end
  end
  
  def options_content
    @statuses = Task.statuses.keys
    @emergency_levels = Task.emergency_levels.keys
  end
  
  def task_permit_params
    # 等 user 功能建立起來，再看有沒有需要把 :user_id 放入 permit
    params.require(:task).permit(:title, :description, :status, :started_at, :deadline_at, :emergency_level)
  end
  
  def find_task
    @task = Task.find_by(id: params[:id])
  end
  
end
