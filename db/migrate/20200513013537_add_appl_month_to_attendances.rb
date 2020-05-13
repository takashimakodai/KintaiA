class AddApplMonthToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :appl_month, :datetime
  end
end
