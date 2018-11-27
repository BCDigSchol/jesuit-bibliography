class RemoveLanguageFromBibliographies < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :language, :text
  end
end
