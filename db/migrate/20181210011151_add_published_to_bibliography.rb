class AddPublishedToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :published, :boolean
  end
end
