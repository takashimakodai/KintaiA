class AddBasicWorkTimeToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :basic_work_time, :datetime
  end
end
