class AddBasicWorkTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :basic_work_time, :datetime
  end
end
