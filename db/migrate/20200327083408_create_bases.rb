class CreateBases < ActiveRecord::Migration[5.2]
  def change
    create_table :bases do |t|
      t.integer :base_number
      t.string :base_name
      t.string :base_category
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
