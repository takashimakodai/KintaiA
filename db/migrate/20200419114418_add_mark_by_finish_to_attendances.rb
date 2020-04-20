class AddMarkByFinishToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :mark_by_finish, :integer
  end
end
