class RenameColumnsFromBibliography < ActiveRecord::Migration[5.2]
  def change
    rename_column :bibliographies, :secondary_url, :publisher_url
    rename_column :bibliographies, :title_translated, :translated_title
  end
end
