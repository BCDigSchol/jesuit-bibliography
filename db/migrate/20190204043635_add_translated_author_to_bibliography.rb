class AddTranslatedAuthorToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :translated_author, :text
  end
end
