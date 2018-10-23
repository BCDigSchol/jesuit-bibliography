class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_role, :boolean, default: false
    add_column :users, :collaborator_role, :boolean, default: false
    add_column :users, :editor_role, :boolean, default: false
    add_column :users, :user_role, :boolean, default: true
  end
end
