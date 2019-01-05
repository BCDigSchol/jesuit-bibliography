class CreateBookEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :book_editors do |t|
      t.references :bibliography, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
