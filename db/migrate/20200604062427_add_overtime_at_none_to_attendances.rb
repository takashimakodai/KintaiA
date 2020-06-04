class AddOvertimeAtNoneToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :overtime_at_none, :datetime
  end
end
