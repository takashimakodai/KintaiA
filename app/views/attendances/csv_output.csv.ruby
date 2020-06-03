require 'csv'

CSV.generate do |csv|
  csv_column_names =%w(日付 出社時間 退社時間 出社時間(変更後) 退社時間(変更後))
  csv << csv_column_names
  @attendances.each do |attendance|
    csv_column_values = [
      attendance.worked_on.strftime("%m/%d"),
      attendance.started_at_before.present? ? attendance.started_at_before.strftime("%H:%M") : nil,
      attendance.finished_at_before.present? ? attendance.finished_at_before.strftime("%H:%M") : nil,
      attendance.started_at.present? && attendance.mark_approval == "承認" ? attendance.started_at.strftime("%H:%M") : nil,
      attendance.finished_at.present? && attendance.mark_approval == "承認" ? attendance.finished_at.strftime("%H:%M") : nil,
    ]
    csv << csv_column_values
  end
end

    