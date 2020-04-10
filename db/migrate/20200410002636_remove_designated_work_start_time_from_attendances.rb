class RemoveDesignatedWorkStartTimeFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :designated_work_start_time, :datetime
  end
end
