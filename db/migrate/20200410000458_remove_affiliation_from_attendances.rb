class RemoveAffiliationFromAttendances < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendances, :affiliation, :string
  end
end
