class AddChangeStratedAtToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :change_started_at, :datetime
  end
end
