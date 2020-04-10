class AddDesignatedWorkStartEndToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :designated_work_end_time, :datetime
  end
end
