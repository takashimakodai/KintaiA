class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_or_correct_user, only: :show 
  before_action :set_one_month, only: :show

  def index
    @users = query_params.order(:id).page(params[:page])
  end

  def show
    @all_attendance = Attendance.all
    @worked_sum = @attendances.where.not(started_at: nil).count
    @overtime_at = @attendances.where.not(overtime_at: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

   # 出勤社員一覧
  def currently_working
    @user = User.all
  end
  
   # 出勤社員一覧
  def currently_working
    @user = User.all
  end
  
  

  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    def user_search_params
      params.require(:user).permit(:name)
    end
    
    def query_params
      if params[:user].present? && params[:user][:name]
        User.where('LOWER(name) LIKE ?', "%#{params[:user][:name].downcase}%")
      else
        User.all
      end
    end
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
     # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "閲覧権限がありません。"
        redirect_to(root_url)
      end
    end
end
