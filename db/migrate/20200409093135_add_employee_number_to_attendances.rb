class AddEmployeeNumberToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :employee_number, :integer
  end
end
