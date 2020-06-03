class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :csv_output]
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  #before_action :correct_user, only: [:edit_one_month, :update_one_month]
  before_action :admin_not_correct_user, only: [:edit_one_month, :update_one_month, :log_info]
  before_action :superior_or_correct_user, only: [:edit_one_month, :update_one_month, :log_info]
  before_action :set_one_month, only: [:edit_one_month, :csv_output]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance =Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at_before.nil?
      if @attendance.update_attributes(started_at_before: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at_before.nil?
      if @attendance.update_attributes(finished_at_before: Time.current.change(sec: 0))
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
  
  # csv出力
  def csv_output
    @first_day = Date.current.beginning_of_month
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "当月分勤怠データ.csv", type: :csv
      end
    end
  end
  
  # 残業申請登録
  def edit_overtime_info
    @attendance = current_user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true).where.not(id: current_user)
  end
 
  # 残業申請のお知らせモーダル
  def news_overtime
    @user = User.joins(:attendances).group("users.id").where(attendances: {overtime_mark: current_user.name}).where(attendances: {mark_by_instructor: "申請中"})
    @attendance = Attendance.where.not(overtime_at: nil).all.order("worked_on ASC")
  end
  
  # 勤怠変更申請モーダル
  def change_information
    @user = User.joins(:attendances).group("users.id").where(attendances: {confirmation_mark: current_user.name, mark_approval: "申請中"})
    @attendance = Attendance.where.not(finished_at: nil).all.order("worked_on ASC")
  end
  
  # 残業申請
  def request_overtime
    @attendance = Attendance.find(params[:id])
      if overtime_params[:overtime_mark].present? && overtime_params[:overtime_at].present?
        @attendance.update_attributes(overtime_params) 
        flash[:success] = "終了予定時間を申請しました。"
      else
        flash[:danger] = "終了予定時間の申請に失敗しました。"
      end
    redirect_to user_url(current_user)
  end
  
  # 残業申請への返信
  def reply_overtime
    reply_overtime_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:change_at] == "1" 
        attendance.update_attributes(item)
        flash[:success] = "変更チェックした申請を登録しました。申請中の場合は再登録が必要です。"
      end
    end
    
    if flash[:success].blank?
      flash[:danger] = "変更チェックが必要です。"
    end
    redirect_to user_url(current_user)
  end
  
  # 勤怠変更申請への返信
  def reply_change_info
    reply_change_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:change_at] == "1"
        attendance.update_attributes(item)
        flash[:success] = "変更チェックした申請を登録しました。申請中の場合は再登録が必要です。"
      end
    end
    
    if flash[:success].blank?
      flash[:danger] = "変更チェックが必要です。"
    end
    redirect_to user_url(current_user)
  end
    
  # 最終申請モーダル
  def approval_info
    @user = User.joins(:attendances).group("users.id").where(attendances: {finish_mark: current_user.name}).where(attendances: {mark_by_finish: "申請中"})
    @attendance = Attendance.where.not(appl_month: nil).all.order("worked_on ASC")
    @first_day = Date.current.beginning_of_month
  end
 
 # 最終申請
  def request_approval_info
    approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:finish_mark].present? 
        attendance.update_attributes(item)
        flash[:success] = "最終申請しました。"
      else
        flash[:danger] = "最終申請に失敗しました。"
      end
    end
    redirect_to user_url(current_user)
  end
  
  # 最終申請返信
  def reply_approval_info
    reply_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:change_at] == "1" 
        attendance.update_attributes(item) 
        flash[:success] = "変更チェックした申請を登録しました。申請中の場合は再登録が必要です。"
      elsif item[:change_at] == "1" && item[:mark_by_instructor] == "なし"
      attendance.update_attributes(overtime_at: nil, worked_contents: nil, overtime_mark: nil, mark_by_instructor: nil)
      flash[:success] = "変更チェックした申請を登録しました。申請中の場合は再登録が必要です。"
      end
    end
    
    if flash[:success].blank?
      flash[:danger] = "変更チェックをして下さい。"
    end
    redirect_to user_url(current_user)
  end
  
  # 勤怠ログ 
  def log_info
    @user = User.find(params[:id])
    if params["worked_on(1i)"].present? && params["worked_on(2i)"].present?
      year_month = "#{params["worked_on(1i)"]}/#{params["worked_on(2i)"]}"
      @day = DateTime.parse(year_month) if year_month.present?
      @attendances = @user.attendances.where(worked_on: @day.all_month).all.order("worked_on ASC")
    else
      @attendances = @user.attendances.all.order("worked_on ASC")
    end
  end
  
  # 勤怠変更申請
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:confirmation_mark].present?
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:success] = "指示者指定のある勤怠変更のみ更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、すべての変更申請をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end


  private

    # 勤怠変更申請
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :confirmation_mark, :mark_approval, :next_day])[:attendances]
    end
    # 残業申請
    def overtime_params
      params.require(:attendance).permit(:overtime_at, :overtime_next_day, :worked_contents, :overtime_mark, :mark_by_instructor)
    end
    # 残業承認
    def reply_overtime_params
      params.require(:user).permit(attendances: [:overtime_at, :overtime_next_day, :worked_contents, :overtime_mark, :mark_by_instructor, :change_at])[:attendances]
    end
    # 勤怠変更承認
    def reply_change_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :mark_approval, :change_at])[:attendances]
    end
    # 最終申請
    def approval_params
      params.require(:user).permit(attendances: [:finish_mark, :mark_by_finish, :appl_month])[:attendances]
    end
    # 最終申請承認
    def reply_approval_params
      params.require(:user).permit(attendances: [:finish_mark, :mark_by_finish, :change_at, :appl_month])[:attendances]
    end
    
    # 上長、または現在ログインしているユーザーを許可します。
    def superior_or_correct_user
      @user = User.find(params[:id]) if @user.blank?
      unless current_user?(@user) || current_user.superior?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
    
    def admin_not_correct_user
      @user = User.find(params[:id]) if @user.blank?
      if current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
  
end
