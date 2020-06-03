class AddNormalNameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :normal_name, :text
    add_column :entities, :normal_name, :text
    add_column :locations, :normal_name, :text
    add_column :journals, :normal_name, :text
    add_column :languages, :normal_name, :text
    add_column :periods, :normal_name, :text
    add_column :people, :normal_name, :text

    add_index :subjects, :normal_name
    add_index :entities, :normal_name
    add_index :locations, :normal_name
    add_index :journals, :normal_name
    add_index :languages, :normal_name
    add_index :periods, :normal_name
    add_index :people, :normal_name
  end
end
