class ChangeDataMarkByInstructorToAttendances < ActiveRecord::Migration[5.2]
  def change
    change_column :attendances, :mark_by_instructor, :integer
  end
end
