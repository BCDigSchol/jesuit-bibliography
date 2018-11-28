class RemoveTitleTertiaryFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :title_tertiary, :text
  end
end
