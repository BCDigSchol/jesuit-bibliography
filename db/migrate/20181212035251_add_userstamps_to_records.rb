class AddUserstampsToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :created_by, :text
    add_column :bibliographies, :modified_by, :text
    add_column :comments, :created_by, :text
    add_column :comments, :modified_by, :text
    add_column :entities, :created_by, :text
    add_column :entities, :modified_by, :text
    add_column :locations, :created_by, :text
    add_column :locations, :modified_by, :text
    add_column :periods, :created_by, :text
    add_column :periods, :modified_by, :text
    add_column :subjects, :created_by, :text
    add_column :subjects, :modified_by, :text
  end
end
