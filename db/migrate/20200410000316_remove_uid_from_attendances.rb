class RemoveUidFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :uid, :integer
  end
end
