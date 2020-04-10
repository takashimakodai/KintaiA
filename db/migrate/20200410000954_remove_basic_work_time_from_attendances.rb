class RemoveBasicWorkTimeFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :basic_work_time, :detetime
  end
end
