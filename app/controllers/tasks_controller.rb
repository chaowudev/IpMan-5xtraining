class TasksController < ApplicationController
  before_action :options_content, only: %i[new create]

  def index
    @tasks = Task.all  # 之後做分頁功能時要再做修正，不要使用 .all
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
      render :new, notice: 'Create failure'
    end
  end
  
  private
  
  def options_content
    @status = Task.statuses.keys.to_a
    @emergency_level = Task.emergency_levels.keys.to_a
  end
  
  def task_permit_params
    # 等 user 功能建立起來，再看有沒有需要把 :user_id 放入 permit
    params.require(:task).permit(:title, :description, :status, :started_at, :deadline_at, :emergency_level)
  end
  
end
