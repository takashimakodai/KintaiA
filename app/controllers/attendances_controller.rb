class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance =Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
    @superior = User.where(superior: true).where.not(id: current_user)
  end
  
  # 残業申請
  def edit_overtime_info
    @attendance = current_user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true).where.not(id: current_user)
  end
 
  # 残業申請のお知らせモーダル
  def news_overtime
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {overtime_at: nil})
    @attendance = Attendance.where.not(overtime_at: nil)
  end
  
  # 勤怠変更申請モーダル
  def change_information
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {finished_at: nil})
    @attendance = Attendance.where.not(finished_at: nil)
  end
  
  # 残業申請更新
  def request_overtime
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業を申請しました"
    else
      fiash[:danger] = "失敗しました"
    end
    redirect_to user_url(current_user) 
  end
  
  # 残業申請への返信
  def reply_overtime
    reply_overtime_params.each do |id, item|
    attendance = Attendance.find(id)
      if attendance.update_attributes(item)
        flash[:success] = "申請に返信しました"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to user_url(current_user)
  end
  
  # 勤怠変更申請への返信
  def reply_change_info
    reply_change_params.each do |id, item|
    attendance = Attendance.find(id)
      if attendance.update_attributes(item)
        flash[:success] = "申請に返信しました"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to user_url(current_user)
  end
  
  # 最後の１ヶ月承認
  def approval_info
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {finished_at: nil})
    @attendance = Attendance.find(params[:id])
    @first_day = Date.current.beginning_of_month
  end
  
  # 最後の1ヶ月承認返信
  def reply_approval_info
    reply_approval_params.each do |id, item|
    attendance = Attendance.find(id)
    if attendance.update_attributes(item)
      flash[:success] = "申請に返信しました"
    else
      flash[:danger] = UPDATE_ERROR_MSG
    end
  end
      
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  private

    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :confirmation_mark])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:overtime_at, :worked_contents, :overtime_mark)
    end
    
    def reply_overtime_params
      params.require(:user).permit(attendances: :mark_by_instructor)[:attendances]
    end
    
    def reply_change_params
      params.require(:user).permit(attendances: :mark_approval)[:attendances]
    end
    
    def reply_approval_info
      params.require(:user).permit(attendances: :mark_approval)[:attendances]
    end
    
    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end
