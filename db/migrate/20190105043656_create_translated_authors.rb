class CreateTranslatedAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :translated_authors do |t|
      t.references :bibliography, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
