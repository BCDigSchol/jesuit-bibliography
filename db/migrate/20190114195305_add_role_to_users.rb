class AddRoleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer

    # remove old boolean role fields
    remove_column :users, :admin_role, :boolean
    remove_column :users, :associate_editor_role, :boolean
    remove_column :users, :assistant_editor_role, :boolean
    remove_column :users, :correspondent_role, :boolean
  end
end
