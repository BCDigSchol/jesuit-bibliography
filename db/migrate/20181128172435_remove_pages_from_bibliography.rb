class RemovePagesFromBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :pages, :text
  end
end
