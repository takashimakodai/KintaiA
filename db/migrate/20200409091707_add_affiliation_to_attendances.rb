class AddAffiliationToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :affiliation, :string
  end
end
