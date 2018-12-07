class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_role, :boolean, default: false
    add_column :users, :associate_editor_role, :boolean, default: false
    add_column :users, :assistant_editor_role, :boolean, default: false
    add_column :users, :correspondent_role, :boolean, default: false
  end
end
