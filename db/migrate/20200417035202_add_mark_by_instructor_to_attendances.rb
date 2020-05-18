class AddMarkByInstructorToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :mark_by_instructor, :integer
  end
end
