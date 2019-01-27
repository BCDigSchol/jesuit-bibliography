class RenameBibTextFieldsInBibliography < ActiveRecord::Migration[5.2]
  def change
    remove_column :bibliographies, :bib_text_raw
    remove_column :bibliographies, :bib_text_mla
    remove_column :bibliographies, :bib_text_chicago
    remove_column :bibliographies, :bib_text_turabian

    add_column :bibliographies, :bibtex, :text
    add_column :bibliographies, :bibtex_mla, :text
    add_column :bibliographies, :bibtex_chicago, :text
    add_column :bibliographies, :bibtex_turabian, :text
  end
end
