class RemoveChangedFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :changed, :boolean
  end
end
