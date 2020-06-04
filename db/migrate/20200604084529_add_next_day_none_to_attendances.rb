class AddNextDayNoneToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :next_day_none, :boolean
  end
end
