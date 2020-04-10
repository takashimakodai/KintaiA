class RemoveEmployeeNumberFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :employee_number, :integer
  end
end
