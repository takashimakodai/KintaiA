class AddWorkedContentsToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :worked_contents, :string
  end
end
