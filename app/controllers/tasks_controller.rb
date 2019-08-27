class TasksController < ApplicationController
  before_action :request_login
  before_action :options_content, only: %i[new create edit update]
  before_action :find_task, only: %i[show edit update destroy]
  before_action :search_or_select_with, only: :index
  before_action :sort_with_type, only: :index

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
    search_title_or_description = (params[:search] || '').downcase
    if params[:search].present? && params[:status].present?
      @tasks = current_user.tasks.
               search_with(search_title_or_description).
               status_with(params[:status]).
               page(params[:page]).per(5)

    elsif params[:search].present?
      @tasks = current_user.tasks.
               search_with(search_title_or_description).
               page(params[:page]).per(5)

    elsif params[:search].blank? && params[:status].present?
      @tasks = current_user.tasks.
               status_with(params[:status]).
               page(params[:page]).per(5)

    elsif params[:tag].present?
      @tag = Tag.find_by(name: params[:tag])
      return @tasks = Task.none.page(params[:page]).per(5) if @tag.blank?
      @tasks = @tag.tasks.where(user_id: current_user.id).page(params[:page]).per(5)

    else
      @tasks = current_user.tasks.sort_by_date(sort_column).page(params[:page]).per(5)
    end
  end

  # # Refactor search_or_select_with method
  # # broken feature spec: 'Sort task flow Has correct order by deadline_at'
  # def search_or_select_with
  #   @tag = params[:tag].present? ? Tag.find_by(name: params[:tag]) : nil
  #   @tasks = Task.none.page
  #   return if params[:tag].present? && @tag.blank?

  #   @tasks = get_tasks_with(@tag)
  # end

  # def get_tasks_with(tag = nil)
  #   search_title_or_description = (params[:search] || '').downcase
  #   sql = tag.present? ? tag.tasks.where(user_id: current_user.id) : current_user.tasks
  #   sql.search_with(search_title_or_description).status_with(params[:status]).page(params[:page]).per(5)
  # end

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
