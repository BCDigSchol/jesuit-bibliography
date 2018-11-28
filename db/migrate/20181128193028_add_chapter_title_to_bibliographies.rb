class AddChapterTitleToBibliographies < ActiveRecord::Migration[5.2]
  def change
    add_column :bibliographies, :chapter_title, :text
  end
end
