class AddBookChapterFieldsToBibliography < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :chapter_number, :text
    add_column :bibliographies, :book_title, :text
  end
end
