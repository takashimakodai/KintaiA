class AddChangeAtToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :change_at, :boolean
  end
end
