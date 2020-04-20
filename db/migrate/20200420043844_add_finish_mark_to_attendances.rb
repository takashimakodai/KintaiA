class AddFinishMarkToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :finish_mark, :string
  end
end
