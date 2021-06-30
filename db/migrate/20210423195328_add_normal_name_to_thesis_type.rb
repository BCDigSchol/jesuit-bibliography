class AddNormalNameToThesisType < ActiveRecord::Migration[5.2]
  def change
    add_index :thesis_types, :normal_name
  end
end
