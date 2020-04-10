class AddUidToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :uid, :integer
  end
end
