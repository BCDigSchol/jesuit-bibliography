class RemoveTitleSecondaryFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :title_secondary, :text
  end
end
