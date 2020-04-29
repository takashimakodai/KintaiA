require 'csv'

CSV.generate do |csv|
  csv_column_names =%w(日付 出社時間 退社時間)
  csv << csv_column_names
  @attendances.each do |attendance|
    csv_column_values = [
      attendance.worked_on.strftime("%m/%d"),
      attendance.started_at.present? ? attendance.started_at.strftime("%H:%M") : nil,
      attendance.finished_at.present? ? attendance.finished_at.strftime("%H:%M") : nil,
    ]
    csv << csv_column_values
  end
end

    