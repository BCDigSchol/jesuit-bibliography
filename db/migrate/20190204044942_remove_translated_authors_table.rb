class RemoveTranslatedAuthorsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :translated_authors
  end
end
