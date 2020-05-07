class AddChangedToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :changed, :boolean
  end
end
