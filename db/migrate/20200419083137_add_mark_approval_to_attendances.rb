class AddMarkApprovalToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :mark_approval, :integer
  end
end
