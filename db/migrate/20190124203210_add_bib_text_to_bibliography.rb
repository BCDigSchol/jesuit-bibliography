class AddBibTextToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :bib_text, :text
  end
end
