class AddConfirmationMarkToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :confirmation_mark, :string
  end
end
