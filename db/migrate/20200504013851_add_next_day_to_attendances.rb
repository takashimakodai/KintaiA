class AddNextDayToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :next_day, :boolean
  end
end
