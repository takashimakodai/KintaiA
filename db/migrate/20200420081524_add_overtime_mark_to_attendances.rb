class AddOvertimeMarkToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :overtime_mark, :string
  end
end
