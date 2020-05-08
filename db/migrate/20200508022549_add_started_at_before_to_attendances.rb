class AddStartedAtBeforeToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :started_at_before, :datetime
  end
end
