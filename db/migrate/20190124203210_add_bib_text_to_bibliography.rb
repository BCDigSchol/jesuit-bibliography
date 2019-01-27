class AddBibTextToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :bib_text_raw, :text
    add_column :bibliographies, :bib_text_mla, :text
    add_column :bibliographies, :bib_text_chicago, :text
    add_column :bibliographies, :bib_text_turabian, :text
  end
end
