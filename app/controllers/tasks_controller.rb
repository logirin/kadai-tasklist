class TasksController < ApplicationController
  before_action :require_user_logged_in
  #before_action :correct_user, only: [:destroy,:update,:show] #こっちは/task/numberで別のユーザのタスクリストにアクセスできた
  before_action :correct_user, only: [:destroy,:show,:edit,:update]
  def index
    #if logged_in?
      #@task = current_user.tasks.build
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    #end
  end

  def show
    #@task=Task.find(params[:id])
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def new
     @task=Task.new
  end

  def create
      @task = current_user.tasks.build(task_params)
      
      if @task.save
          flash[:success]='Taskが正常に作成されました'
          redirect_to root_url
      else
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        flash.now[:danger]='Taskが作成できませんでした'
        render :new
      end
  end

  def edit
    #@task=Task.find(params[:id])
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def update
      #@task = current_user.tasks.build(task_params)
      @task = current_user.tasks.find_by(id: params[:id])
      if @task.update(task_params)
          flash[:success]='Taskは正常に更新されました'
          redirect_to root_url
      else
          flash.now[:danger]='Taskは更新されませんでした'
          render :new
      end
  end

  def destroy
    
    @task.destroy
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to root_url
  end


  private
  
  def task_params
      params.require(:task).permit(:content,:status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
