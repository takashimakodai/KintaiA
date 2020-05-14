module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at_before.nil?
      return '退勤' if attendance.started_at_before.present? && attendance.finished_at_before.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。(翌日)
  def working_nexttimes(start, finish)
   format("%.2f", (((finish - start) / 60) / 60.0) + 24.0) 
  end
  # 残業当日の場合の時間を計算して返します。false
  def today_times(start, finish)
    format("%.2f", (((finish - (start + (finish.beginning_of_day - start.beginning_of_day))) / 60) / 60.0))
  end
  
  # 残業翌日のと場合の時間を計算して返します。
  def tomorrow_times(start, finish)
    format("%.2f", (((finish - (start + (finish.beginning_of_day - start.beginning_of_day))) / 60) / 60.0) + 24.0)
  end
  
end
