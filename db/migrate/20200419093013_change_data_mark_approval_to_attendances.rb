class ChangeDataMarkApprovalToAttendances < ActiveRecord::Migration[5.2]
  def change
    change_column :attendances, :mark_approval, :string
  end
end
