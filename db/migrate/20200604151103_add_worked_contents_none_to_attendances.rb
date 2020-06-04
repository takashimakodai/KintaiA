class AddWorkedContentsNoneToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :worked_contents_none, :string
  end
end
