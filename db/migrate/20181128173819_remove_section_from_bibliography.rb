class RemoveSectionFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :section, :text
  end
end
