class RemoveDesignatedWorkEndTimeFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :designated_work_end_time, :datetime
  end
end
