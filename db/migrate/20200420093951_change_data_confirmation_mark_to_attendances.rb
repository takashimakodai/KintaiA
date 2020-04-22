class ChangeDataConfirmationMarkToAttendances < ActiveRecord::Migration[5.2]
  def change
    change_column :attendances, :confirmation_mark, :string
  end
end
