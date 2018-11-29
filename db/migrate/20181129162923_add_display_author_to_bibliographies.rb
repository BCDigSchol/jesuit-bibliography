class AddDisplayAuthorToBibliographies < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :display_author, :text
  end
end
