class AddNoteNoneToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :note_none, :string
  end
end
