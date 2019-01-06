class AddSortNameToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :People, :sort_name, :text
    add_column :People, :display_name, :text
  end
end
