class TasksController < ApplicationController
  before_action :options_content, only: %i[new create edit update]
  before_action :find_task, only: %i[show edit update destroy]
  before_action :search, only: :index

  def index
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_permit_params)
    @task.user = User.first  # User 系統完成要移除
    if @task.save
      redirect_to tasks_path, notice: 'Create Success'
    else
      # 待處理：如果不是重新整理的話，直接點選連結到下一頁，notice 還會再頁面上...
      flash[:notice] = 'Create Failure, please fill in all columns'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_permit_params)
      redirect_to task_path, notice: 'Update Success'
    else
      flash[:notice] = 'Update Failure'
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Delete Success'
  end
  
  private

  def search
    if params[:search]
      @search_params = params[:search].downcase
      # 模糊比對且不論大小寫都能夠搜尋到
      @tasks = Task.where('lower(title) LIKE ? OR lower(description) LIKE ?', "%#{@search_params}%", "%#{@search_params}%")
    else
      @tasks = Task.all.order(:created_at)  # 之後做分頁功能時要再做修正，不要使用 .all
    end
  end
  
  def options_content
    @status = Task.statuses.keys.to_a
    @emergency_level = Task.emergency_levels.keys.to_a
  end
  
  def task_permit_params
    # 等 user 功能建立起來，再看有沒有需要把 :user_id 放入 permit
    params.require(:task).permit(:title, :description, :status, :started_at, :deadline_at, :emergency_level)
  end
  
  def find_task
    @task = Task.find_by(id: params[:id])
  end
  
end
