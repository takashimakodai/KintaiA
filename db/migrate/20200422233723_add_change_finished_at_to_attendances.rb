class AddChangeFinishedAtToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :change_finished_at, :datetime
  end
end
