class AddOvertimeNextDaynoneToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :overtime_next_daynone, :boolean
  end
end
