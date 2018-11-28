class AddDisplayFieldsToBibliographies < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :display_title, :text
    add_column :bibliographies, :display_year, :text
  end
end
