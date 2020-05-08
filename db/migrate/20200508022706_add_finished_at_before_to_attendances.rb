class AddFinishedAtBeforeToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :finished_at_before, :datetime
  end
end
