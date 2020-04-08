class AddOvertimeAtToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :overtime_at, :datetime
  end
end
